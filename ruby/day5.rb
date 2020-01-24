#!/usr/bin/ruby -w

require 'digest/md5'

def solve1(input)
    hash, counter = '', 0
    while hash.length < 8
        md5_input = input + counter.to_s
        md5 = Digest::MD5.hexdigest(md5_input)
        if md5[0..4] == '00000'
            hash += md5[5]
            puts "#{md5_input} => #{md5} (hash: #{hash})"
        end
        counter += 1
    end
    hash
end

def solve2(input)
    hash, counter = "********", 0
    while hash.include? "*"
        md5_input = input + counter.to_s
        md5 = Digest::MD5.hexdigest(md5_input)
        if md5[0..4] == "00000"
            pos = md5[5]
            if "01234567".include?(pos) && hash[pos.to_i] == '*'
                hash = (hash[0...pos.to_i] + md5[6] + hash[pos.to_i+1..])
                puts "#{md5_input}".ljust(20) + " => #{md5} (hash: #{hash})"
            end
        end
        counter += 1
    end
    hash
end

puts "Part 1: #{solve1('uqwqemis')}"
puts "Part 2: #{solve2('uqwqemis')}"