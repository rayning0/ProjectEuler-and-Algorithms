# http://projecteuler.net/problem=12
# What is the first triangle number to have > 500 factors?

# Fastest method, thanks to this blog:
# http://www.mathblog.dk/triangle-number-with-more-than-500-divisors/
# http://www.mathblog.dk/files/euler/Problem12.cs
# Use Sieve of Eratosthenes to build prime # list:
# http://www.mathblog.dk/sum-of-all-primes-below-2000000-problem-10/
=begin

Any num is uniquely described by its prime factorization:

N = p1^a1 * p2^a2 * p3^a3 ..., where pn = distinct prime.
Each prime may be chosen 0,1,2,...an ("a sub n") times.
So we may choose pn in (an + 1) different ways.

Total divisors of N =
D(N) = (a1 + 1)(a2 + 1)(a3 + 1)* * *

=end

def div(noriginal, primelist)
  divisors = 1
  exponent = 0
  n = noriginal
  
  (0..primelist.length - 1).each do |i|

  # In case there's a remainder, this is a prime factor as well.
  # That factor's exponent is 1. (Ex: a1 = 1) We have 2 possibilities
  # fot that prime factor---we use it or we dont. That's why we multiply by 2.

    return 2 * divisors if primelist[i] * primelist[i] > noriginal

    exponent = 1
    while n % primelist[i] == 0
      exponent += 1   # each time we can divide noriginal by the same prime, 
                      # we raise exponent, keeping track of its multiplicity (a1, a2, a3, etc)
      n /= primelist[i]   # keep dividing n by prime, until we can't
    end

    divisors *= exponent  # include new multiplicity of that prime in divisors
    return divisors if n == 1   # if no remainder, return the count
  end

  divisors
end