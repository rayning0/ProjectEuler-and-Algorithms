# http://projecteuler.net/problem=32
# Find the sum of all products whose multiplicand/multiplier/product
# identity can be written as a 1 through 9 pandigital.
# You may NOT have duplicate products!

# Ex: 39 * 186 = 7254 (uses all digits 1-9)

# Note: both factors can only be maximum 3 digit numbers!
# Otherwise, we go over our 9 digit limit.

# We have 920 nums from 2 to 987 with up to 4 unique digits and no 0's.
t = Time.now
@factors = [*2..1987].map(&:to_s).reject { |n| n =~ /0/ }.select { |n| n.chars.uniq == n.chars }

def prod(factor1, factor2)
  factor1.to_i * factor2.to_i
end

def pandigital?(factor1, factor2)
  p = prod(factor1, factor2).to_s
  return false if p =~ /0/  # product has '0' in it
  concat = factor1 + factor2 + p
  return false if concat.size != 9
  return false if concat.chars.uniq != concat.chars  # remove duplicate digits
  true
end

  fpairs = []
  @factors.each do |f1|
    f1_index = @factors.index(f1)
    @factors[f1_index + 1..-1].each do |f2|
      fpairs << [f1, f2]
    end
  end

products = []
# nested array of factor pairs: [['39', '186'], ['41', '52'], ...]
fpairs.each do |fpair|
  if pandigital?(fpair[0], fpair[1])
    p = prod(fpair[0], fpair[1])
    unless products.include?(p)
      products << p
      #puts "ppair: #{fpair[0]} #{fpair[1]}, prod: #{p}"
    end
  end
end

puts "Answer: #{products.inject(&:+)}, Time: #{Time.now - t} secs"
