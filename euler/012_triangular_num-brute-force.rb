def div(n)
  divisors = 0
  f = 1
  while f * f <= n
    divisors += 2 if n % f == 0   # add both factors
    f += 1
  end
  # reduce 1 for duplicate if n is perfect square
  divisors -= 1 if Math.sqrt(n) == Math.sqrt(n).to_i  
  divisors
end        

i = 2

while true
  triangle = i * (i + 1) / 2    # triangle number = 1 + 2 + 3 + ... + i
  if div(triangle) > 500
    puts "Triangle # with > 500 factors = #{triangle}"
    exit
  end
  i += 1
end