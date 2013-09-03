# http://projecteuler.net/problem=40
# If dn represents the nth digit of the fractional part, find the value of the following expression.
# d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000

def finddigit(n, digits, countold)
  nines = ''
  (digits - 1).times do
    nines += '9'    # For 3 digit num: nines = 99. 4 digit num: nines = 999, etc.
  end
  nines = nines.to_i
  
  answer = (n - countold)/digits.to_f + nines     # actual number in which final answer appears

# fractional part of answer. if not 0, we must adjust. 
# Ex: if answer = 2134.75, digit = 3/4 of way into NEXT answer, or "213 | 5."  So digit = '3'

  fraction = answer - answer.to_i     

  if fraction == 0
    digit = answer.to_s[-1].to_i    # take last digit of answer
  else
    answer = (answer + 1).to_i.to_s
    digit = answer[fraction * answer.size.to_i - 1].to_i
  end

  digit
end

def cconstant(n)
  digit = 0     # answer: the nth digit 
  
  case n
  when 1..9               # 1 digit num
    digit = n
  when 10..189            # 2 digit num
    digit = finddigit(n, 2, 9)
  when 190..2889          # 3 digit num
    digit = finddigit(n, 3, 189) 
  when 2890..38889        # 4 digit num
    digit = finddigit(n, 4, 2889)
  when 38890..488889      # 5 digit num
    digit = finddigit(n, 5, 38889)
  when 488890..5888889    # 6 digit num
    digit = finddigit(n, 6, 488889)
  else
    exit
  end
  digit
end

start = Time.now

product = 1

(0..6).each do |i|
  d = cconstant(10**i)
  puts "The 10^#{i}th digit is #{d}."
  product *= d
end

puts "Product of these digits = #{product}. It took #{Time.now - start} secs."

=begin
---------------------
count = 0
# 1 digit nums
count += 9 = 9  --------
digit = 9

count = 10
digit = 1 #

# 2 digit nums
count += 2 * (54-9) = 99
count = 100
digit = 5 #

or
count += 2 * (99 - 9) = 189 -----
count += 180 = 189
digit = 9

# 3 digit nums
count += 810 = 999
count += 3 * (x - 99) = 999 
x= 369
count = 1000 
digit = 3 #

or
count += 3 * (999 - 99) = 2889 ------
digit = 9
count = 2890
digit = 1 (for 1000)

# 4 digit nums
count += 7110 = 9999
count += 4 * (x - 999) = 10000
x= 2776.75 (remember to use float, not int!)  = really is 3/4 of way into next number 277|7
digit = 7  #


count += 4 * (9999 - 999) = 38889 ----

-----------------
#5 digit nums
count += 5 * (x - 9999) = 100_000
x =  22221.2, so its really 1/5 of way into next number = 2|2222
digit = 2 #
count += 5 * (99999 - 9999) = 488889 -------
-------------
#6 digit nums
count += 6 * (x - 99999) = 1_000_000
x = 185184.166..., so its really 1/6 of way into number = 1|85185
digit = 1 #


=end


