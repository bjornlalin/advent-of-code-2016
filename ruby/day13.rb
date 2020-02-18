#!/usr/bin/ruby -w

require 'set'

class Maze

  def initialize(number)
    @number = number
  end

  # BFS Search
  def shortest_path_between(start, goal)

    queue = [start]
    distances = {
      start => 0
    }

    while !queue.empty? do
      pos = queue.pop
      dist = distances[pos]

      # We reached the goal - stop searching
      break if pos == goal

      # Queue up neighbours (BFS step)
      [[1,0],[0,1],[-1,0],[0,-1]].each do |dx,dy|
        nextpos = [pos[0] + dx, pos[1] + dy]
        if nextpos[0] >= 0 && nextpos[1] >= 0 && path?(nextpos) && !distances.key?(nextpos)
          distances[nextpos] = dist + 1
          queue.prepend(nextpos)
        end
      end
    end

    return distances[goal]
  end

  # BFS Search
  def reachable_within(start, num_steps)

    queue = [start]
    distances = {
      start => 0
    }

    while !queue.empty? do
      pos = queue.pop
      dist = distances[pos]

      # We reached the goal - stop searching
      break if dist == num_steps

      # Queue up neighbours (BFS step)
      [[1,0],[0,1],[-1,0],[0,-1]].each do |dx,dy|
        nextpos = [pos[0] + dx, pos[1] + dy]
        if nextpos[0] >= 0 && nextpos[1] >= 0 && path?(nextpos) && !distances.key?(nextpos)
          distances[nextpos] = dist + 1
          queue.prepend(nextpos)
        end
      end
    end

    return distances.length
  end
  
  def path?(coord)
    return calculate_type(coord) == :path
  end

  def calculate_type(coord)
    x, y = coord
    num = (x*x + 3*x + 2*x*y + y + y*y) + @number
    if (bits_1(num) % 2) == 0 
      return :path
    else
      return :wall
    end
  end

  def bits_1(num)
    n_1 = 0
    while num > 0 do
      n_1 += num & 1
      num >>= 1
    end
    return n_1
  end
end

# Test input
maze = Maze.new(10)
puts "Test input: #{maze.shortest_path_between([1,1],[7,4])}"

# Solution part 1
maze = Maze.new(1362)
puts "Part 1: #{maze.shortest_path_between([1,1], [31,39])}"
puts "Part 2: #{maze.reachable_within([1,1], 50)}"

