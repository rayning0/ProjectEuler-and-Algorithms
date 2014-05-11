# http://projecteuler.net/problem=35
# The number, 197, is called a circular prime because all rotations of the digits: 
# 197, 971, and 719, are themselves prime. How many circular primes are there < 1 million?

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
  s.unshift(2).sort  # adds 2 as 1st element
end

def is_prime_sieve?(s, n)   # trial division, only dividing by primes from sieve array
  return true if n.between?(2, 3)
  return false if (n.even? || n % 3 == 0 || n <= 1)   # no evens, multiples of 3, or nums <= 1
  
  s.each do |d|
    return true if d * d > n    # only must check up till sqrt(n)!
    return false if n % d == 0  # if n is divisible by a number in prime file
  end

  true
end

#------------------------------------------
start = Time.now

s = sieve(1_000_000)  # makes array of all primes < 1 million
circular = 0          # number of circular primes


s.each do |p|
  num = p.to_s.split('')    # splits p into array of single digits
  primecheck = 0

  (num.size - 1).times do
    n = num.rotate!.join.to_i
    primecheck += 1 if is_prime_sieve?(s, n)
  end

  circular += 1 if primecheck == num.size - 1
end

puts "Below 1 million, we have #{circular} circular primes. Took #{Time.now - start} secs."