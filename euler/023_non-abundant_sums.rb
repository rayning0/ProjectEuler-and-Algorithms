# http://projecteuler.net/problem=23
# A number n is "abundant" if the sum of all its "proper divisors" exceeds n.
# All integers > 20161 can be written as sum of two abundant numbers. (According to Wolfram Mathworld)
# Find sum of all positive integers which CANNOT be written as sum of 2 abundant numbers.

def factors(noriginal)   # gives n's proper divisors
  factors = [1]          # 1 is always a factor. Exclude n to get "proper divisors"
  f = 2

  begin
    n = noriginal

    while f * f <= n         # Only check up to sqrt(n)
      if n % f == 0
        factors << f << n / f      
        n /= f
      else

        f += 1
        if noriginal % f == 0   # catches divisors you missed with n < noriginal
          factors << f << noriginal / f
        end
      end
    end  

    f += 1
  end until f * f > noriginal # Overall, only check up to sqrt(noriginal)

  factors.uniq.sort         # sort and remove duplicates
end

abundant = []   # all abundant #'s <= 28123 (in original problem). Dropped it to 20161 for speed.

start = Time.now

(1..20161).each do |n|
  # if sum of n's proper divisors > n, n = "abundant"
  abundant << n if factors(n).inject(:+) > n    
end

# Make array of all sums of 2 abundant nums, where sums <= 20161.
sum_abundant = [] 

abundant.each_with_index do |a1, index|

  while index < abundant.size
    a2 = abundant[index]   # a2 only needs to range from a1 to last abundant number!
    sum = a1 + a2

    sum > 20161 ? break : sum_abundant << sum

    index += 1
  end
end

sum_all = (1..20161).inject(:+)         # sum of all ints from 1 to 20161
sum_ab = sum_abundant.uniq!.inject(:+)  # add all ints that CAN be written as sum of 2 abundant nums. No duplicates.

# sum of all ints who CAN'T be written = sum of ALL ints - sum of all who CAN be written
sum_nonabundant                       =  sum_all         - sum_ab  

puts "Sum of all integers which are NOT sums of 2 abundant #'s = #{sum_nonabundant}"
puts "Total time: #{Time.now - start} seconds"