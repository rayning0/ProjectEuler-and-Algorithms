# http://projecteuler.net/problem=3

def largest_prime_factor(n)
  #factors = []
  f = 2
  while f * f <= n
    if n % f == 0
      #factors << f
      n /= f
    else
      f += 1
    end
  end
  # factors << n
  # factors
  n
end

=begin
# This method takes < 1 second!
#  ------Fast way to check if number is prime------------

def is_prime?(num)
  return false if num <= 1
  return true if num.between?(2, 3) # true if 2 <= num <= 3

  return false if num.even? # goodbye even numbers
  return false if num % 3 == 0  # goodbye multiples of 3

  j = 5
  w = 2

  while j * j <= num    # only check j up to sqrt(num), since factors invert order afterwards
    return false if num % j == 0
    j += w              # Only checks odd numbers. First checks j + 2
    w = 6 - w           # Don't check multiples of 3. So then checks j + 4.
                        # Alternates + 2, + 4, + 2, etc.
  end

  true
end

=end
