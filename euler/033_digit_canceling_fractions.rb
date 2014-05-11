=begin
http://projecteuler.net/problem=33
The fraction 49/98 is a curious fraction, as an inexperienced mathematician in attempting to simplify it may incorrectly believe that 49/98 = 4/8, which is correct, is obtained by cancelling the 9s.

There are exactly four non-trivial examples of this type of fraction, less than one in value, 
and containing two digits in the numerator and denominator.

If the product of these four fractions is given in its lowest common terms, find the value of the denominator.
=end
start = Time.now

fractions = {}
(12..98).each do |t|

  (t + 1..99).each do |b|     # top/bottom < 1
    # reject if t, b are both same or both multiples of 10 or 11. trivial.
    next if b == t || (b % 10 == 0 && t % 10 == 0) || (b % 11 == 0 && t % 11 == 0)    
    t0 = t.to_s[0].to_f     # first digit of top number
    t1 = t.to_s[1].to_f     # second digit of top number
    b0 = b.to_s[0].to_f  
    b1 = b.to_s[1].to_f  

    f = t.to_f / b.to_f    # we need floating point decimal. otherwise, integer divisions round to integer
    fractions["#{t}/#{b}"] = f if (t0 == b0 && f == t1/b1) || (t1 == b1 && f == t0/b0) \
                              ||  (t0 == b1 && f == t1/b0) || (t1 == b0 && f == t0/b1)
  end
end

p fractions
frac = fractions.keys.map(&:to_r)    # array of only fractions. to_r reduces fractions to simplest terms!
product = frac.inject(:*).to_r
denom = product.to_s.split('/')[-1]

p "Product of #{frac} = #{product}. Denominator = #{denom}. Took #{Time.now - start} secs."

=begin
  
{"16/64"=>0.25, "19/95"=>0.2, "26/65"=>0.4, "49/98"=>0.5}
"Product of [(1/4), (1/5), (2/5), (1/2)] = 1/100. Denominator = 100. Took 0.014906 secs."

=end