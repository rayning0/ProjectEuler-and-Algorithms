# http://projecteuler.net/problem=4
# Find the largest palindrome made from the product of two 3-digit numbers.

def is_palindrome?(n)
  n.to_s == n.to_s.reverse
end

palindromes = []

start = Time.now
999.downto(900) do |x|    # don't need to look at numbers below 900
  999.downto(900) do |y|
    if is_palindrome?(x * y)
      puts "#{x * y} = #{x} * #{y}"
      palindromes << x * y
    end
  end
end

puts "Largest palindrome = #{palindromes.max}"
puts "It took #{Time.now - start} secs."