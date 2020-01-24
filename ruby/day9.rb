#!/usr/bin/ruby -w

class Decompressor
    def initialize input
        @buffer = input.chars
        @pos = 0
        @output = ''
    end

    def decompress
        while @pos < @buffer.length
            if @buffer[@pos] == '('
                @pos += 1
                consume_marker
            else
                @output += @buffer[@pos]
                @pos += 1
            end
        end
        @output
    end

    def consume_marker
        marker = ''
        while @pos < @buffer.length && @buffer[@pos] != ')'
            marker += @buffer[@pos]
            @pos += 1
        end

        @pos += 1
        repeat(marker.split('x')[0].to_i, marker.split('x')[1].to_i)
    end

    def repeat(n_chars, n_repeats)
        repeated = @buffer[@pos...(@pos+n_chars)]
        @output += (repeated * n_repeats).join('')
        @pos += n_chars
    end

end

class DecompressorV2
    def initialize(input)
        @buffer = input.chars
        @pos = 0
        @output_len = 0
    end

    def decompress
        while @pos < @buffer.length
            if @buffer[@pos] == '('
                @pos += 1
                consume_marker
            else
                @output_len += 1
                @pos += 1
            end
        end

        @output_len
    end

    def consume_marker
        marker = ''
        while @pos < @buffer.length && @buffer[@pos] != ')'
            marker += @buffer[@pos]
            @pos += 1
        end

        @pos += 1
        repeat(marker.split('x')[0].to_i, marker.split('x')[1].to_i)
    end

    def repeat(n_chars, n_repeats)
        # Note on solution:
        #
        # the trick is to not expand the string with all repeats, but solve for one
        # and then multiple the length of that by the number of times it is repeated!
        #
        # This changes runtime from hours to milliseconds!! (old version commented out)
        #
        repeated = @buffer[@pos...(@pos+n_chars)]
        @output_len += n_repeats * DecompressorV2.new(repeated.join('')).decompress
        #@output_len += DecompressorV2.new((repeated * n_repeats).join('')).decompress
        @pos += n_chars
    end
end

def test
    puts "Unit test for part 1"
    puts "--------------------"
    ["ADVENT", "A(1x5)BC", "(3x3)XYZ", "A(2x2)BCD(2x2)EFG", "(6x1)(1x3)A", "X(8x2)(3x3)ABCY"].each do |input|
        puts "#{input} => #{Decompressor.new(input).decompress}"
    end
    puts
end

def testV2
    puts "Unit test for part 2"
    puts "--------------------"
    ["(3x3)XYZ", "X(8x2)(3x3)ABCY", "(27x12)(20x12)(13x14)(7x10)(1x12)A", "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"].each do |input|
        puts "#{input} => #{DecompressorV2.new(input).decompress}"
    end
    puts
end

def solve
    puts "Solving for puzzle input"
    puts "------------------------"
    STDIN.readlines.each do |line|
        puts "Part 1: Decompressed string has length #{Decompressor.new(line).decompress.length}"
        puts "Part 2: Decompressed string has length #{DecompressorV2.new(line).decompress}"
    end
end  

test
testV2
solve

