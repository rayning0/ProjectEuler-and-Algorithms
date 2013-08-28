# http://projecteuler.net/problem=16
# What is the sum of the digits of the number 2**1000?

# 1. Convert 2^1000 to string. 
# 2. Split it into array of single digit strings.
# 3. Map each element of array to integer form.
# 4. Add all elements together with "inject"

sum = (2**1000).to_s.split('').map {|x| x.to_i}.inject(:+)
puts "Sum of digits of 2^1000 = #{sum}"