#!/usr/bin/ruby -w

class Keypad
    def initialize
        @key = 5
        @pressed = []
    end

    def press(instr)
        raise "Not Implemented"
    end

    def code
        return @pressed
    end
end

class Keypad1 < Keypad

    # Simple 3x3 keypad layout
    #
    #    1 2 3
    #    4 5 6
    #    7 8 9
    #
    def press(instr)
        instr.scan(/./) do |step|
            case step
            when 'L'
                @key -= 1 unless [1,4,7].include?(@key)
            when 'U'
                @key -= 3 unless [1,2,3].include?(@key)
            when 'R'
                @key += 1 unless [3,6,9].include?(@key)
            when 'D'
                @key += 3 unless [7,8,9].include?(@key)
            end
        end

        @pressed << @key
    end
end

class Keypad2 < Keypad
    @@Layout = {
        [1, 'D'] => 3,
        [2, 'R'] => 3, [2, 'D'] => 6,
        [3, 'U'] => 1, [3, 'R'] => 4, [3, 'D'] => 7, [3, 'L'] => 2,
        [4, 'L'] => 3, [4, 'D'] => 8,
        [5, 'R'] => 6,
        [6, 'U'] => 2, [6, 'R'] => 7, [6, 'D'] => :A, [6, 'L'] => 5,
        [7, 'U'] => 3, [7, 'R'] => 8, [7, 'D'] => :B, [7, 'L'] => 6,
        [8, 'U'] => 4, [8, 'R'] => 9, [8, 'D'] => :C, [8, 'L'] => 7,
        [9, 'L'] => 8,
        [:A, 'U'] => 6, [:A, 'R'] => :B,
        [:B, 'U'] => 7, [:B, 'R'] => :C, [:B, 'D'] => :D, [:B, 'L'] => :A,
        [:C, 'U'] => 8, [:C, 'L'] => :B,
        [:D, 'U'] => :B
    }

    # More complex keypad layout:
    #
    #          1
    #        2 3 4
    #      5 6 7 8 9
    #        A B C
    #          D
    #
    def press(instr)

        instr.scan(/./) do |step|
            @key = @@Layout[[@key, step]] if @@Layout.key?([@key, step])
        end

        @pressed << @key
    end
end

keypad = Keypad1.new
keypad2 = Keypad2.new

STDIN.readlines.each do |line|
    line.strip!
    keypad.press(line)
    keypad2.press(line)
end

puts "Part 1: Toilet code is #{keypad.code}"
puts "Part 2: Toilet code is #{keypad2.code}"
