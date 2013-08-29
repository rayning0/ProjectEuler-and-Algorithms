# http://projecteuler.net/problem=14
# The following iterative sequence is defined for the set of positive integers:

# n → n/2 (n is even)
# n → 3n + 1 (n is odd)
# 
# Using the rule above and starting with 13, we generate the following sequence:
# 
# 13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1
# It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms.
# It is thought that all starting numbers finish at 1.
# 
# Which starting number, < 1 million, produces the longest chain?

lengths = [0,0]

(2..999_999).each do |n|
  c = 1

  begin
    if n.even?
      n /= 2
    else
      n = 3 * n + 1
    end
    c += 1
  end until n == 1

  lengths << c    # record chain length
end

max = lengths.max 
puts "Longest chain of #{max} terms was made by #{lengths.index(max)}"