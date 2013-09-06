# Raymond Gan-------Tower of Hanoi problem-------------
# http://en.wikipedia.org/wiki/Tower_of_Hanoi

#     Recursive solution:
# http://www.sparknotes.com/cs/recursion/examples/section6.rhtml 

#     Iterative solution:
# http://apcentral.collegeboard.com/apc/members/courses/teachers_corner/45418.html
# http://www.ecse.rpi.edu/~wrf/p/28-sigplan84-hanoi.pdf

# No disk may be moved twice in a row. May not move bigger disk on top of smaller one.
# Must move smallest possible disk (as long as not last one moved).
# A = source, B = temp, C = destination

class Array     # prints multidimensional array in pretty format
  def to_table 
    l = []
    self.each{|r|r.each_with_index{|f,i|l[i] = [l[i]||0, f.to_s.length].max}}
    self.each{|r|r.each_with_index{|f,i|print "#{f.to_s.ljust l[i]} "}; puts}
  end
end

# Recursive solution
def toh(n, source = 'A', temp = 'B', dest = 'C')  
  toh(n - 1, source, dest, temp) if n > 1  # move all n - 1 disks to temp pole
  puts "Move top disc #{n}: #{source} => #{dest}." # move bottom disk to destination pole

  toh(n - 1, temp, source, dest) if n > 1  # move all n - 1 disks to destination pole
end

# Iterative solution:
# If n = odd: Move all odd disks to left. All even disks to right.
# If n = even: Move all odd disks to right. All even disks to left.

def toh_iterative(n)
  t = [['A', 'B', 'C']]
  col = 0                     # starting column
  top = 1                     # starting top disk
  n.downto(1) do |i|
    t.unshift([i, '', ''])    # build starting tower array
  end
  t.to_table                  # print it
  moves = 2 ** n - 1

  moves.times do  
    !n.even? ? left = 1 : left = -1   # if n odd, move odd disks left, else move right.
    startcol = col
    startrow = t.transpose[col].index(top)

    if !top.even?
      # move left if disk odd and n odd. move right if disk odd and n even.
      col -= left
      col = 2 if col < 0      # If moves off edge, swing it back around.
      col = 0 if col > 2
    else
      # move right if disk even and n odd. move left if disk even and n odd.
      col += left 
      col = 2 if col < 0      # If moves off edge, swing it back around.
      col = 0 if col > 2
    end
    
    endtop = t.transpose[col].detect {|d| d != ''}  # top disk in new column
    row = t.transpose[col].index(endtop) - 1        # 1st empty row in new column

    t[startrow][startcol] = '' # erase entry in disk's previous location
    t[row][col] = top          # write disk in new location
    t.to_table

    top_maybe = []

    (0..2).each do |c|        # What disk do we move next?
      top_maybe[c] = t.transpose[c].detect {|d| d != ''}  # top disk in column c

    # May not move current disk in next move. Make it high so it's not picked.
      top_maybe[c] = 100 if c == col              
      top_maybe[c] = 100 if top_maybe[c].is_a?(String)   # Column is empty
    end

    top = top_maybe.min   # Next disk is smallest possible one.
    col = top_maybe.index(top)
  end
end

puts "Enter number of disks for Tower of Hanoi:"
n = gets.chomp.to_i

start = Time.now
toh(n)
puts "Recursive way took #{Time.now - start} secs."

start = Time.now
toh_iterative(n)
puts "Iterative way took #{Time.now - start} secs."

=begin     Output:

Enter number of disks for Tower of Hanoi:
3
Move top disc 1: A => C.
Move top disc 2: A => B.
Move top disc 1: C => B.
Move top disc 3: A => C.
Move top disc 1: B => A.
Move top disc 2: B => C.
Move top disc 1: A => C.
Recursive way took 0.000109 secs.
1     
2     
3     
A B C 
      
2     
3   1 
A B C 
      
      
3 2 1 
A B C 
      
  1   
3 2   
A B C 
      
  1   
  2 3 
A B C 
      
      
1 2 3 
A B C 
      
    2 
1   3 
A B C 
    1 
    2 
    3 
A B C 
Iterative way took 0.016033 secs.

=end