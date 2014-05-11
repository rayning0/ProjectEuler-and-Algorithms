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

# lengths = [0,0]
#(2..999_999).each do |n|
#  c = 1
#
#  begin
#    if n.even?
#      n /= 2
#    else
#      n = 3 * n + 1
#    end
#    c += 1
#  end until n == 1
#
#  lengths << c    # record chain length
#end

# Faster way, using memoization. Makes hash of previous Collatz lengths.
# If it sees previous length (length_old) was recorded, adds previous to count_length

start = Time.now

class Collatz
  def initialize(max_num)
    @hash = {}
    @max_num = max_num
  end

  def longest
    (2..@max_num - 1).each do |n|
      count_length = 1
      starting_n = n

      begin 

        if n.even?
          length_old = @hash[n/2]
          if !length_old.nil?
            count_length += length_old 
            break
          else 
            n /= 2
          end
        else
          length_old = @hash[3 * n + 1]
          if !length_old.nil?
            count_length += length_old
            break
          else
            n = 3 * n + 1
          end
        end

        count_length += 1
      end until n == 1

      @hash[starting_n] = count_length
    end
    max = @hash.values.max
    return max, @hash.key(max)
  end 
end

c = Collatz.new(1_000_000)
max, start_num = c.longest
puts "Longest chain of #{max} terms was made by #{start_num}. Took #{Time.now - start} secs."

# Longest chain of 525 terms was made by 837799. Took 6.40706 secs. (Brute force way took 21 secs.)