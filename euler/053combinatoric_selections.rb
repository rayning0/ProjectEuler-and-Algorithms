# http://projecteuler.net/problem=53
# How many, not necessarily distinct, values of  nCr, for 1 ≤ n ≤ 100, are > 1 million?

def comb(n, r)
  # n(n - 1)(n - 2)...(r + 1) / (n - r)!
  answer = (r + 1..n).inject(:*) / (2..n - r).inject(:*)
end

r = 3
count = 0

(6..100).each do |n|
  while r < n - 1
    count += 1 if comb(n, r) > 1_000_000
    r += 1
  end
  r = 2
end

puts "# of nCr combos > 1 million = #{count}"