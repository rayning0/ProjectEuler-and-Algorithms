# http://projecteuler.net/problem=30
# Find the sum of all the numbers that can be written as the sum of 5th powers of their digits.

start = Time.now
answer = []
(11..200_000).each do |i|
  istring = i.to_s
  sum = 0

  (0..istring.size - 1).each do |j|
    sum += istring[j].to_i ** 5
  end

  answer << i if i == sum 
end

puts "Sum of all #'s that can be written as sum of 5th powers of their digits = #{answer.inject(:+)}"
p answer
puts "Took #{Time.now - start} secs."

=begin
  
Sum of all #'s that can be written as sum of 5th powers of their digits = 443839
[4150, 4151, 54748, 92727, 93084, 194979]
Took 0.910941 secs.
  
=end