# http://projecteuler.net/problem=67
# Find the maximum total from top to bottom in triangle2.txt, a text file containing a 100-row triangle.
# This is a much more difficult version of Problem 18. It is not possible to try every route to solve this problem, as there are 299 altogether! If you could check 1 trillion routes every second it would take over 20 billion years to check them all. There is an efficient algorithm to solve it. 

t = IO.readlines('triangle2.txt')   
t.map!(&:chomp).map!(&:split)    # removes whitespace and splits each line with commas. Makes each line separate nested array

t.each do |a|
  a.map!(&:to_i)    # convert all elements in nested array to integers
end

=begin              # triangle looks like this, with 100 rows
[[75],
 [95, 64],
 [17, 47, 82],
 [18, 35, 87, 10]]
=end

sum, sumup, sumdiag = 0, 0, 0

(t.size - 1).downto(1).each do |row|    # start from bottom of triangle and move upwards
  (0..row - 1).each do |col|
    # puts "row = #{row}, col = #{col}, t(row,col) = #{t[row][col]}"

    sumup = t[row][col] + t[row - 1][col]         # sum vertically up triangle
    sumdiag = t[row][col + 1] + t[row - 1][col]   # sum from lower right to upper left
    if sumup > sumdiag
      t[row - 1][col] = sumup     # replace value in row above with the greater sum, from bottom up
    else
      t[row - 1][col] = sumdiag
    end
  end
end

puts "Maximum sum from top to bottom = #{t[0][0]}. (I really added this from bottom to top.)"