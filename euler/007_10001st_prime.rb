# http://projecteuler.net/problem=7
# What is the 10001st prime number?

# This method takes < 1 second!
#  ------Fast way to check if number is prime------------
def is_prime?(num)
  return false if num <= 1
  return true if num.between?(2, 3) # true if 2 <= num <= 3

  return false if num.even? # goodbye even numbers
  return false if num % 3 == 0  # goodbye multiples of 3

  j = 5
  w = 2
  
  while j * j <= num # only check j up to sqrt(num), since factors invert order afterwards
    return false if num % j == 0  
    j += w      # Only checks odd numbers. First checks j + 2
    w = 6 - w   # Don't check multiples of 3. So then checks j + 4. 

    # Alternates + 2, + 4, + 2, etc.
  end

  true
end

i = 2
primecount = 0

while true
  primecount += 1 if is_prime?(i)
  if primecount == 10001
    puts "10,001th prime = #{i}"
    exit
  end
  i += 1
end

# Useful link: 
# http://stackoverflow.com/questions/1801391/what-is-the-best-algorithm-for-checking-if-a-number-is-prime

=begin

# Alternate slower way: Takes 12 seconds.
# Build array of primes.
# All primes, besides 2 or 3, are of form 6k + 1 or 6k - 1. This excludes all multiples of 2 or 3.

primes = [2, 3] # start with 1st 2 primes
k = 1

while true
  prime = true

  primes.each do |p|  # is 6k - 1 divisible by each prime found so far?
    if (6 * k - 1) % p == 0
      prime = false 
      break
    end
  end

  primes << 6 * k - 1 if prime  # we found a new prime

  break if primes.count == 10001

  prime = true

  primes.each do |p|
    if (6 * k + 1) % p == 0 # is 6k + 1 divisible by each prime found so far?
      prime = false
      break
    end
  end

  primes << 6 * k + 1 if prime    # we found a new prime

  break if primes.count == 10001
  k += 1
end

puts "10,001st prime = #{primes[-1]}"

=end
