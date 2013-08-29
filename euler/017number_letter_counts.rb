# http://projecteuler.net/problem=17
# If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, 
# how many letters would be used?

# Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 
# 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when 
# writing out numbers is in compliance with British usage.

def in_words(n)
  # n / power of 10 = leftmost digit. n % power of 10 = remaining right digits.

  words = []

  case n
  when 0..19
    words.unshift(teen(n))
  when 20..99
    words.unshift(tens(n))
  when 100..999
    words.unshift(hundreds(n))
  when 1000..999_999
    words.unshift(thousands(n))
  end

  words.join(' ')
end

def thousands(n)
  return hundreds(n) if n < 1000

  if n % 10**(n.to_s.length - 1) != 0
    hundreds(n / 1000) + ' thousand ' + hundreds(n % 1000)
  else
    hundreds(n / 1000) + ' thousand'
  end
end

def hundreds(n)
  return tens(n) if n < 100

  if n % 100 != 0   # if number is not 100, 200, 300, etc.
    teen(n / 100) + ' hundred and ' + tens(n % 100)
  else
    teen(n / 100) + ' hundred'
  end
end

def tens(n)
  return teen(n) if n < 20

  d = %w[twenty thirty forty fifty sixty seventy eighty ninety]

  if n % 10 != 0    # if last digit isn't 0
    d[n / 10 - 2] + ' ' + teen(n % 10)
  else
    d[n / 10 - 2]
  end
end

def teen(n)
  d = %w[zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen]
  d[n]
end

total = 0

(1..1000).each do |n|
  total += in_words(n).split.join.length    # makes string with no spaces. finds length.
end

puts "# of letters in all numbers from 1 to 1000, written out: #{total}"

=begin
puts "Enter number. I'll repeat it in words and say # of letters:"
n = gets.chomp.to_i
w = in_words(n)
puts "In words: #{w}"
puts "Letters: #{w.split.join.length}"
=end