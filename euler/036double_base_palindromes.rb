# http://projecteuler.net/index.php?section=problems&id=36
# Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.

sum = 0
(1..999_999).each do |n|
  nbin = n.to_s(2)
  sum += n if (n.to_s == n.to_s.reverse) && (nbin == nbin.reverse)
end
puts "Sum of all #'s that are palindromes in both base 10 and 2 = #{sum}"