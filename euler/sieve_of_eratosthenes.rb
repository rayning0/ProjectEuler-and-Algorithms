# Sieve of Eratosthenes: quickly makes big array of primes. May hog all your memory.
# http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# http://www.mathblog.dk/sum-of-all-primes-below-2000000-problem-10/

# Raymond Gan: Coded my own version, from scratch!
require 'benchmark'
require 'json'

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
  return false if (n.even? || n % 3 == 0 || n <= 1)   # no evens, multiples of 3, or nums <= 1

  j, w = 5, 2

  while j * j <= n                # Only must check j up to sqrt(n)
    return false if n % j == 0
    j += w                        # Only check odd #'s. j + 2
    w = 6 - w                     # Don't check multiples of 3. j + 4.
  end           # Alternate +2, +4, +2, +4. Ex: 5+2 = 7+4 = 11+2 = 13+4 = 17 ...

  true
end

def benchmark_primes
  puts "Enter n. I'll make an array of primes up till n:"
  n = gets.chomp.to_i
  puts
  s = sieve(n)
  puts "Array size = #{s.size}"
  puts "Putting it in text file...(WARNING: this may create a HUGE file that uses up all your memory! May need to reboot.)"
  File.open('sieveprimes-serialized.txt', 'w') {|f| f.write(Marshal.dump(s))}
  File.open('jsonprimes.txt', 'w') {|f| f.write(s.to_json)}

  puts "Enter n. I'll tell you if it's prime"
  n = gets.chomp.to_i

  Benchmark.bm(27) do |bm|
    bm.report("Using is_prime method. ") do     # Fastest!
      puts "Prime? #{is_prime?(n)}"
    end

    bm.report("Read in primes from serialized file. ") do
      t = Marshal.load File.read('sieveprimes-serialized.txt')

      # uses Sieve of Eratosthenes file to check if prime. Slower.
      prime = t.any? {|i| i == n}
      puts "Prime? #{prime}"
    end

    bm.report("Read in primes from JSON file. ") do   # Slowest!
      j = JSON.parse(File.read('jsonprimes.txt'))
      prime = j.any? {|i| i == n}
      puts "Prime? #{prime}"
    end
  end
end


=begin
# sum all primes
# puts "Sum of all primes: #{s.inject(:+)}"





=begin

0, 1, 2, 3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20  = i
3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43  = 2i + 3

p*p, p*p + 2p, p*p + 4p, p*p + 6p, etc... = p(p + k), k = even numbers

i=p, 2p,      , 3p     , 4p

(25-3)/2, (35-3)/2
=end