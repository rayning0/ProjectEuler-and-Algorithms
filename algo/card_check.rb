=begin

Raymond Gan - My credit card checking solution
  
From RubyQuiz.com
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Before a credit card is submitted to a financial institution, it generally makes
sense to run some simple reality checks on the number. The numbers are a good
length and it's common to make minor transcription errors when the card is not
scanned directly.

The first check people often do is to validate that the card matches a known
pattern from one of the accepted card providers. Some of these patterns are:

+============+=============+===============+
| Card Type | Begins With | Number Length |
+============+=============+===============+
| AMEX      | 34 or 37    | 15 |
+------------+-------------+---------------+
| Discover  | 6011        | 16 |
+------------+-------------+---------------+
| MasterCard | 51-55      | 16 |
+------------+-------------+---------------+
| Visa        | 4         | 13 or 16 |
+------------+-------------+---------------+

All of these card types also generate numbers such that they can be validated by
the Luhn algorithm, so that's the second check systems usually try. The steps
are:

1. Starting with the next to last digit and continuing with every other
digit going back to the beginning of the card, double the digit
2. Sum all doubled and untouched digits in the number
3. If that total is a multiple of 10, the number is valid

For example, given the card number 4408 0412 3456 7893:

Step 1: 8 4 0 8 0 4 2 2 6 4 10 6 14 8 18 3
Step 2: 8+4+0+8+0+4+2+2+6+4+1+0+6+1+4+8+1+8+3 = 70
Step 3: 70 % 10 == 0

Thus that card is valid.

Let's try one more, 4417 1234 5678 9112:

Step 1: 8 4 2 7 2 2 6 4 10 6 14 8 18 1 2 2
Step 2: 8+4+2+7+2+2+6+4+1+0+6+1+4+8+1+8+1+2+2 = 69
Step 3: 69 % 10 != 0

That card is not valid.

This week's Ruby Quiz is to write a program that accepts a credit card number as
a command-line argument. The program should print the card's type (or Unknown)
as well a Valid/Invalid indication of whether or not the card passes the Luhn
algorithm.
  
=end

def card_check(cnumber)
  result = []
  sum = 0
  
  case cnumber
  
  # use http://rubular.com/ to figure out regular expression
  
  when /\A3(4|7)\d{13}\z/   # begins with 34 or 37, 15 digits long
    result[0] = 'americanexpress'
  when /\A6011\d{12}\z/     # begins with 6011, 16 digits long
    result[0] = 'discover'
  when /\A5[1-5]\d{14}\z/   # begins with 51-55, 16 digits long
    result[0] = 'mastercard'
  when /\A4\d{15}\z/, /\A4\d{12}\z/   # begins with 4, 16 or 13 digits long
    result[0] = 'visa'
  else
    result[0] = 'unknown'
    result[1] = 'invalid'
    return result
  end
  
# check if card is valid by Luhn algorithm
  
  # double is array with sum of digits of a value after it's doubled. 
  # 0*2 = 0, 1*2 = 2, 2*2 = 4, 3*2 = 6, 4*2 = 8, 5*2 = 10 => 1+0 = 1, 6*2 = 12 => 1+2 = 3, etc.
  double = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
  
  cnumber.reverse!  # write number backwards
  number = cnumber.split('')  # cut reversed number into array of single digits
  number.each_with_index do |n, i|  # makes hash of number. n = digit, i = index

    # for every even index, add digit to sum. for every odd index, add double of digit to sum.
    # puts "n = #{n}, i = #{i}"
    sum += (i.even?) ? n.to_i : double[n.to_i] 
    # puts "sum = #{sum}"
  end
  
  # if total sum is multiple of 10, card number is valid
  (sum % 10 == 0) ? result[1] = 'valid' : result[1] = 'invalid'

  result
end

=begin   ----check output of code

  cards = ['1', "4539525598576146", "4716016802653546", "5421884638451606", "5206355609152441", 
    "373000624988415", "342458690063208", "6011633808627972", "6011956740671844"]

  cards.each do |c|
    s, r = card_check(c)
    puts "sum = #{s}, type = #{r[0]}, result = #{r[1]}"
  end

=end