#!/usr/bin/ruby -w

class DiscCleaner
  def initialize(pattern)
    @pattern = pattern.split('').map(&:to_i)
  end

  def self.expand(a)
    a + [0] + a.dup.reverse.map { |i| i == 0 ? 1 : 0 }
  end

  def self.checksum(content)
    offset = 0
    checksum = []
    while offset+1 < content.length do
      checksum << (content[offset] == content[offset+1] ? 1 : 0) 
      offset += 2
    end

    return (checksum.length % 2 == 0) ? self.checksum(checksum) : checksum
  end

  def fill_and_calculate_checksum(length)
    # Clone pattern to avoid changing original data
    tmp = @pattern.dup

    # Fill disc using dragon curve expansion algo
    while tmp.length <= length do
      tmp = DiscCleaner.expand(tmp)
    end

    # Truncate to requested length
    tmp = tmp[0...length]

    # Calculate and return checksum (as a string)
    DiscCleaner.checksum(tmp).map(&:to_s).join('')
  end
end

def solve(line, length)
  puts "Puzzle input of length #{length}"
  puts "============"
  puts "Checksum: #{DiscCleaner.new(line).fill_and_calculate_checksum(length)}"
  puts
end

def unit_tests
  puts "Unit tests"
  puts "=========="
  puts "Dragon curve for 1 => #{DiscCleaner.expand([1])} (expected: '100')"
  puts "Dragon curve for 0 => #{DiscCleaner.expand([0])} (expected: '001')"
  puts "Dragon curve for 11111 => #{DiscCleaner.expand([1,1,1,1,1])} (expected: '11111000000')"
  puts "Dragon curve for 111100001010 => #{DiscCleaner.expand([1,1,1,1,0,0,0,0,1,0,1,0])} (expected: '1111000010100101011110000')"
  puts "Checksum of 110010110100 == #{DiscCleaner.checksum([1,1,0,0,1,0,1,1,0,1,0,0])} (expected: '100')"
  puts ""
end

# Run unit tests of individual functions
unit_tests

# Solve for test input
solve('10000', 20)

# Solve for real input
STDIN.readlines.each do |line|
  solve(line, 272)
  solve(line, 35651584)
end
