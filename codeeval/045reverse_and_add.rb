# https://www.codeeval.com/open_challenges/45/

num = IO.readlines(ARGV[0]).map(&:strip)

num.each do |n|
  c = 1
  while true
    sum = n.to_i + n.reverse.to_i
    break if sum.to_s == sum.to_s.reverse 
    c += 1
    n = sum.to_s
  end
  puts "#{c} #{sum}"
end
