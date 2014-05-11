# http://projecteuler.net/problem=9
# There exists exactly one Pythagorean triplet for which a + b + c = 1000. Find product abc.

(1..998).each do |a|
  (2..999).each do |b|
    c = 1000 - a - b
    if a < b && b < c
      if a * a + b * b == c * c
        puts "Product of Pythagorean triplet = #{a * b * c}"
        exit 
      end
    end
  end
end