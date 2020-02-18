#!/usr/bin/ruby -w

class Comp

  def initialize(program)
    @instructions = program
    @pos = 0
    @regs = { 
      'a' => 0, 
      'b' => 0, 
      'c' => 1, 
      'd' => 0 
    }
  end

  def cpy(x, y)
    if ['a', 'b', 'c', 'd'].include? x
      @regs[y] = @regs[x].to_i
    else
      @regs[y] = x.to_i
    end
  end

  def inc(x)
    @regs[x] = @regs[x] + 1
  end

  def dec(x)
    @regs[x] = @regs[x] - 1
  end

  def jnz(x, y)
    @pos += (y.to_i - 1) if @regs[x] != 0
  end 

  def execute
    instr = @instructions[@pos]
    op = instr.split(' ')[0]
    x = instr.split(' ')[1]
    y = instr.split(' ')[2] if instr.length > 2
    if op == 'jnz'
      self.jnz(x, y)
    elsif op == 'cpy'
      self.cpy(x, y)
    elsif op == 'inc'
      self.inc(x)
    elsif op == 'dec'
      self.dec(x)
    end

    @pos += 1
  end

  def run
    while @pos < @instructions.length && @pos >= 0 do
      self.execute
    end

    puts "Part 1: #{@regs['a']}"
  end
end

# Read and parse input
instructions = []
STDIN.readlines.each do |line|
  instructions << line.strip()
end

comp = Comp.new(instructions)
comp.run
