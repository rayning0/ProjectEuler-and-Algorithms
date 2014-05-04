# http://projecteuler.net/problem=92

class SquareDigit
  SQ = [*1..9].map{|i| i*i}.unshift(0)  # array of squares from 1..81

  attr_reader :max, :results, :table, :table89
  def initialize(max)
    @max = max
    @results = []
    # out of 10 million, only get 567 possible 1st sums = (9 * 9) * 7
    @table = [*1..567].map {|n| sum_digits(n)}.unshift(0) # sums of all 567 1st sums

    # maps each sum to T/F, to avoid recursion later
    @table89 = {}
    table[1..-1].each {|sum| @table89[sum] = sum_digits_89(sum) }
  end

  def sum_digits(num)
    num.to_s.chars.inject(0) {|s, digit| s + SQ[digit.to_i]}
  end

  # tell (through recursion) if ultimate sum = 89 or not
  def sum_digits_89(num)
    r = results[num]
    return r unless r.nil?
    sum = sum_digits(num)
    results[num] = true if sum == 89
    results[num] = false if sum == 1
    sum_digits_89(sum)
  end

  def run
    sum_to_one = []
    (1..max - 1).each do |num|

      # MUCH FASTER way to sum digits in number than .to_s.chars.map(&:to_i).inject!!!
      first_sum = 0
      begin
        first_sum += SQ[num % 10]   # adds units digit squared
        num /= 10                   # num is shifted to right
      end until num == 0

      # SLOW WAY!!! Don't use.
      # first_sum = num.to_s.chars.map(&:to_i).inject(0) {|fs, v| fs + SQ[v]}

      next if table89[table[first_sum]] # skip num if its sum = 89
      sum_to_one << num
    end
    puts "nums < 10,000,000 whose square digits sum to 89: #{max - 1 - sum_to_one.count}"
  end

end

time = Time.now
s = SquareDigit.new(10_000_000)
s.run

puts "Total time: #{Time.now - time} secs"

# 1st draft of my program took 216.3 secs for 10 million numbers. I did recursion to sum each number.

# 2nd draft used a lookup table for 567 different 1st sums, then another lookup table to
# map 1st sum to true/false values. It took 114.5 secs.

# After removing "sort" from num.to_s.sort.chars, I cut it dramatically to 84 secs.

# Finally, after avoiding cumbersome to_s.chars.map(&:to_i).inject  to make 1st sums of digits,
# I dramatically dropped my time to only 13.5 secs for 10 million numbers!!!
# That's an 84% drop in time from using to_s => to_i!

# I cut my starting time by 94%, using this better algorithm!!! It's 16 times as fast as before!!!