#!/usr/bin/ruby -w

class Disc
  def initialize(id, n_pos, pos_0)
    @id = id
    @n_pos = n_pos
    @pos_0 = pos_0
  end

  def open_for_capsule_dropped_at_time_t?(t)
    return (t + @pos_0 + @id) % @n_pos == 0
  end

end

def solve(discs)
  t = 0
  while true do
    break if discs.map { |disc| disc.open_for_capsule_dropped_at_time_t? t }.all?
    t += 1
  end
  t
end

discs = []
STDIN.readlines.each do |line|
  discs << Disc.new(
    line.split(' ')[1].gsub('#', '').to_i,
    line.split(' ')[3].to_i,
    line.split(' ')[11].gsub('.', '').to_i)
end

puts "Part 1: The first time we can drop a capsule that passes is at time #{solve(discs)}"
puts "Part 2: The first time we can drop a capsule that passes is at time #{solve(discs << Disc.new(discs.length + 1, 11, 0))}"
