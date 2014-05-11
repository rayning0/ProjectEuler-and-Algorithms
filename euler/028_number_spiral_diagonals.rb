sum = 1
lcv = 1   # last corner value
ring = 1
while true
  sum += (lcv + 2 * ring) + (lcv + 2 * ring * 2) + (lcv + 2 * ring * 3) + (lcv + 2 * ring * 4)
  break if 2 * ring + 1 == 1001   # 2 * ring + 1 = side length of each ring
  lcv += 8 * ring   # last corner value of ring, before going to next ring
  ring += 1
end

puts "Sum of diagonal #'s for 1001 x 1001 spiral = #{sum}"

=begin

Analyzing it mathematically:

Ring    Side length   Increment for corners Increment to next ring  Total digits for Ring
1       3             2                     4                       8
2       5             4                     6                       16
3       7             6                     8                       24

n       2n+1          2n                    2n+2                    8n

Ring    Corners 
1       3,5,7,9
2       13,17,21,25
3       31,37,43,49

1 + 4*2 + 4*4 + 4*6 + ...4* 2n = last corner 

since side length = 1001 
1001 = 2n+1 => n = 500

since n = 500, increment for corners = 2(500)  = 1000

last corner = 1 + 4*2 (1 + 2 + 3 + ... + n)

= 1 + 8 (1+2+3+...500)
= 1 + 8 (500) 501 /2 
= 1002001 = last corner

other 3 final corners, with difference of 2n = 1000, are

1001001
1000001
999001

1 + (1+2*1 + 1+2*2 + 1+2*3 + 1+2*4)
+   (last corner val+4(1) + lcv+4*2 + lcv+4*3 + lcv+4*4)
+   (lcv+6*1 + etc...)...

Ring n=500:  (lcv+2n*1 + lcv+2n*2 + lcv+2n*3 + lcv+2n*4)

After mathematical analysis, the fast code is:

sum = 1
lcv = 1       # last corner value
(1..500).each do |ring|
  sum += 4 * lcv + 20 * ring 
  lcv += 8 * ring
end

=end