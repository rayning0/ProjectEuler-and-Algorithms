# http://projecteuler.net/problem=15
# Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down, there 
# are exactly 6 routes to the bottom right corner. How many such routes are there through a 20×20 grid?

=begin
  
Tricky. The simplest answer, from combinatorics, is 40 choose 20 = 40! / (20! * 20!) = 137846528820.
Why? To get to our destination, in all cases, we must always move 20 times right and 20 times down. 
The question is WHEN we move right vs. WHEN we move down. We always move 40 steps total.

Once we choose which steps we move right, all other steps MUST be moves down. No choice.
Thus our answer is just the # of ways we can pick 20 times moving right, out of 40 steps.

Let's see a 3x3 grid. It has 6 steps total, 3 right and 3 down. Here's 1 path:

R _ R _ _ R.  Let's say we pick to move right in steps 1, 3, and 6. Steps 2, 4, and 5 MUST be down!
R D R D D R.  We have no other choice. Thus # of paths for a 3x3 grid = 6 choose 3 = 6! (3! * 3!)
  
=end

# Trying randomly walking along path

allpaths = []

1000.times do
  path = [[0, 0]]
  x, y = 0, 0

  while x < 20 && y < 20
    rand(2) == 1 ? x += 1 : y += 1
    path << [x, y]
  end

   print path; puts

  allpaths << path    # stick single path into array of all paths
  allpaths.uniq!      # eliminate duplicate paths
end

#print allpaths; puts
print "Number of paths = #{allpaths.size}\n"