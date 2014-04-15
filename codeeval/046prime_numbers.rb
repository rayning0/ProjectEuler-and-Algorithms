# Raymond Gan, rayning@yahoo.com
# My Project Euler solutions: 
# https://github.com/rayning0/ProjectEuler-and-Algorithms/tree/master/euler
# http://www.linkedin.com/pub/raymond-gan/1/801/ba/

# Sieve of Eratosthenes
def sieve(n)    
  s = 3.step(n, 2).to_a 
  s.each do |p|
    next if p.nil?       
    break if p * p > n   

    k, pval = 0, 0

    while pval < n
      pval = p * (p + k)  
      s[(pval - 3) / 2] = nil 
      k += 2  
    end

  end
  s.compact!  
  s.unshift(2).sort  
end

num = IO.readlines(ARGV[0]).map(&:strip)
num.each do |n|
  s = sieve(n.to_i)
  puts "#{s.to_s[1..-2].delete(' ')}"
end


