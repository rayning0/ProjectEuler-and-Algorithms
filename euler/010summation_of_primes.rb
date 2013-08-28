# http://projecteuler.net/problem=10
# Find the sum of all the primes below 2 million.

def is_prime?(n)
  return false if (n.even? || n % 3 == 0 || n <= 1)
  return true if n.between?(2, 3)

  j, w = 5, 2

  while j * j <= n
    return false if n % j == 0
    j += w
    w = 6 - w
  end

  true
end

sum = 5   # includes 2 + 3

5.step(2e6.to_i, 2) do |i|       # step method increments from 5 to 2 million by 2's
  sum += i if is_prime?(i)
end

puts "Sum of all primes < 2 million = #{sum}"