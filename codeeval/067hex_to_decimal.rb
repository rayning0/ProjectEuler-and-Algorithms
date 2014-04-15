File.open(ARGV[0]).each_line do |n|
  puts n.strip.to_i(16)
end