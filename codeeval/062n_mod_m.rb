File.open(ARGV[0]).each_line do |line|
  spl = line.split(',')
  n = spl[0].to_i
  m = spl[1].to_i
  puts n - (n / m) * m
end