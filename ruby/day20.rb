#!/usr/bin/ruby -w

class IPRange
  attr_accessor :low, :high

  def initialize(low, high)
    @low = low
    @high = high
  end

  def to_s
    "IP Range: #{low}-#{high} (length #{high-low+1})"
  end
end

def whitelisted_ranges(blacklisted_ranges, max: 4294967295)
  allowed = []
  highest_blocked = -1
  sorted = blacklisted_ranges.sort { |x,y| x.low - y.low }

  sorted.each do |range|
    allowed << IPRange.new(highest_blocked + 1, range.low - 1) if range.low > highest_blocked + 1
    highest_blocked = range.high if range.high > highest_blocked
  end

  allowed << IPRange.new(highest_blocked + 1, max) if max > highest_blocked
  allowed
end

test_blacklist = [
  IPRange.new(5, 8), 
  IPRange.new(0, 2), 
  IPRange.new(4, 7)
]

test_whitelist = whitelisted_ranges(test_blacklist, max: 9)
puts
puts 'Test input'
puts '##########'
puts
puts "Part 1: The lowest allowed IP is #{test_whitelist.first.low}"
puts "Part 2: The number of allowed IPs are #{test_whitelist.map { |range| range.high - range.low + 1}.sum}"
puts 
puts 'complete whitelist:'
puts
puts test_whitelist
puts

blacklist = []
STDIN.readlines.each do |line|
  blacklist << IPRange.new(
    line.split('-')[0].to_i,
    line.split('-')[1].to_i
  )
end

whitelist = whitelisted_ranges(blacklist)
puts
puts 'Puzzle input'
puts '############'
puts
puts "Part 1: The lowest allowed IP is #{whitelist.first.low}"
puts "Part 2: The number of allowed IPs are #{whitelist.map { |range| range.high - range.low + 1}.sum}"
puts
puts 'complete whitelist:'
puts
puts whitelist
puts
