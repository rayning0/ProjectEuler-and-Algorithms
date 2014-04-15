# Raymond Gan, rayning@yahoo.com
# https://www.codeeval.com/open_challenges/4/
# My Project Euler solutions on GitHub: 
# https://github.com/rayning0/ProjectEuler-and-Algorithms/tree/master/euler
# http://www.linkedin.com/pub/raymond-gan/1/801/ba/

# Sieve of Eratosthenes
def sieve(n)    # quickly makes array of all primes from 2 to n
  s = 3.step(n, 2).to_a # make array of odd integers from 3 to n. Skip evens. 
  s.each do |p|
    next if p.nil?       # go to next element if p has been marked empty
    break if p * p > n   # p only needs to go up to sqrt(n)

    k, pval = 0, 0

    while pval < n
      pval = p * (p + k)  # jump forward 2p at a time: p*p, p*p + 2p, p*p + 4p, etc.

      # Set all those multiples to nil. i = (pval - 3)/2 translates pvals to index i

      s[(pval - 3) / 2] = nil 
      k += 2  
    end

  end
  s.compact!    # removes all nil elements from array
  s.unshift(2).sort  # adds 2 as 1st element
end

s = sieve(8000)

puts s[0..999].inject(:+)
