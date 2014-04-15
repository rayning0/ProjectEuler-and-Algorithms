# https://www.codeeval.com/open_challenges/89/

t = IO.readlines(ARGV[0])  

t.map!(&:chomp).map!(&:split)   

t.each do |a|
  a.map!(&:to_i)    
end

sum, sumup, sumdiag = 0, 0, 0

# Add upwards, from bottom to top of triangle. Dynamic programming.
(t.size - 1).downto(1).each do |row|    
  (0..row - 1).each do |col|
    sumup = t[row][col] + t[row - 1][col]        
    sumdiag = t[row][col + 1] + t[row - 1][col]   
    sumup > sumdiag ? t[row - 1][col] = sumup : t[row - 1][col] = sumdiag
  end
end

puts "#{t[0][0]}"