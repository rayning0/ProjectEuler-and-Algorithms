# Raymond Gan, rayning@yahoo.com
# https://www.codeeval.com/open_challenges/1/
# My Project Euler solutions on GitHub: 
# https://github.com/rayning0/ProjectEuler-and-Algorithms/tree/master/euler
# http://www.linkedin.com/pub/raymond-gan/1/801/ba/

File.open(ARGV[0]).each_line do |line|
  a, b, c = line.split.map(&:to_i)
  str = ''

  (1..c).each do |n|
    str += "F" if n % a == 0
    str += "B" if n % b == 0
    str += n.to_s if !(n % a == 0 || n % b == 0)
    str += " "
  end
  
  puts str.strip    
end


