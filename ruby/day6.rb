#!/usr/bin/ruby -w

words = []

# Read lines
STDIN.readlines.each do |line|
    words << line.chars
end

least_frequent = ''
most_frequent = ''
(0...8).each do |pos|
    counts = {}
    words.each do |word|
        char = word[pos]
        counts[char] = 0 unless counts.keys.include? char
        counts[char] += 1
    end
    sorted_1 = counts.sort_by {|k, v| [-v]}
    sorted_2 = counts.sort_by {|k, v| [v]}
    most_frequent += sorted_1[0][0]
    least_frequent += sorted_2[0][0]
end

puts "Part 1: #{most_frequent}"
puts "Part 2: #{least_frequent}"


