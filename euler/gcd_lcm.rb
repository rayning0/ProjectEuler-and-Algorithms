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

# Least Common Multiple: LCM(a, b) = a * b / GCD(a, b)
def lcm(a, b)   
  a / gcd(a, b) * b
end

puts "Give me 2 non-zero numbers. I'll tell you GCD and LCM:"
print "Number 1: "
a = gets.chomp.to_i
print "Number 2: "
b = gets.chomp.to_i
puts "GCD: #{gcd(a, b)}. LCM: #{lcm(a, b)}."