#!/usr/bin/ruby -w

require 'digest/md5'

#
# Problem was solved using a BFS.
#
# State class contains each state of the search algorithm and includes
# logic to generate subsequent states.
#
# Maze class implements the algorithm and keeps track of walls, etc.
#

OPEN = ['b','c','d','e','f']
MOVES = { 
  U: [0,-1], 
  D: [0,1], 
  L: [-1,0], 
  R: [1,0] 
}

class State
  attr_reader :x, :y, :path

  def initialize(x, y, path)
    @x = x
    @y = y
    @path = path
  end

  def digest(passcode)
    Digest::MD5.hexdigest(passcode + path_s)
  end

  def move(direction)
    State.new(x + MOVES[direction][0], y + MOVES[direction][1], path + [direction.to_s])
  end

  def path_s
    path.join('')
  end

  def to_s
    "(#{x},#{y}): [#{path_s}]"
  end
end

# Solve the maze by BFS
class Maze
  def initialize(passcode)
    @passcode = passcode
  end

  def next_states(state)
    digest = state.digest(@passcode)
    next_states = []
    next_states << state.move(:U) if OPEN.include?(digest[0]) && state.y > 0
    next_states << state.move(:D) if OPEN.include?(digest[1]) && state.y < 3
    next_states << state.move(:L) if OPEN.include?(digest[2]) && state.x > 0
    next_states << state.move(:R) if OPEN.include?(digest[3]) && state.x < 3

    next_states
  end

  def shortest
    # Push initial state
    states = [] << State.new(0, 0, [])

    until states.empty? do
      # Get next state from queue (pop from end of queue)
      state = states.pop

      if (state.x == 3 && state.y == 3)
        # We found the goal, we're done
        return state
      else
        # Queue up next states to look at (add to beginning of queue)
        states = next_states(state) + states
      end
    end
  end

  def longest
    # Push initial state
    states = [] << State.new(0, 0, [])
    longest = nil

    until states.empty? do
      # Get next state from queue (pop from end of queue)
      state = states.pop

      if (state.x == 3 && state.y == 3)
        # We found a longer path, keep track of it
        longest = state
      else
        # Queue up next states to look at (add to beginning of queue)
        states = next_states(state) + states
      end
    end

    # No more paths found, return longest found
    longest
  end
end

# Main method
def solve(passcode)
  puts "Puzzle input: #{passcode}"
  puts "============"
  puts "Shortest path to vault is: #{Maze.new(passcode).shortest.path_s}"
  puts "Longest path to vault is #{Maze.new(passcode).longest.path_s.length} steps long"
  puts
end

# Solve for test input
solve('ihgpwlah')
solve('kglvqrro')
solve('ulqzkmiv')

# Solve for real puzzle input
STDIN.readlines.each do |line|
  solve(line.strip())
end