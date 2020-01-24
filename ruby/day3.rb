#!/usr/bin/ruby -w

class Triangle
    def initialize (sides)
        @sides = sides.map { |side| side.to_i }
    end

    # "The sum of any two sides has to be larger than the remaining side"
    def is_possible
        return (@sides[0] + @sides[1] > @sides[2]) && (@sides[0] + @sides[2] > @sides[1]) && (@sides[1] + @sides[2] > @sides[0])
    end

end

lines = []

# Read lines
STDIN.readlines.each do |line|
    lines << line.strip
end

# Part 1
n_valid = lines.map { |line| Triangle.new(line.split(' ')).is_possible ? 1 : 0 }.reduce(:+)

puts "Part 1: There are #{n_valid} valid triangles"

# Part 2
n_valid = 0
n_lines = lines.length
(0...n_lines).step(3).to_a.each do |row|
    (0...3).to_a.each do |col|
        sides = []  << lines[row].split(' ')[col] \
                    << lines[row + 1].split(' ')[col] \
                    << lines[row + 2].split(' ')[col]
        n_valid += 1 if Triangle.new(sides).is_possible
    end
end

puts "Part 2: There are #{n_valid} valid triangles"

