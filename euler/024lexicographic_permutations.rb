# http://projecteuler.net/problem=24
# What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?

permutation = ''
c = 0

start = Time.now

(0..9).each do |i|
  (0..9).each do |j|
    next if j == i
    (0..9).each do |k|
      next if [i, j].include?(k)        # skip to next value if value already used
      (0..9).each do |l|
        next if [i, j, k].include?(l)
        (0..9).each do |m|
          next if [i, j, k, l].include?(m)
          (0..9).each do |n|
            next if [i, j, k, l, m].include?(n)
            (0..9).each do |o|
              next if [i, j, k, l, m, n].include?(o)
              (0..9).each do |p|
                next if [i, j, k, l, m, n, o].include?(p)
                (0..9).each do |q|
                  next if [i, j, k, l, m, n, o, p].include?(q)
                  (0..9).each do |r|
                    next if [i, j, k, l, m, n, o, p, q].include?(r)
                    
                    c += 1
                    if c == 1_000_000
                      permutation = [i, j, k, l, m, n, o, p, q, r].join    # makes 1 string
                      puts "1 millionth lexicographic permutation = #{permutation}"
                      puts "Total time: #{Time.now - start} seconds."
                      exit
                    end

                  end
                end
              end
            end
          end
        end  
      end
    end
  end
end


=begin

0123 
0132  
0213 
0231 
0312 
0321  
------- 
1023     
1032
1203
1230
1302
1320

2013
2031
2103
2130
2301
2310

3012
3021
3102
3120
3201
3210

=end
