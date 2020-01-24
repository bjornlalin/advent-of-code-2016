#!/usr/bin/ruby -w

def seq_inside(address, min_len)
    return address.scan(/\[(\w{#{min_len},})\]/)
end

def seq_outside(address, min_len)
    return address.scan(/(?:^|\])(\w{#{min_len},})(?:\[|$)/)
end

def seq_abba(seq)
    seqs = []
    for i in 0...(seq.length-3)
        if seq[i] == seq[i+3] && seq[i+1] == seq[i+2] && seq[i] != seq[i+1]
            seqs << seq[i..(i+3)]
        end
    end
    return seqs
end

def seq_aba(seq)
    seqs = []
    for i in 0...(seq.length-2)
        if seq[i] == seq[i+2] && seq[i] != seq[i+1]
            seqs << seq[i..(i+2)]
        end
    end
    return seqs
end

def inverse(word)
    return [word[1], word[0], word[1]].join('')
end

def is_tls(address)
    found_inside = found_outside = false
    seq_outside(address, 4).each { |match| found_outside = true if seq_abba(match[0]).any? }
    seq_inside(address, 4).each { |match| found_inside = true if seq_abba(match[0]).any? }
    return found_outside && !found_inside
end

def is_ssl(address)
    found_inside = []
    found_outside = []
    seq_outside(address, 3).each { |match| seq_aba(match[0]).each { |aba| found_outside << aba } }
    seq_inside(address, 3).each { |match| seq_aba(match[0]).each { |aba| found_inside << aba } }

    # Found inverses inside brackets of similar 3-letter-words 'aba' outside brackets
    found_outside.each { |word| return true if found_inside.include? inverse(word) }
    return false
end

puts "Unit testing is_tls ..."
puts "abba[mnop]qrst ==> #{is_tls('abba[mnop]qrst')} (expect true)"
puts "abcd[bddb]xyyx ==> #{is_tls('abcd[bddb]xyyx')} (expect false)"
puts "aaaa[qwer]tyui ==> #{is_tls('aaaa[qwer]tyui')} (expect false)"
puts "ioxxoj[asdfgh]zxcvbn ==> #{is_tls('ioxxoj[asdfgh]zxcvbn')} (expect true)"
puts

puts "Unit testing is_ssl ..."
puts "aba[bab]xyz ==> #{is_ssl('aba[bab]xyz')} (expect true)"
puts "xyx[xyx]xyx ==> #{is_ssl('xyx[xyx]xyx')} (expect false)"
puts "aaa[kek]eke ==> #{is_ssl('aaa[kek]eke')} (expect true)"
puts "zazbz[bzb]cdb ==> #{is_ssl('zazbz[bzb]cdb')} (expect true)"
puts

count_1 = 0
count_2 = 0
STDIN.readlines.each do |line|
    count_1 += 1 if is_tls(line)
    count_2 += 1 if is_ssl(line)
end

puts "Part 1: #{count_1}"
puts "Part 2: #{count_2}"