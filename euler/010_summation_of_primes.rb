# http://projecteuler.net/problem=10
# Find the sum of all the primes below 2 million.
# Use Sieve of Eratosthenes to generate array of primes: 
# http://www.mathblog.dk/sum-of-all-primes-below-2000000-problem-10/

# Also, see my times for checking if number is prime, in is_prime.rb

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

def is_prime_sieve?(s, n)   # trial division, only dividing by primes from sieve file
  return true if n.between?(2, 3)
  return false if (n.even? || n % 3 == 0 || n <= 1)   # no evens, multiples of 3, or nums <= 1
  
  s.each do |d|
    return true if d * d > n    # only must check up till sqrt(n)!
    return false if n % d == 0  # if n is divisible by a number in prime file
  end

  true
end

start = Time.now
s = Marshal.load(File.read('sieveprimes-serialized.txt')) # loads previously calculated primes < 2 million
puts "Took #{Time.now - start} seconds to load in previously calculated primes < 2 million."

sum = 5   # includes 2 + 3

start = Time.now
5.step(2e6.to_i, 2) do |i|       # step method increments from 5 to 2 million by 2's
  sum += i if is_prime?(i)
end

puts "Sum of all primes < 2 million = #{sum}"
puts "is_prime method, by trial division, takes #{Time.now - start} seconds. Slow."

sum = 5

start = Time.now
5.step(2e6.to_i, 2) do |i|       # step method increments from 5 to 2 million by 2's
  sum += i if is_prime_sieve?(s, i)   # checks if prime by trial division, only using prime divisors
end

puts "Sum of all primes < 2 million = #{sum}"
puts "is_prime_sieve method, by trial division (only by primes), takes #{Time.now - start} seconds."

start = Time.now
sum = sieve(2_000_000).inject(:+)
puts "Sum of all primes < 2 million = #{sum}"
puts "by newly generating Sieve of Eratosthenes. Freakin' fast! Took #{Time.now - start} seconds."

start = Time.now
sum = s.inject(:+)
puts "Sum of all primes < 2 million = #{sum}"
puts "Summed all primes in preloaded sieve prime file. Fastest of all! Took #{Time.now - start} seconds."

=begin
  
Took 0.019628 seconds to load in previously calculated primes < 2 million.

Sum of all primes < 2 million = 142913828922
is_prime method, by trial division, takes 9.323758 seconds. Slow.

Sum of all primes < 2 million = 142913828922
is_prime_sieve method, by trial division (only by primes), takes 8.739961 seconds.

Sum of all primes < 2 million = 142913828922
by newly generating Sieve of Eratosthenes. Freakin' fast! Took 0.582711 seconds.

Sum of all primes < 2 million = 142913828922
Summed all primes in preloaded sieve prime file. Fastest of all! Took 0.017074 seconds.

=end