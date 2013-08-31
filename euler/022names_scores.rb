# http://projecteuler.net/problem=22
# What is the total of all the name scores in the file?

require 'csv'

names = CSV.read("names.txt").shift     # Remember this! Reads CSV file into array!

names.sort!   # sort names in alphabetical order

nscore = 0
i = 1         # first name on list is position 1

names.each do |name|
  nsum = 0

  name.split('').each do |letter|
    nsum += letter.ord - 64   # ord gives ASCII value of character, minus 64 gives 1 for "A"
  end

  nscore += nsum * i  # name score = alphabetical value of each name * position on list
  i += 1
end

puts "Total name scores for file = #{nscore}"