# https://www.codeeval.com/open_challenges/91/

File.open(ARGV[0]).each_line do |n|
  n = n.strip.split.map(&:to_f).sort
  puts n.map{|x| sprintf "%.3f" % x}.join(' ')
end

=begin
  
-38.797 7.581 14.354 70.920 90.374 99.323
-55.552 -37.507 -3.263 27.999 40.079 65.213
  
=end