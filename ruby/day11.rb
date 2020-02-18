require 'set'

def print(msg)
  puts msg if false
end

# Some helpers to manage items (treated as strings "<id><type>")
class Item
  def self.new(id, type)
    return "#{id}#{type}"
  end

  def self.id(item)
    item.chars.first
  end
  
  def self.type(item)
    item.chars.last
  end

  def self.gen?(item)
    item.chars.last == 'G'
  end

  def self.chip?(item)
    !Item.gen?(item)
  end
  
  # 1G -> 1M, 2M -> 2G
  def self.counterpart(item)
    item.delete_suffix(item.chars.last) + (item.chars.last == 'G' ? 'M' : 'G')
  end
end

# We generate a canonical state which only considers which un-identified pairs
# are on which sets of floors, i.e. a state where there is one pair on floor 1
# and a second which has generator on floor 2 and chip on floor 4, is equal to
# the same constellation where it's the second pair on floor 1 and the first pair
# which has the generator on floor 2 and chip on floor 4...
class CanonicalState
  attr_reader :elevator, :canonical

  def initialize(state)
    @elevator = state.elevator
    
    pairs = {}
    for floor in 0..3 do
      state.floors[floor].each do |item|
        id = Item.id(item)
        type = Item.type(item)
        pairs[id] ||= {}
        pairs[id][type] = floor
      end
    end

    # Count number of identical pairs floor generator / floor microchip and make a set out of it
    @canonical = pairs.values.map { |pair| [pair['M'], pair['G']] }.group_by(&:itself).transform_values!(&:size)
    @canonical = @canonical.keys.map { |key| "#{key[0]}#{key[1]}#{@canonical[key]}" }
    @canonical = @canonical.to_set()
  end

  def hash
    "#{self.elevator} #{self.canonical.hash}".hash
  end
  
  def eql?(other)
    self.elevator == other.elevator &&
    self.canonical == other.canonical    
  end
end

class State
  attr_reader :floors, :elevator
  
  def initialize(elevator = 0)
    @elevator = elevator
    @floors = [Set.new, Set.new, Set.new, Set.new]
  end

  def clone
    clone = State.new(@elevator)
    for floor in 0..3 do
      @floors[floor].each do |item|
        clone.add(item: item, floor: floor)
      end
    end
    clone
  end

  def add(item:, floor:)
    @floors[floor].add(item)
  end

  def move(item:, from:, to:)
    @floors[from] -= [item]
    @floors[to] += [item]
    @elevator = to
  end

  def has_unprotected_chips?(floor_items)
    gens = floor_items.select { |item| Item.gen?(item) }
    chips = floor_items.select { |item| Item.chip?(item) }
    unprotected = chips.select { |chip| !gens.include?(Item.counterpart(chip)) }
    
    return unprotected.length > 0 && gens.length > 0
  end

  def can_move(items:, from:, to:)
    floor_from = @floors[to].clone
    floor_to = @floors[to].clone

    items.each do |item|
      floor_from -= [item]
      floor_to += [item]
    end

    return !(has_unprotected_chips?(floor_from) || has_unprotected_chips?(floor_to))
  end

  # which states are reachable from this state?
  def next_states
    possible = []
    # possible states going up
    possible += next_states_in_dir(1) if @elevator != 3
    # possible states going down only make sense if there are actually some items available at lower floors
    items_lower = @floors[0...@elevator].map { |floor| floor.length }.sum
    possible += next_states_in_dir(-1) if (@elevator != 0) && (items_lower > 0)

    return possible
  end

  def next_states_in_dir(dir)
    possible = []
    to = @elevator + dir

    @floors[@elevator].each do |item|
      # We can move the generator and the item together, but only if there are 
      # no other unprotected chips on the target floor...
      if (floors[@elevator].include? Item.counterpart(item))
        if self.can_move(items: [item, Item.counterpart(item)], from: @elevator, to: to)
          state = self.clone
          state.move(item: item, from: @elevator, to: to)
          state.move(item: Item.counterpart(item), from: @elevator, to: to)
          possible << state unless possible.include?(state)
        end
      end

      # We can move an item individually
      if self.can_move(items: [item], from: @elevator, to: to)
        state = self.clone
        state.move(item: item, from: @elevator, to: to)
        possible << state unless possible.include?(state)
      end

      # We can move the generator together with another generator
      (self.floors[@elevator] - [item]).each do |item2|
        if self.can_move(items: [item, item2], from: @elevator, to: to)
          state = self.clone
          state.move(item: item, from: @elevator, to: to)
          state.move(item: item2, from: @elevator, to: to)
          possible << state unless possible.include?(state)
        end
      end
    end

    return possible
  end

  def final_state?
    @floors[0].length == 0 && @floors[1].length == 0 && @floors[2].length == 0 && @elevator == 3  
  end

  def to_s
    str = ''
    for floor in 0..3 do
      str = "#{str}\nFloor #{3-floor}: #{@floors[3-floor].flat_map(&:to_s)} #{((3-floor) == @elevator ? '<= ELEVATOR' : '')}"
    end
    
    str
  end
end

class Algorithm

  class Step
    attr_reader :depth, :state, :history
    def initialize(depth, state, history)
      @depth = depth
      @state = state
      @history = history
    end
  end

  def initialize(state)
    @initial = state
    @queue = []
    @seen = Set.new
  end

  def run
    @queue.unshift(Step.new(0, @initial, []))
    
    while @queue.length > 0
      step = @queue.pop

      # Let's see where we are ...
      print "\ndepth: #{step.depth}"
      print step.state

      # if we found the final solution, ... great!
      if step.state.final_state?
        return step
      end

      # continue searching more moves
      step.state.next_states.each do |next_state|
        next_canonical = CanonicalState.new(next_state)
        if !@seen.include?(next_canonical)
          @queue.unshift(Step.new(step.depth+1, next_state, step.history + [step.state]))
          @seen.add(next_canonical)
        end
      end
    end

    return nil
  end
end

class Input

  def initialize
    @id = 0
    @ids = {}
    @floor = 0
    @initial = State.new
  end

  def consume(line)
    [[/a ([a-z]+) generator/, 'G'], [/a ([a-z]+)-compatible microchip/, 'M']].each do |regex, type|
      line.scan(regex) do |match| 
        unless @ids.has_key? match
          @ids[match] = @id
          @id += 1
        end
        @initial.add(item: Item.new(@ids[match], type), floor: @floor)
      end
    end
    @floor += 1
  end

  def state
    return @initial.clone
  end
end

# Read and parse input
parser = Input.new
STDIN.readlines.each do |line|
  parser.consume(line)
end

# Part 1: search for optimal solution
initial = parser.state
result = Algorithm.new(initial).run
puts "Part 1: Reached optimal solution after #{result&.depth} steps"
#puts result.history, result.state

# Part 2: add two more sets of gen/chips on first floor 
initial.add(item: Item.new('5', 'G'), floor: 0)
initial.add(item: Item.new('5', 'M'), floor: 0)
initial.add(item: Item.new('6', 'G'), floor: 0)
initial.add(item: Item.new('6', 'M'), floor: 0)

result = Algorithm.new(initial).run
puts "Part 2: Reached optimal solution after #{result&.depth} steps"
#puts result.history, result.state
