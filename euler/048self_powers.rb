# http://projecteuler.net/problem=48
# Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000.

# I didn't even need the BigDecimal class. Ruby handles large digits fine by itself.

sum = 0
(1..999).each do |i|    # ignore 1000^1000, since its last digits are all 0's.
  sum += i**i
end

puts "Last 10 digits: #{sum.to_s[-10..-1]}"