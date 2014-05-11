# http://projecteuler.net/problem=15
# Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down, there 
# are exactly 6 routes to the bottom right corner. How many such routes are there through a 20×20 grid?

=begin
Best way: dynamic programming. As you move from upper left to bottom right, keep track of # of paths
to reach any point. Put that # in array. 

# of paths to reach any point = # of paths to reach square ABOVE it + # of paths to reach square to its LEFT.

When you reach lower right corner, tbe final total of paths will be the answer!  

Here's a "pretty picture" of different paths: http://mathforum.org/advanced/robertd/manhattan.html
=end

start = Time.now

n = 20
grid = Array.new(n + 1) {Array.new(n + 1, 0)}  # makes (n + 1) x (n + 1) array filled with 0's.

(0..n).each do |i|  # Fill row 0 and col 0 all with 1's. Only 1 way to get to each square on top/left edges.
  grid[0][i] = 1
  grid[i][0] = 1
end

(1..n).each do |row|
  (1..n).each do |col|
    # each element = # of paths in square above + # of paths in square to left
    grid[row][col] = grid[row - 1][col] + grid[row][col - 1]  
  end
end

puts "Number of paths to get from upper left to bottom right of a #{n} x #{n} grid,"
puts "if you may only move right or down each step, is #{grid[n][n]}. Time: #{Time.now - start} secs."

=begin 

Output: "Number of paths to get from upper left to bottom right of a 20 x 20 grid,
if you may only move right or down each step, is 137846528820. Time: 0.000422 secs."

(0..n).each do |row|  # prints whole matrix 
  p grid[row]
end

Math way. The simplest answer, from combinatorics, is 40 choose 20 = 40! / (20! * 20!) = 137846528820.
Why? To get to our destination, in all cases, we must always move 20 times right and 20 times down. 
The question is WHEN we move right vs. WHEN we move down. We always move 40 steps total.

Once we choose which steps we move right, all other steps MUST be moves down. No choice.
Thus our answer is just the # of ways we can pick 20 times moving right, out of 40 steps.

Let's see a 3x3 grid. It has 6 steps total, 3 right and 3 down. Here's 1 path:

R _ R _ _ R.  Let's say we pick to move right in steps 1, 3, and 6. Steps 2, 4, and 5 MUST be down!
R D R D D R.  We have no other choice. Thus # of paths for a 3x3 grid = 6 choose 3 = 6! (3! * 3!)
=end

