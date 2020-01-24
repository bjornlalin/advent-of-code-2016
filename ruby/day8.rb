#!/usr/bin/ruby -w

class Screen
    def initialize(rows, cols)
        @rows = rows
        @cols = cols
        @data = Array.new(rows) { Array.new(cols) {0}}
    end

    def rect(w, h)
        w = @cols if w > @cols
        h = @rows if h > @rows
        (0...h).each do |row|
            @data[row][0...w] = [1] * w
        end
    end

    def rotate_row(row, by)
        @data[row] = @data[row][(@cols-by)...@cols] + @data[row][0...(@cols-by)]
    end

    def rotate_col(col, by)
        # Create copy of columncolumn
        column = []
        (0...@rows).each { |row| column << @data[row][col] }
        # Rotate
        rotated = column[(@rows-by)...@rows] + column[0...(@rows-by)]
        # Assign rotated column values to screen matrix
        (0...@rows).each { |row| @data[row][col] = rotated[row] }
    end

    def execute(instruction)
        cmd = instruction.split(' ')[0]
        case cmd
        when 'rect'
            param = instruction.split(' ')[1]
            w = param.split('x')[0].to_i
            h = param.split('x')[1].to_i
            rect(w, h)
        when 'rotate'
            which = instruction.split(' ')[1]
            index = instruction.split(' ')[2].split('=')[1].to_i
            by = instruction.split(' ').last.to_i
            if which == 'row'
                rotate_row(index, by)
            elsif which == 'column'
                rotate_col(index, by)
            end
        end
    end

    def print(empty:'.')
        (0...@rows).each do |row|
            puts @data[row][0..@cols].map{|x| x == 0 ? empty : '#'}.reduce(:+)
        end
    end

    def lit
        @data.map { |cols| cols.inject :+ }.inject :+
    end
end

screen = Screen.new(6,50)

STDIN.readlines.each do |line|
    screen.execute(line)
end

puts "Part1: There are #{screen.lit} positions lit"
puts "Part2: "; screen.print(empty:' ')
