# Fast way to check if number is prime
# Compared several methods and timed with Benchmark class

require 'benchmark'
require 'json'

def is_prime?(n)        # optimized trial division
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


def is_prime_sieve?(s, n)   # trial division, only dividing by primes from sieve file
  return true if n.between?(2, 3)
  return false if (n.even? || n % 3 == 0 || n <= 1)   # no evens, multiples of 3, or nums <= 1
  
  s.each do |d|
    return true if d == n       # if n = number in prime file
    return false if n % d == 0  # if n is divisible by a number in prime file
  end

  true
end

puts "Enter number (< 2 million). I'll tell you if it's prime."
n = gets.chomp.to_i


Benchmark.bm do |bm|
  bm.report("With is_prime method. Prime? ") do
    puts "#{is_prime?(n)}."
  end

  # load in previously created arrays of primes < 2 million
  bm.report("Time to load serialized sieve file of primes") do
    puts
    s = Marshal.load(File.read('sieveprimes-serialized.txt'))
  end

  bm.report("Time to load JSON sieve file of primes") do
    puts
    j = JSON.parse(File.read('jsonprimes.txt'))
  end
end

# Program does not remember s, j from the Benchmark block. Must load again.
s = Marshal.load(File.read('sieveprimes-serialized.txt'))
j = JSON.parse(File.read('jsonprimes.txt'))

Benchmark.bm do |bm|
  bm.report("Only dividing by primes from sieveprimes-serialized.txt. Prime? ") do
    puts "#{is_prime_sieve?(s, n)}"
  end

  bm.report("Only dividing by primes from jsonprimes.txt. Prime? ") do
    puts "#{is_prime_sieve?(j, n)}"
  end

  bm.report("Search for prime in serialized file, with any? method. ") do
    #t = Marshal.load File.read('sieveprimes-serialized.txt')

    # uses Sieve of Eratosthenes file to check if prime. Slower.
    prime = s.any? {|i| i == n}
    puts "Prime? #{prime}"
  end

  bm.report("Search for prime in JSON file, with any? method. ") do   # Slowest!
    #j = JSON.parse(File.read('jsonprimes.txt'))
    prime = j.any? {|i| i == n}
    puts "Prime? #{prime}"
  end
end

=begin. Output of benchmarks:

Clearly in_prime? method is still the fastest. Serialized file both loads 
and processes faster than JSON.


Enter number (< 2 million). I'll tell you if it's prime.
1999993 (This is biggest prime < 2 million)

       user     system      total        real
With is_prime method. Prime? true.
  0.000000   0.000000   0.000000 (  0.008447)
Time to load serialized sieve file of primes
  0.020000   0.000000   0.020000 (  0.026041)
Time to load JSON sieve file of primes
  0.050000   0.000000   0.050000 (  0.053372)
       user     system      total        real
Only dividing by primes from sieveprimes-serialized.txt. Prime? true
  0.030000   0.000000   0.030000 (  0.029442)
Only dividing by primes from jsonprimes.txt. Prime? true
  0.030000   0.000000   0.030000 (  0.032958)
Search for prime in serialized file, with any? method. Prime? true
  0.020000   0.000000   0.020000 (  0.023802)
Search for prime in JSON file, with any? method. Prime? true
  0.030000   0.000000   0.030000 (  0.026329)

=end