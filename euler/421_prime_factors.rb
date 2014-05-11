# http://projecteuler.net/problem=421
# Find sum of the distinct prime factors of n^15+1 not exceeding 10^8
# 1 <= n <= 10^11
require 'pry'
def primef(n)
  f = 2
  factors = []
  while f * f <= n    # only need to check up to sqrt(n)
    if n % f == 0
      factors << f
      n = n / f       # key line! After you find a factor, only check quotient after that!
    else
      f += 1
    end
  end
  factors << n
  factors
end

start = Time.now
sum = 0
(2..10**11).each do |n|
  factors = primef(n**15 + 1).select{|i| i < 1e8.to_i}
  sum += factors.uniq.inject(:+)
  print "Sum = #{sum}. Factors = #{factors.uniq}"
  puts
  #binding.pry
end

puts "Sum of distinct prime factors of n^15+1 that are < 10^8 = #{sum}. \
Took #{Time.now - start} secs."