require 'benchmark'

def count_iterations_storing_in_array(curr_val, curr_iterations=0)
  if ($known_vals[curr_val] || curr_val <= 1)
    return ($known_vals[curr_val] || 0) + curr_iterations
  else
    curr_val = if curr_val%2 == 0 then curr_val/2 else 3*curr_val + 1 end
    return count_iterations_storing_in_array(curr_val, curr_iterations+1)
  end
end

def count_iterations(curr_val, curr_iterations=0)
  if ($known_vals.key?(curr_val) || curr_val <= 1)
    return $known_vals[curr_val] + curr_iterations
  else
    curr_val = if curr_val%2 == 0 then curr_val/2 else 3*curr_val + 1 end
    return count_iterations(curr_val, curr_iterations+1)
  end
end

def solveWithArray
  $known_vals = Array.new(1000020){ |i| nil }
  $greatest_found = [-1, nil]
  (1..1000000).each do |i|
    iterations = count_iterations_storing_in_array(i)
    $known_vals[i] = iterations
    $greatest_found = [iterations, i] if iterations > $greatest_found[0]
  end
end

def solveWithHash
  $known_vals = {1 => 1}
  $greatest_found = [-1, nil]
  (1..1000000).each do |i|
    iterations = count_iterations(i)
    $known_vals[i] = iterations
    $greatest_found = [iterations, i] if iterations > $greatest_found[0]
  end
end


puts "Using hash: "
Benchmark.bm() do |x|
  3.times { x.report() { solveWithHash } }
end

puts "\n\nUsing array: "
Benchmark.bm() do |x|
  3.times { x.report() { solveWithArray } }
end

puts 'SOLUTION', $greatest_found



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
require 'rspec/autorun'

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

# start = Time.now
# puts "Longest chain was #{slow_way} terms. Took #{Time.now - start} secs." # 18.2 secs

# Faster way, using memoization. Makes hash of prior Collatz lengths.
# If it sees old_length already recorded, adds old_length to length

class Collatz
  def longest_chain(starting_num)
    old_length = {}
    longest = 1
    longest_n = starting_num
    length = 1

    (2..starting_num).each do |n|
      initial_n = n

      until n == 1 || old_length[n]
        n = if n.even?
              n / 2
            else
              3 * n + 1
            end
        length += 1
      end

      length += old_length[n] if old_length[n]
      old_length[initial_n] = length

      if length > longest
        longest = length
        longest_n = initial_n
      end
      length = 0
    end
    return longest, longest_n
  end 
end

# start = Time.now
# longest, starting_num = Collatz.new.longest_chain(999_999)
# puts "Longest chain of #{longest} terms was made by #{starting_num}. Took #{Time.now - start} secs."
# Longest chain of 525 terms was made by 837799. Took 2.75 secs. (Brute force way took 18.2 secs.)

describe Collatz do
  let(:c) { Collatz.new }
  it '#longest_chain' do
    expect(c.longest_chain(1)).to eq [1, 1]
    expect(c.longest_chain(2)).to eq [2, 2]
    expect(c.longest_chain(3)).to eq [8, 3]
    expect(c.longest_chain(13)).to eq [20, 9]
    expect(c.longest_chain(999_999)).to eq [525, 837799]
  end
end
