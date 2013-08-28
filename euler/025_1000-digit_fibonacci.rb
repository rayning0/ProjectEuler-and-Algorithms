# http://projecteuler.net/problem=25
# What is the first term in the Fibonacci sequence to contain 1000 digits?

count = 3
f1, f2 = 1, 1

while true
  f3 = f1 + f2
  if f3.to_s.length == 1000
    puts "Fibonacci term number #{count} is the first with 1000 digits" 
    exit
  end
  f1 = f2
  f2 = f3
  count += 1
end