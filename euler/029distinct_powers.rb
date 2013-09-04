# http://projecteuler.net/problem=29
# How many distinct terms are in the sequence a^b for 2 ≤ a ≤ 100 and 2 ≤ b ≤ 100?

answer = []
(2..100).each do |a|
  (2..100).each do |b|
    answer << a**b
  end
end

puts "# of distinct a^b terms = #{answer.uniq.size}"
