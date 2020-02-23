#!/usr/bin/ruby -w

class Tiles
  def self.num_safe(pattern)
    pattern.split('').select { |c| c == '.' }.length
  end

  def self.next(pattern)
    # add a safe tile the edges
    padded = '.' + pattern + '.'
    next_pattern = ''
    (1...(padded.length-1)).each do |i|
      if %w[^^. .^^ ^.. ..^].include? padded[(i-1)..(i+1)]
        next_pattern += '^'
      else
        next_pattern += '.'
      end
    end

    next_pattern
  end
end

def solve(pattern, rows, print: true)
  num_safe = 0
  rows.times.each do
    puts pattern if print
    num_safe += Tiles.num_safe(pattern)
    pattern = Tiles.next(pattern)
  end

  num_safe
end

# Solve for test input
puts "'..^^.' with 3 rows has #{solve('..^^.', 3)} safe tiles (expected: 6)"
puts "'.^^.^.^^^^' with 10 rows has #{solve('.^^.^.^^^^', 10)} safe tiles (expected: 38)"

# Solve for real puzzle input
STDIN.readlines.each do |line|
  puts "Part 1: Puzzle input with 40 rows has #{solve(line.strip(), 40)} safe tiles"
  puts "Part 2: Puzzle input with 400000 rows has #{solve(line.strip(), 400000, print: false)} safe tiles"
end