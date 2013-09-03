# http://projecteuler.net/problem=34
# Find sum of all numbers which equal the sum of the factorial of their digits.

fact = [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880] # factorials from 0-9
total = 0 

start = Time.now

(3..50000).each do |i|
  sum = 0                   # sum of digit factorials for each number
  num = i.to_s.split('')
  num.map! {|x| x.to_i}     # split i into array of single digit integers

  num.each do |n|
    sum += fact[n]
  end
  if i == sum
    total += sum
    print i
    print ' '
  end
end

puts "Total = #{total}. Took #{Time.now - start} secs."

# "Output: 145 40585 Total = 40730. Took 0.575524 secs. "