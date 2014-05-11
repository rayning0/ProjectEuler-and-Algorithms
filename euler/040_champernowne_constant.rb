# http://projecteuler.net/problem=40
# If dn represents the nth digit of the fractional part, find the value of the following expression.
# d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000

def cconstant(n)
  count = 0
  digit = -1

  (1..n).each do |i|
    count += i.to_s.size
    if count >= n   # we've hit our goal!
      puts i
      count -= i.to_s.size   # go backwards 

      istring = i.to_s

      j = 1
      while j <= istring.size   # find where in i that count = n exactly
        count += j
        if count == n           # increment in istring by 1 till we find goal
          digit = istring[j - 1].to_i
          break
        end
        j += 1
      end
    end

    return digit if digit >= 0
  end

  digit
end

start = Time.now

product = 1

(0..6).each do |power|
  d = cconstant(10**power)
  puts "The 10^#{power}th digit is #{d}."
  product *= d
end

puts "Product of these digits = #{product}. It took #{Time.now - start} secs."

=begin
  
1
The 10^0th digit is 1.
10
The 10^1th digit is 1.
55
The 10^2th digit is 5.
370
The 10^3th digit is 3.
2777
The 10^4th digit is 7.
22222
The 10^5th digit is 2.
185185
The 10^6th digit is 1.
Product of these digits = 210. It took 0.106682 secs. 

=end
