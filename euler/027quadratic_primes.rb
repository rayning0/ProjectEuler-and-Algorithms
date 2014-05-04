# https://projecteuler.net/problem=27
# Considering quadratics of the form:
# n² + an + b, where |a| < 1000 and |b| < 1000
# Find the product of the coefficients, a and b, for the quadratic expression that produces the maximum number of primes for consecutive values of n, starting with n = 0.
require 'pry'
require './sieve_of_eratosthenes'

# if n = 0, and f = 0*0 + a*0 + b = b must be prime, then b must be prime!
b_primes = sieve(999) # b = all primes from 2-999

old_max_n = 0
max_n = {}
[*-999..999].each do |a|
  b_primes.each do |b|
    n = 0
    loop do
      f = n * (n + a) + b
      if is_prime?(f)
        n += 1
      else
        mn = [n - 1, old_max_n].max
        if mn != old_max_n
          # puts "new max_n: #{mn}, a: #{a}, b: #{b}"
          max_n[:max] = mn
          max_n[:a] = a
          max_n[:b] = b
        end
        old_max_n = mn
        break
      end
    end
  end
end

puts "max n: #{max_n[:max]}, a: #{max_n[:a]}, b: #{max_n[:b]}, ab: #{max_n[:a] * max_n[:b]}"
puts "Saved lots of time! If b = -999 to 999, problem took 12 secs. Now it takes 2.9 secs."