# http://projecteuler.net/problem=7
# What is the 10001st prime number?

#  ------Fast way to check if number is prime------------
def is_prime?(num)
  return false if num <= 1
  return true if num.between?(2, 3) # true if 2 <= num <= 3

  return false if num.even? # goodbye even numbers
  return false if num % 3 == 0  # goodbye multiples of 3

  j = 5
  
  while j <= Math.sqrt(num) # only must check up to sqrt(num), since factors invert order afterwards
    return false if num % j == 0  
    j += 2                        # only check odd numbers
    return false if num % j == 0  # divide by next odd number
    j += 4                        # don't check multiples of 3. Faster.
  end

  true
end

primecount = 0
i = 2

while true
  primecount += 1 if is_prime?(i)
  if primecount == 10001
    puts "10,001th prime = #{i}"
    exit
  end
  i += 1
end