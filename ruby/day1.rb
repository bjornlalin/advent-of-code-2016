#!/usr/bin/ruby -w

class Travel

    def initialize
        @pos = [0, 0]
        @dir = 0
        @visited = {}
        @md_fr = nil
    end

    def move(instr)

        # Get the first letter (R or L)
        _dir = instr[0]

        # Get the numeric value (number of steps to move)
        _steps = instr.scan(/\d+/)[0].to_i

        # Turn
        @dir = @dir + 1 if _dir == 'R'
        @dir = @dir - 1 if _dir == 'L'
        
        # Modulo for turning
        @dir -= 4 if @dir >= 4
        @dir += 4 if @dir < 0

        # Take steps (1 step at a time to detect visited locations)
        _steps.times do |i|
            case @dir
            when 0 # North
                @pos[1] += 1 
            when 1 # East
                @pos[0] += 1 
            when 2 # South
                @pos[1] -= 1
            when 3 # West
                @pos[0] -= 1
            end

            if @visited.key?(@pos)
                # Remember the first revisited location
                @md_fr = @md_fr || self.manhattan_dist
                # Print revisited locations (debug)
                # puts "Revisited location at position #{@pos} at distance #{self.manhattan_dist}" if @visited.key?(@pos)
            end

            # Keep track of all visited locations
            @visited[@pos] = @pos

        end
        
    end

    def manhattan_dist
        return @pos[0].abs + @pos[1].abs
    end

    def manhattan_dist_first_revisited
        return @md_fr
    end

end


travel = Travel.new

STDIN.readlines.each do |line|
    line.split(',').each do |instr|
        instr.strip!
        travel.move(instr)
    end
end

puts "Part 1: Manhattan distance from drop location (0,0) to HQ is #{travel.manhattan_dist}"
puts "Part 2: Manhattan distance from drop location (0,0) to HQ is #{travel.manhattan_dist_first_revisited}"
