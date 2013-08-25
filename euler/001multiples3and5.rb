# http://projecteuler.net/problem=1
# Write sum of all integers < 1000 that are multiples of 3 and/or 5

sum = 0
i = 3
while i < 1000
  sum += i if (i % 3 == 0) || (i % 5 == 0)
  i += 1
end
puts sum 