# http://projecteuler.net/problem=26
# 1/7 has a 6-digit recurring cycle. Find the value of d < 1000 for which 1/d 
# contains the longest recurring cycle in its decimal fraction part.
# http://en.wikipedia.org/wiki/Repeating_decimal

require 'pry'
require 'pry-debugger'
require 'bigdecimal'

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

#------------------------------------
start = Time.now

cycle = {}  # hash table of lengths of different repeating digits 

3.step(997, 2).each do |d|
  next if !is_prime?(d)      # only need to check prime #'s. See bottom of page for why.

# extracts only decimal part of 1/d and converts to array of single string characters
# BigDecimal class lets you specify arbitrary precision. Here we go to 2000 digits.

  num = (BigDecimal.new(1).div(BigDecimal.new(d), 2000)).to_s
  num = num[2..-3].split('')  # ignores starting '0.' and ending "E0"

  num.shift if num[0] == '0'
  num.shift if num[0] == '0'  # remove any starting 0's. up to 2 of them.

  i = 0
  oldnum = [num[i]]

  while i < num.length - 2
    newnum = num[i + 1..2 * i + 1]
    # puts "i = #{i}, oldnum = #{oldnum}, newnum = #{newnum}"

    if newnum == oldnum
      cycle[d] = newnum.length
      # puts "1 / #{d} repeats for #{cycle} digits"
      break
    end
    
    # if the last 4 digits match previous 4 digits, you have a cycle
    if newnum.length >= 4 && newnum[-4..-1] == oldnum[-4..-1]
      cycle[d] = 1

      # digit is probably something like 0.166666...
      # puts "1 / #{d} repeats for (probably) 1 digit"
      break
    end

    i += 1
    oldnum = num[0..i]
  end
end

max = cycle.values.max

puts "Longest repeating cycle = 1 / #{cycle.key(max)}, with #{max} digits. It took #{Time.now - start} secs."

# "Longest repeating cycle = 1 / 983, with 982 digits. It took 0.632792 secs."

=begin
  
On Project Euler forum, zetetic said:

For all primes p valued 7 to 997, compute the sequence:

n(1) = 9
n(i+1) = mod (10 * n(i) + 9 , p)

When n(i) = 0 then i is the length of the reciprocal cycle of 1/p.

Why it works:

Only primes need be considered since any reciprocal of a composite either terminates or has the same cycle length as one of its prime factors.  What the repeated decimal of the reciprocal when p is prime represents is a fraction with a denominator composed of all 9's (I will call them 9-numbers for brevity's sake).  For example:

1/7 = .142857142857 ... = 142857 / 999999

So all we have to do to find the reciprocal cycle length is keep figuring out the remainder of successive 9-numbers when divided by our prime p until the remainder hits 0.  Since only the remainder matters we can take the modulus to base p each time so the numbers being considered will stay low.  I also use the fact that if m is a 9-number, 10m + 9 is the next 9-number.  Note that this algorithm only works for prime numbers greater than or equal to 7.  You can't simplify it by not computing primes and just running it on all numbers.

=end 