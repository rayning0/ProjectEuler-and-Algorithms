# http://projecteuler.net/problem=20
# Find the sum of the digits in the number 100!

factorial = (1..100).inject(:*)   # 100!
sum = factorial.to_s.split('').map {|x| x.to_i}.inject(:+)
puts "Sum of digits in 100! = #{sum}"