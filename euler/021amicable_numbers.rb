# http://projecteuler.net/problem=21
# Amicable numbers

def factors(noriginal)              # gives n's factors
  factors = [1]          # We know 1 is always a factors. Don't include n.
  f = 2

  begin
    n = noriginal

    while f * f <= n         # Only check up to sqrt(n)
      if n % f == 0
        factors << f << n / f      
        n /= f
      else

        f += 1
        if noriginal % f == 0   # catches divisors you missed with n < noriginal
          factors << f << noriginal / f
        end
      end
    end  

    f += 1
  end until f * f > noriginal # Overall, only check up to sqrt(noriginal)

  factors.uniq.sort         # sort and remove duplicates
end

amicable = []

(1..9999).each do |n|
  s1 = factors(n).inject(:+)    # sum of all "proper divisors" (factors, excluding n)
  s2 = factors(s1).inject(:+)

  # s1 = sum of n's p. divisors. if n = sum of s1's p. divisors, they are "amicable #'s"
  if s2 == n  && s1 != s2   # they must both be DIFFERENT
    amicable << s1 + s2 
    puts "Sum = #{s1 + s2} ***** amicable: #{s2} and #{s1} *****"
  end

end

# remove duplicates from all answers, then take sum of all
puts "Sum of all amicable nums < 10000 = #{amicable.uniq.inject(:+)}"   
