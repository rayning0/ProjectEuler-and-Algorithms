# http://projecteuler.net/problem=50
# Which prime, below one-million, can be written as the sum of the most consecutive 
# primes? The longest sum of consecutive primes < 1000 that adds to a prime, 
# contains 21 terms, and is equal to 953.
require 'pry'
require 'pry-debugger'

# Sieve of Eratosthenes
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
    return false if n % d == 0  # if n is divisible by a number in prime array
  end

  true
end
#-------------------------------------------------------
start = Time.now
primes = sieve(1_000_000)   # quickly makes array of all primes < 1 million 
sums = {}

# Copying trick we did in Problem 23, instead of subtracting each prime from test prime,
# we create all possible sums from consecutive primes, then check if sums are prime.
primes.each_with_index do |p, i|
  break if i > primes.size / 21 - 1
  c = 1       # number of consecutive primes added to get sum
  sum = p
  j = i + 1

# I doubt we'll have answers > 48,000 (1 million/21) that could top 21 consecutive primes
  while j < primes.size / 21
    p2 = primes[j]
    c += 1
    sum += p2
    break if sum >= 1_000_000
    if is_prime_sieve?(primes, sum)   # if sum = prime

      # Put sum in hash, with count. But DON'T OVERWRITE KEY 
      # WITH NEW VALUE IF IT ALREADY HAS ONE! Original count is the biggest for the key.

      sums[sum] = c if !sums.has_key?(sum)   
    end
    j += 1
  end
end

max = sums.values.max 
puts "Longest sum of consecutive primes is for #{sums.key(max)}, with #{max} terms. It took #{Time.now - start} secs."

# "Longest sum of consecutive primes is for 997651, with 543 terms. It took 1.856201 secs."

=begin 
- Different strategy: create array of all consecutive sums, sumarray.
- With nested loop, take later sum - earlier sum. If that's a prime, call that maxprime. With next loop, look ahead in primes only the same as max consecutive terms now. 

sumarray = []

sum = 0
maxprime = 0
sumprimes = 0
count = 0

while sum < 1_000_000
  sum += primes[count]
  sumarray << sum
  count += 1
end

terms = 1
(0..count - 2).each do |i|
  (i + terms..count - 1).each do |j|
    sumprimes = sumarray[j] - sumarray[i]
    break if sumprimes > 1_000_000
    #puts "i = #{i}, j = #{j}"
    if j > i && is_prime_sieve?(primes, sumprimes)
      terms, maxprime = j - i, sumprimes
    end
  end
end

puts "Longest sum of consecutive primes is for #{maxprime}, with #{terms} terms. It took #{Time.now - start} secs."

=end
