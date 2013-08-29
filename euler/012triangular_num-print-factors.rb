# http://projecteuler.net/problem=12
# What is the first triangle number to have > 500 factors?

# Prints out all factors. Slow. Takes 11 seconds.

def factors(noriginal)              # gives n's factors
  factors = [1, noriginal]          # We know 1 and n are always factors
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

i = 2

while true
  triangle = i * (i + 1) / 2    # triangle number = 1 + 2 + 3 + ... + i
  fact = factors(triangle)
  puts "triangle: #{triangle}"
  print "#{fact}, size: #{fact.size}\n"
  
  if fact.size > 500
    puts "Triangle # with > 500 factors = #{triangle}"
    exit
  end
  i += 1
end
