# Fibonacci sequence: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
# Find sum of even-valued terms in Fibonacci sequence whose values < 4 million
# http://projecteuler.net/problem=2

sum, f0, f1 = 0, 1, 1

while true
  f2 = f0 + f1
  sum += f2 if f2.even?

  if f2 > 4e6
    puts "Sum of all even-valued terms in Fibonacci sequence < 4 million = #{sum}"
    exit
  end

  f0 = f1
  f1 = f2
end

=begin  ---- Using arrays ------
sum = 0
i = 2
f = []
f[0], f[1] = 1, 1

while true
  f[i] = f[i - 1] + f[i - 2]
  sum += f[i] if f[i].even?
  puts "i = #{i}, f[i] = #{f[i]}, sum = #{sum}"
  if f[i] > 4e6
    print f
    puts
    puts "Sum of all even-valued terms in Fibonacci sequence < 4 million = #{sum}"
    exit
  end
  i += 1
end 
=end
