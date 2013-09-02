=begin
http://projecteuler.net/problem=49

The arithmetic sequence, 1487, 4817, 8147, in which each of the terms increases by 3330, is unusual in two ways: (i) each of the three terms are prime, and, (ii) each of the 4-digit numbers are permutations of one another.

There is one other 4-digit increasing sequence. What 12-digit number do you form by concatenating the three terms in this sequence?
=end

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

#-------------------------------------------------------
start = Time.now
primes = sieve(9973)  # make array of primes < 10,000

primes.each do |p|
  next if p < 1009    # we only want 4-digit numbers
  break if p > 3313   # biggest prime < 10,000 is 9973. Minus 6660 = 3313.
  p2 = p + 3330
  p3 = p + 6660
  next if !is_prime_sieve?(primes, p2) || !is_prime_sieve?(primes, p3)  # only want other primes

# makes sorted permutations array like this: ["1234", "1243", "1324", "1342", "1423",...]
  pperm = p.to_s.split('').permutation.map(&:join).sort   
  p2perm = p2.to_s.split('').permutation.map(&:join).sort 
  p3perm = p3.to_s.split('').permutation.map(&:join).sort 

  if pperm == p2perm && pperm == p3perm   # if all 3 are permutations of each other
    puts "12 digit answer: #{p.to_s + p2.to_s + p3.to_s}"
    puts "It took #{Time.now - start} secs."
  end
end