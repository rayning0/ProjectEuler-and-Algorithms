# http://projecteuler.net/problem=18
# Find the maximum total from top to bottom of the triangle below:
# As there are only 2**(rows - 1) = 16384 routes, it is possible to solve this problem 
# by trying every route. However, Problem 67, is the same challenge with a 
# triangle containing one-hundred rows; it cannot be solved by brute force, 
# and requires a clever method! ;o)

=begin
 reads in file of triangle numbers. Each line is separate element in array. 
 Makes array like this:

   ["75\n",
    "95 64\n",
    "17 47 82\n",
    "18 35 87 10\n"]

=end

$t = IO.readlines('triangle.txt')   
$t.map!(&:chomp)    # removes all trailing "\n" from each line
$t.map!(&:split)    # splits each line with commas. Makes each line a separate nested array

=begin
  
[["75"],
 ["95", "64"],
 ["17", "47", "82"],
  
=end

$t.each do |a|
  a.map!(&:to_i)    # finally, we convert all elements in nested array to integers!
end

=begin
  
[[75],
 [95, 64],
 [17, 47, 82],
 [18, 35, 87, 10]]
  
=end

def solve(row, col)   # recursive solution is so much easier! But it's too slow for problem 67, super big triangle.
   return 0 if row == $t.length
   return $t[row][col] + [solve(row + 1, col), solve(row + 1, col + 1)].max
end

puts "Max sum of path down triangle = #{solve(0, 0)}"

=begin  -------- My original random trial solution. Not reliable. ---------
sums = []

def routesum(t, sums)
  sum = 0
  col = 0
  # colold = -1

  (0..t.size - 1).each do |row|

    #  if col == colold   # only want cols in row that are adjacent to col from last row
    #    
    #    if t[row][col + 1] > t[row][col]  # we can only move to 2 spots: col or col+1
    #      col += 1                # make current col = col with bigger number
    #    end
    #  end

    if row != 0
      col += 1 if rand(2) == 1    # make a random decision whether to pick L or R number 
    end
    #print "Row = #{row}, Col = #{col}, "
    sum += t[row][col]
    #puts "Sum = #{sum}"
    # colold = col    # column # of previous row
  end

  sums << sum
  puts "Sum of route = #{sum}"
  sums
end

10000.times do        # doesn't always give right answer
  routesum(t, sums)
end

print sums
puts
puts "Max sum of path after 10000 random trials = #{sums.max}"
=end
