# http://projecteuler.net/problem=6
# Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.

def sum_1_to_n(n)   # sum of numbers from 1 to n
  n * (n + 1) / 2   # from high school algebra
end

n = 100
sqsum = 0

(1..n).each { |i| sqsum += i * i }

diff = sum_1_to_n(n)**2 - sqsum

puts "Diff = #{diff}"

