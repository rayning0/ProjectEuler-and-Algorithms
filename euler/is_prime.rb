# Fast way to check if number is prime

def is_prime?(n)
  return true if n.between?(2, 3)
  return false if (n.even? || n % 3 == 0 || n <= 1)   # no evens, multiples of 3, or nums <= 1

  j, w = 5, 2

  while j * j <= n                # Only must check j up to sqrt(n)
    return false if n % j == 0
    j += w                        # Only check odd #'s. j + 2
    w = 6 - w                     # Don't check multiples of 3. j + 4.
  end           # Alternate +2, +4, +2, +4. Ex: 5+2 = 7+4 = 11+2 = 13+4 = 17 ...

  true
end
