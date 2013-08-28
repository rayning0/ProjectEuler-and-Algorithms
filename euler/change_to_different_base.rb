puts "Enter integer"
num = gets.chomp.to_i
puts "Convert to what base?"
base = gets.chomp.to_i

def dec2base(num, base) # converts base 10 to a different base (<= 10)
  # easiest solution:   num.to_s(base) --- but this is cheating!
  answer = []
  while num != 0
    answer << num % base        # num mod base = remainder, which is rightmost digit
    num /= base                 # num / base = left part of num, without rightmost digit
  end 
  answer.reverse!.join.to_i  # Answer is backwards. Reverse, join into string, change back to integer.
end

puts "Answer = #{dec2base(num, base)}. A2 = #{num.to_s(base)}"