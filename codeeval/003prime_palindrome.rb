def is_prime?(n)        
  return true if n.between?(2, 3)
  return false if (n.even? || n % 3 == 0 || n <= 1)   

  j, w = 5, 2

  while j * j <= n                
    return false if n % j == 0
    j += w                        
    w = 6 - w                     
  end           

  true
end

997.step(2, -2) do |p|
  if is_prime?(p) && p.to_s == p.to_s.reverse
    puts p
    break
  end
end