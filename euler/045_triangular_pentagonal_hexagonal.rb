# http://projecteuler.net/problem=45
# It can be verified that T285 = P165 = H143 = 40755.
# Find the next triangle number that is also pentagonal and hexagonal.

start = Time.now 
tnum = [*286..40_000].map{|t| t * (t + 1) / 2}
pnum = [*166..40_000].map{|p| p * (3 * p - 1) / 2}
hnum = [*144..40_000].map{|h| h * (2 * h - 1)}

tpintersect = tnum & pnum
phintersect = pnum & hnum

puts "#{tpintersect} in #{Time.now-start} secs." if tpintersect = phintersect

=begin
"[1533776805] in 0.126874 secs."

  Alternate answers:

It seemed superflous to have the triangle numbers since all hexagonal numbers are also triangle number.

H = h*(2h-1)
T = t*(t+1)/2
generating t by t=2h-1,

T = (2h-1)(2h-1+1)/2 = (2h-1)(2h)/2 = h(2h-1),
To make calculation faster I ingored triangle aspect.


You're absolutley right, but that is part of the process in solving these problems: stripping them down to the bare essentials.

To solve this problem I ran through the hexagon numbers and, rather than compare with a separate array/list of pentagon numbers, I used a test.

Given that P=n(3n-1)/2, we get the quadratic, 3n2-n-2P=0, and using the quadratic formula, n=(1+&#8730;(1+24P))/6 (only taking positive root). In other words, if the number being test, P, produces an integer in the formula, then it is a pentagon number.

This allows the problem to be solving in a few lines of code and in the fraction of a second. For example, using BASIC:

n=1
do
  n=n+1
  h=n*(2*n-1)
  k=(1+math.sqrt(1+24*h))/6
  if k=int(k) then msgbox(h)
loop
=end