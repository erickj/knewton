##
# where n is number of unique artists in all lists
#
# Time complexity:
# Worst case = O(n^2)
#
# Worst case time complexity would be where all artists are in greater
# than N_LISTS lists
#
# Space Complexity
# O(n)
#
$:.unshift(".")
require 'artist'
require 'compat'

require 'digest'
require 'yaml'

N_LISTS=50
t_start=Time.now

#file='list.txt'
#file="/Users/erick/Desktop/Artist_lists_small.txt"
#str = File.read(file);
str = STDIN.read

#
# split input and build artist objects
#
lines = str.split("\n");
lines.each_index do |i|
  l = lines[i]
  artist_names_in_line = l.split(",")
  artist_names_in_line.each do |name|
    a = Artist.build(name)
    a.append_list(i)
  end
end
#STDERR.puts(Artist.instances.to_yaml)

#
# optimization to remove any artists not in N_LISTS
#
n = Artist.instances.length
STDERR.puts "Num artists before prune: %d"%Artist.instances.length
Artist.instances.reject! do |sym,obj|
  !obj.in_n_lists?(N_LISTS)
end
STDERR.puts "Num artists after prune: %d"%Artist.instances.length

#STDERR.puts(Artist.instances.to_yaml)

#
# collect pairs of artists that share N_LISTS lists
#
cpy = Artist.instances.clone
out = []
i = 0
Artist.instances.each_pair do |artist_name,artist_obj|
  cpy.delete(artist_name)
  cpy.each_pair do |artist_i_name,artist_i|
    i += 1
    next unless artist_obj.shares_n_lists(artist_i,N_LISTS)
    out << ("%s, %s"%[artist_obj.name,artist_i.name])
  end
end
t_end=Time.now

out = out.sort.join("\n")
puts out

STDERR.puts "Total Lines: %d"%lines.length
STDERR.puts("Actual Iterations: %d"%i)
STDERR.puts("-- n^2: %d"%(n ** 2))
STDERR.puts("-- n log n: %d"%(n * Math.log2(n))) rescue nil
STDERR.puts("-- log n: %d"%(Math.log2(n))) rescue nil
STDERR.puts("Done in %fs--"%(t_end - t_start))
STDERR.puts("md5 checksum: %s"%Digest::MD5.hexdigest(out))
