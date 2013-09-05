# http://projecteuler.net/problem=52
# Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x, contain the same digits.

start = Time.now
(10..200_000).each do |x|
  p = []
  (1..6).each do |i|
    p[i] = (i * x).to_s.split('').sort  # turns x into ['1', '2', '3', '4']
  end

  if [p[2], p[3], p[4], p[5], p[6]].all? {|y| y == p[1]}  # if they're all equal
 
     puts "Smallest x such that 2x, 3x, 4x, 5x, and 6x, contain same digits = #{x}.\nMultiples: #{2*x}, #{3*x}, #{4*x}, #{5*x}, #{6*x}. Took #{Time.now - start} secs."
  end
end

=begin
 Smallest x such that 2x, 3x, 4x, 5x, and 6x, contain same digits = 142857.
Multiples: 285714, 428571, 571428, 714285, 857142. Took 11.35892 secs.
=end