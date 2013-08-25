# The infamous FizzBuzz question
# http://www.codinghorror.com/blog/2007/02/why-cant-programmers-program.html
# "Write a program that prints the numbers from 1 to 100. But for multiples of 3 print "Fizz" instead of the number and for multiples of 5 print "Buzz". For multiples of both 3 and 5 print "FizzBuzz".

(1..100).each do |n|
  output = ''
  output << "Fizz" if n % 3 == 0
  output << "Buzz" if n % 5 == 0
  output << n.to_s if output.empty?
  puts output
end
