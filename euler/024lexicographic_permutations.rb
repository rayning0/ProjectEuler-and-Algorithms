# http://projecteuler.net/problem=24
# What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?

# 1 line solution (but slow). It makes all 1 million permutations, then picks 1 millionth entry of string array

# [*0..9].permutation.map(&:join)[999_999] = answer!

# [*0..9] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Best non-recursive routine. Took only 1.4 secs to solve Project Euler 24.
# Taken from http://www.mathblog.dk/project-euler-24-millionth-lexicographic-permutation/

a = [*0..9]
count = 1
numPerm = 1_000_000   # get 1 millionth permutation
i, j = 0, 0
n = a.length

start = Time.now

while (count < numPerm) 
  i = n-1

  while (a[i - 1] >= a[i]) 
    i -= 1
  end 
 
  j = n

  while (a[j - 1] <= a[i - 1]) 
    j -= 1
  end  
 
  # start with a[i-1] = 8, a[j-1] = 9

  # swap values at position i-1 and j-1
  # puts "i-1 = #{i-1}, j-1 = #{j-1}"
  a[i - 1], a[j - 1] = a[j - 1], a[i - 1]

  # p a

  i += 1
  j = n

  while (i < j) 
    # puts "i-1 = #{i-1}, j-1 = #{j-1} (while i<j)"
    a[i - 1], a[j - 1] = a[j - 1], a[i - 1]

    # p a

    i += 1
    j -= 1
  end
  count += 1
end

p a
puts "It took #{Time.now - start} secs."

=begin

permutation = ''
c = 0

(0..9).each do |i|
  (0..9).each do |j|
    next if j == i
    (0..9).each do |k|
      next if [i, j].include?(k)        # skip to next value if value already used
      (0..9).each do |l|
        next if [i, j, k].include?(l)
        (0..9).each do |m|
          next if [i, j, k, l].include?(m)
          (0..9).each do |n|
            next if [i, j, k, l, m].include?(n)
            (0..9).each do |o|
              next if [i, j, k, l, m, n].include?(o)
              (0..9).each do |p|
                next if [i, j, k, l, m, n, o].include?(p)
                (0..9).each do |q|
                  next if [i, j, k, l, m, n, o, p].include?(q)
                  (0..9).each do |r|
                    next if [i, j, k, l, m, n, o, p, q].include?(r)
                    
                    c += 1
                    if c == 1_000_000
                      permutation = [i, j, k, l, m, n, o, p, q, r].join    # makes 1 string
                      puts "1 millionth lexicographic permutation = #{permutation}"
                      puts "Total time: #{Time.now - start} seconds."
                      exit
                    end

                  end
                end
              end
            end
          end
        end  
      end
    end
  end
end

=end
