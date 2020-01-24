#!/usr/bin/ruby -w

class Room
    def initialize(str)
        @checksum = str.scan(/\[([a-z]+)\]$/).first.first
        @sector_id = str.scan(/([0-9]+)\[/).first.first
        @letters = str.scan(/^([a-z|-]*)/).first.first[0...-1] # Remove trailing '-'
    end

    def sector_id
        @sector_id
    end

    def is_real
        # Count occurances of each character and sort by 1) value
        # and 2) alphabetically by key
        @counts = @letters
        .gsub(/-/, '')
        .chars
        .group_by(&:itself)
        .map { |letter, list| [letter, list.count] }.to_h
        .sort_by {|k, v| [-v, k]}.to_h

        # Check if the top 5 items correspond to given checksum
        return @counts.keys[0...5].join('') == @checksum
    end

    def decrypt
        Room._decrypt(@letters, @sector_id.to_i)
    end

    def self._decrypt(str, shift)
        decrypted = ''
        str.chars.each do |char|
            if char == '-'
                decrypted += ' '
            else
                decrypted += (((char.ord - 'a'.ord + shift) % 26) + 'a'.ord).chr
            end
        end
        decrypted
    end
end

#
# Let's go ...
#

rooms = []

# Read lines
STDIN.readlines.each do |line|
    rooms << Room.new(line)
end

# Part 1: Sum up the sector id of all valid rooms
sum_sector_ids = rooms.map { |room| room.is_real ? room.sector_id.to_i : 0 }.reduce(:+)
puts "Part 1: the sum of all sector IDs for real rooms is #{sum_sector_ids}"

# Part 2: Find the north pole-related decrypted words
rooms.each { |room| puts "Part 2: The room with sector id #{room.sector_id} decrypts to '#{room.decrypt}'" if room.decrypt.include? "northpole" }