# Find Greatest Common Divisor (Euclid's Algorithm)
# http://people.cis.ksu.edu/~schmidt/301s12/Exercises/euclid_alg.html
# Based on Euclid's insight that GCD(x, y) = GCD(x-y, y)

def gcd(k, m)
  k, m = m, k if k < m   # swap k and m so k is greater number

  while m != 0
    r = k % m
    k = m
    m = r 
  end 

  k
end

# recursive way

def gcd_recursive(k, m)
  return k if m == 0
  r = k % m
  gcd_recursive(m, r)
end

# Least Common Multiple: LCM(a, b) = a * b / GCD(a, b)
def lcm(a, b)   
  a / gcd(a, b) * b
end

puts "Give me 2 non-zero numbers. I'll tell you GCD and LCM:"
print "Number 1: "
a = gets.chomp.to_i
print "Number 2: "
b = gets.chomp.to_i
puts "LCM: #{lcm(a, b)}."

start = Time.now
puts "GCD (iterative way): #{gcd(a, b)}. Took #{Time.now - start} secs."
start = Time.now
puts "GCD (recursive way): #{gcd_recursive(a, b)}. Took #{Time.now - start} secs."