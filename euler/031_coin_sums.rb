=begin
http://projecteuler.net/problem=31

Dynamic programming solution is much better. Read it:
http://www.mathblog.dk/project-euler-31-combinations-english-currency-denominations/

In England the currency is made up of pound, £, and pence, p, and there are eight coins in general circulation:

1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).
It is possible to make £2 in the following way:

1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p
How many different ways can £2 be made using any number of coins?
=end

n = 200
v = [200, 100, 50, 20, 10, 5, 2, 1] 
c = []  # final array of all coin permutations that add up to n
d = []  # each different permutation
d7 = 0

dmax = [] # max each coin may loop up to

start = Time.now

(0..v.size - 1).each do |i|
  dmax[i] = n / v[i]
end

(0..dmax[0]).each do |d0|
  dval = n - d0 * v[0]
  break if dval < 0
  (0..dmax[1]).each do |d1|
    dval -= d1 * v[1]
    break if dval < 0
    (0..dmax[2]).each do |d2|
      dval -= d2 * v[2]
      break if dval < 0
      (0..dmax[3]).each do |d3|
        dval -= d3 * v[3]
        break if dval < 0
        (0..dmax[4]).each do |d4|
          dval -= d4 * v[4]
          break if dval < 0
          (0..dmax[5]).each do |d5|
            dval -= d5 * v[5]
            break if dval < 0
            (0..dmax[6]).each do |d6|
              dval -= d6 * v[6]
              break if dval < 0 
              d7 = dval / v[7]        
               
              c << [d0, d1, d2, d3, d4, d5, d6, d7] 
              #p [d0, d1, d2, d3, d4, d5, d6, d7] 
              dval += d6 * v[6]
            end
            dval = n - d0 * v[0] - d1 * v[1] - d2 * v[2] - d3 * v[3] - d4 * v[4]
          end
          dval = n - d0 * v[0] - d1 * v[1] - d2 * v[2] - d3 * v[3]
        end
        dval = n - d0 * v[0] - d1 * v[1] - d2 * v[2]
      end
      dval = n - d0 * v[0] - d1 * v[1]
    end
    dval = n - d0 * v[0]
  end
  dval = n
end

puts "For #{n}, we have #{c.size} ways to make it. They are:"
#p c
puts "It took #{Time.now - start} secs."

# "For 200, we have 73682 ways to make it. They are: (lists them all). It took 0.094477 secs."