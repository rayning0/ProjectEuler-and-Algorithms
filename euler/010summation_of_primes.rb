# http://projecteuler.net/problem=10
# Find the sum of all the primes below 2 million.
# Use Sieve of Eratosthenes to generate array of primes: 
# http://www.mathblog.dk/sum-of-all-primes-below-2000000-problem-10/

def sieve(n)    # makes array of all primes from 2 to n
  s = 3.step(n, 2).to_a # make array of odd integers from 3 to n. Skip evens. 
  s.each do |p|
    next if p.nil?       # go to next element if p has been marked empty
    break if p * p > n   # p only needs to go up to sqrt(n)

    k, pval = 0, 0

    while pval < n
      pval = p * (p + k)  # jump forward 2p at a time: p*p, p*p + 2p, p*p + 4p, etc.

      # Set all those multiples to nil. i = (pval - 3)/2 translates pvals to index i

      s[(pval - 3) / 2] = nil 
      k += 2  
    end

  end
  s.compact!    # removes all nil elements from array
  s.unshift(2)  # adds 2 as 1st element
end

def is_prime?(n)
  return true if n.between?(2, 3)
  return false if (n.even? || n % 3 == 0 || n <= 1)

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
puts "is_prime method, by trial division, takes several seconds. Slow."

sum = sieve(2_000_000).inject(:+)
puts "Sum of all primes < 2 million = #{sum}"
puts "With Sieve of Eratosthenes, that was freakin' fast!"