# Taken from http://www.mathblog.dk/project-euler-24-millionth-lexicographic-permutation/
# http://stackoverflow.com/questions/18557813/how-to-remember-swapped-array-elements-in-another-array

a = [*0..9]

start = Time.now

=begin            Best recursive routine. Output is in numerical (lexicographic) order!
def permute(a)
  perms = []
  return [a] if a.size < 2

  a.each do |e| 
    permute(a - [e]).each do |p|   # a - |e| is subarray of all elements to right of 1st one
      perms << ([e] + p)   # add 1st element back to left of array, for EACH permutation of subarray
    end
  end

  perms
end

p permute(a).map(&:join)    # prints array of strings of each permutation
puts "Took #{Time.now - start} secs."  # 9 items takes 7.5 secs. Can't handle >= 10 items.

=begin ------------------------------------------------
Output not in lexicographic order. Easy to remember. Can output by print, not by array.

def permute(p, k, n)
  p p if k == n

  (k..n).each do |i|
   
    p[k], p[i] = p[i], p[k]

    permute(p, k+1, n)

    p[k], p[i] = p[i], p[k]
  end
end

permute(list, 0, 3)


=end ---------------------------------

# Best non-recursive routine. Took only 1.4 secs to solve Project Euler 24.

count = 1
numPerm = 1_000_000   # get 1 millionth permutation
i, j = 0, 0
n = a.length

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