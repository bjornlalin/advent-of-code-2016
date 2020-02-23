#!/usr/bin/ruby -w

class Elf
  attr_accessor :number, :presents
  def initialize(number, presents)
    @number = number
    @presents = presents
  end

  def transfer_presents_from(elf)
    @presents += elf.presents
    elf.presents = 0
  end
end

class Node
  attr_accessor :data, :prev, :next

  def initialize(data, prev_node = nil, next_node = nil)
    @data = data
    @prev = prev_node
    @next = next_node
  end
end

class Round
  attr_reader :length, :head

  def initialize
    @head = nil
    @tail = nil
    @length = 0
  end

  def insert(data)
    @length += 1
    if @head == nil
      @head = Node.new(data, nil, nil)
      @tail = @head
    else
      @tail.next = Node.new(data, @tail)
      @tail = @tail.next
    end
  end

  def remove(node)
    # Remove node from linked list
    node.prev&.next = node.next
    node.next&.prev = node.prev

    # Decrease length of list
    @length -= 1

    # Make sure head/tail pointers are still correct
    @head = node.next if node == @head
    @tail = node.prev if node == @tail
  end

  def attachTailToHead
    @tail.next = @head
    @head.prev = @tail
    self
  end

  def find_opposite(node)
    (self.length/2).times do 
      node = node.next
    end

    node
  end
end

# Helper method
def create_circle(n)
  round = Round.new
  n.times do |num|
    round.insert(Elf.new(num+1, 1))
  end

  round.attachTailToHead
end

def solve_part1(n)
  round = create_circle(n)
  node = round.head

  while round.length > 1 do
    neighbour = node.next

    # puts "Elf #{node.data.number} takes #{neighbour.data.presents} presents from Elf #{neighbour.data.number}"
    node.data.transfer_presents_from(neighbour.data)
    round.remove(neighbour)
    node = node.next
  end

  node # This is the last node in the game
end

#
# For this version of the game, we cannot simply walk through the entire 
# circle to find the neighbour sitting straight across each time, since
# that takes O(n) making the whole solution O(n^2). That's too much for 3*10^6
# number of nodes in the circular double-linked list I am using. 
# 
# Instead we find the direct opposite neighbour only once and keep a pointer
# which we update together with the current player, which makes the solution
# O(n). Only need to take care of the cases when there is an uneven or even
# number of elfs in the round.
#
def solve_part2(n)
  round = create_circle(n)
  node = round.head
  neighbour = round.find_opposite(node)

  while round.length > 1 do
    # puts "Elf #{node.data.number} takes #{neighbour.data.presents} presents from Elf #{neighbour.data.number}"
    node.data.transfer_presents_from(neighbour.data)
    round.remove(neighbour)

    node = node.next
    neighbour = neighbour.next
    neighbour = neighbour.next if (round.length + 1) % 2 == 1
  end

  node # This is the last node in the game
end

# Solve for test input
puts "Test input for part 1: Winner is Elf #{solve_part1(5).data.number}"
puts "Test input for part 2: Winner is Elf #{solve_part2(5).data.number}"

# Solve for puzzle input
puts "Part 1: Winner is Elf #{solve_part1(3012210).data.number}"
puts "Part 2: Winner is Elf #{solve_part2(3012210).data.number}"