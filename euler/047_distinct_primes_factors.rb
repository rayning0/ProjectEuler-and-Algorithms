# http://projecteuler.net/problem=47
# Find the first 4 consecutive integers to have 4 distinct prime factors. What is the first of these numbers?

# Finds all prime factors (Problem #3)
def primefact(n)
  f = 2
  factors = []
  while f * f <= n    # only need to check up to sqrt(n)
    if n % f == 0
      factors << f
      n = n / f       # After you find a factor, only check quotient after that!
    else
      f += 1
    end
  end
  factors << n
  factors
end

i = 647
c = 0
previous = false    # did you previously get # with 4 distinct prime factors?

start = Time.now
while true
  if primefact(i).uniq.size == 4
    if previous == true
      c += 1
    else
      c = 1         # reset count, to ensure these are CONSECUTIVE #'s
    end

    previous = true

    if c == 4
      puts "#{i - 3} is 1st of 4 consecutive #'s with 4 distinct prime factors."
      puts "Took #{Time.now - start} secs."
      exit
    end
  else
    previous = false
  end
  i += 1
end