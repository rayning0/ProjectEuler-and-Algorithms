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

=begin  [This algorithm, step by step, for number 36]

Answer = [1, 2, 3, 4, 6, 9, 12, 18, 36]

n = 36
f = 2

36 % 2 = 0    is f*f <= n?
=> 2, 36/2 = 18  
n = 18
18 % 2 = 0    is f*f <= n?
=> 2, 18/2 = 9  
n = 9
9 % 2 != 0 F   or is f*f <= n? 

f: 2 += 1 = 3
noriginal % f = 0?  (36 % 3) if n < noriginal
=> 3, 36/3 = 12

9 % 3 = 0   is f*f <= n?
=> 3, 9/3 = 3
n = 3
3 % 2       is f*f <= n? F

f: 3 += 1 = 4

n = noriginal = 36
36 % 4 = 0  is f*f <= n?
=> 4, 36/4 = 9
n = 9
9 % 4       is f*f <= n? F

f: 4 += 1 = 5

n = original 36
36 % 5 !=0 F or is f*f <= n?

f: 5 += 1 = 6

36 % 6 = 0    is f*f <= n?
=> 6, 36/6 = 6
n = 6
6 % 6 = 0   or  is f*f <= n? F

f: 6 += 1 = 7
n = original 36
is f * f <= noriginal? F

STOP

=end
