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
# ==================================================================

# Brute force way:
def slow_way
  longest = 0
  (2..999_999).each do |n|
    length = 1

    begin
      n = if n.even?
            n / 2
          else
            3 * n + 1
          end
      length += 1
    end until n == 1

    longest = length if length > longest
  end
  longest
end

start = Time.now
puts "Longest chain was #{slow_way} terms. Took #{Time.now - start} secs." # 19 secs

# Faster way, using memoization. Makes hash of prior Collatz lengths.
# If it sees old_length already recorded, adds old_length to length

class Collatz
  def initialize(max_num)
    @hash = {}
    @max_num = max_num
  end

  def longest_chain
    (2..@max_num - 1).each do |n|
      length = 1
      starting_n = n

      begin 
        if n.even?
          old_length = @hash[n/2]
          if old_length
            length += old_length 
            break
          else 
            n /= 2
          end
        else
          old_length = @hash[3 * n + 1]
          if old_length
            length += old_length
            break
          else
            n = 3 * n + 1
          end
        end

        length += 1
      end until n == 1

      @hash[starting_n] = length
    end
    longest = @hash.values.max
    return longest, @hash.key(longest)
  end 
end

start = Time.now
longest, starting_num = Collatz.new(1_000_000).longest_chain
puts "Longest chain of #{longest} terms was made by #{starting_num}. Took #{Time.now - start} secs."

# Longest chain of 525 terms was made by 837799. Took 3.03 secs. (Brute force way took 18.2 secs.)
