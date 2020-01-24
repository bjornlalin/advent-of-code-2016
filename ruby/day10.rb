#!/usr/bin/ruby -w

class Output
    def initialize(id)
        @id = id
        @values = []
    end

    def value=(value)
        @values << value
    end

    def to_s
        @id + " (values=" + @values.to_s + ")"
    end
end

class Bot
    def initialize(id)
        @id = id
        @low = nil
        @high = nil
        @values = []
    end

    def low=(target)
        @low = target
    end

    def high=(target)
        @high = target
    end

    def value=(value)
        @values << value
        _passValues
    end

    def to_s
        @id
    end

    def _passValues
        if @values.length == 2
            @values.sort!

            # Debug output
            # puts "#{@id} passes #{@values[0]} to #{@low} and #{@values[1]} to #{@high}"

            # Stop condition
            puts "Part 1: #{@id} compares 17 and 61" if @values[0] == 17 && @values[1] == 61

            @low.value= @values[0]
            @high.value= @values[1]
            @values = []
        end
    end
end

$objs = {}

def connect(bot:, to_low:, to_high:)
    $objs[bot] = Bot.new(bot) unless $objs.key? bot

    [to_low, to_high].each do |to|
        if to.index('bot') == 0
            $objs[to] = Bot.new(to) unless $objs.key? to 
        else
            $objs[to] = Output.new(to) unless $objs.key? to 
        end
    end

    $objs[bot].low = $objs[to_low]
    $objs[bot].high = $objs[to_high]
end

lines = []
STDIN.readlines.each do |line|
    lines << line
end

lines.each do |line|
    words = line.split(' ')
    if words[0] == 'bot'
        bot = words[0] + '-' + words[1]
        to_low = words[5] + '-' + words[6]
        to_high = words[10] + '-' + words[11]
        connect(bot:bot, to_low: to_low, to_high: to_high)
    end
end

lines.each do |line|
    words = line.split(' ')
    if words[0] == 'value'
        val = words[1]
        bot = words[4] + '-' + words[5]
        $objs[bot] = Bot.new(bot) unless $objs.key? bot
        $objs[bot].value=val.to_i
    end
end

puts "Part 2: (do some manual multiplication of the values below):"
puts $objs['output-0'], $objs['output-1'], $objs['output-2']