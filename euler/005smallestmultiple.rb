# http://projecteuler.net/problem=5
# 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
# What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

test = 20
divisor = 0

while true
  
  # Don't check factors from 1-10, since all included in 11-20. Plus check backwards from 20 down, to save time.
  20.downto(11) do |d|  
    divisor = d
    # puts "test = #{test}, d = #{d}"
    break if test % d != 0
  end
  if divisor == 11 && test % divisor == 0
    puts "Answer = #{test}"
    exit
  end
  test += 20  # only need to check multiples of 20
end
