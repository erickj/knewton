##
# Worst case: O(n^2)
# Average case: O(n log n)
require 'digest'
require 'yaml'

#file='list.txt'
#file="/Users/erick/Desktop/Artist_lists_small.txt"
#str = File.read(file);

str = STDIN.read

lines = str.split("\n");

t_start=Time.now
STDERR.puts "File lines: %d"%lines.length

char_lines = {}
lines.each_index do |i|
  l = lines[i]
  artists = l.split(",")
  artists.each do |artist|
    char_lines[artist.intern] ||= {:i => 0}
    char_lines[artist.intern][:i] |= 1 << i
  end
end
#puts(char_lines.to_yaml)

STDERR.puts "Num artists before prune: %d"%char_lines.length
char_lines.reject! do |sym,stats|
  tmp = Math.log2(stats[:i])
  tmp == tmp.to_i
end
STDERR.puts "Num artists after prune: %d"%char_lines.length

cpy = char_lines.clone
out = []
i = 0
char_lines.each_pair do |c_sym,struct|
  cpy.delete(c_sym)
  cpy.each_pair do |cpy_sym,cpy_struct|
    mask = struct[:i] & cpy_struct[:i]
    log2 = Math.log2(mask)
    next if (mask == 0 || log2 == log2.to_i)
    out << ("%s, %s"%[c_sym,cpy_sym])
    i += 1
  end
end
t_end=Time.now

out = out.sort.join("\n")
puts out

STDERR.puts("actual iterations: %d"%i)
STDERR.puts("-- n^2: %d"%(i ** 2))
STDERR.puts("-- n log n: %f"%(i * Math.log2(i)))
STDERR.puts("done in %fs--"%(t_end - t_start))
STDERR.puts("md5 digest: %s"%Digest::MD5.hexdigest(out))
