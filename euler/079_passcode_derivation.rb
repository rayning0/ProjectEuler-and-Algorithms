=begin
http://projecteuler.net/problem=79

A common security method used for online banking is to ask the user for three random characters from a passcode. For example, if the passcode was 531278, they may ask for the 2nd, 3rd, and 5th characters; the expected reply would be: 317.

The text file, keylog.txt, contains fifty successful login attempts. Given that the three characters are always asked for in order, analyse the file so as to determine the shortest possible secret passcode of unknown length.
=end

start = Time.now

# read file into array. strip out '\n' characters after number.
passcode = IO.readlines("keylog.txt").map(&:strip)    
code, tcommon, notcommon = [], [], []
tcommon = [-1, -1, -1]   # array to track the location of the digits code has in common with each t

passcode.each do |n|
  t = n.split('')     # Ex: ['1','2','3']
  puts "t = #{t}, code = #{code}"
  if (code & t).empty?  # if t has no digits in common with code (intersection)
    code = code | t     # append all t to code (union)
    next
  end

  code.each do |c|    # tracks location of digits code and t have in common
    if t.include?(c)
      tcommon[t.index(c)] = code.index(c)  # common[1] = 3 means the digit in t[1] is at code[3]
    end
  end

  print "tcommon = #{tcommon}, "

  # array of all indices of tcommon NOT in common with code. Intersection.
  notcommon = tcommon.each_index.select{|i| tcommon[i] == -1}   
  puts "notcommon = #{notcommon}"

  if notcommon.size == 2   # t has only 1 digit in common with code
    code = code | t       # only append 2 digits who are NOT in common. Union.
    tcommon = [-1, -1, -1]
    next
  end

  if notcommon.size == 1   # t has 2 digits in common with code
    case notcommon[0]     
    when 0                # tcommon[0] = -1
      if tcommon[1] > tcommon[2]    # if order of these digits in code is reversed
        # swap tcommon[1] and tcommon[2] digits in code
        code[tcommon[1]], code[tcommon[2]] =  code[tcommon[2]], code[tcommon[1]] 
      end
      # at tcommon[1] position in code, INSERT number tcommon[0]. Preserve correct order.
      code.insert(tcommon[1], t[0])  
    when 1                # tcommon[1] = -1
      if tcommon[0] > tcommon[2]
        code[tcommon[0]], code[tcommon[2]] =  code[tcommon[2]], code[tcommon[0]] 
      end
      code.insert(tcommon[2], t[1])
    when 2                # tcommon[2] = -1
      if tcommon[0] > tcommon[1]
        code[tcommon[0]], code[tcommon[1]] =  code[tcommon[1]], code[tcommon[0]] 
      end
      code << t[2]
    end

  end

  if notcommon.size == 0   # t has ALL digits in common with code
    if tcommon[0] < tcommon[1] && tcommon[1] < tcommon[2]  # all ok. don't change code.
      tcommon = [-1, -1, -1]
      next
    elsif tcommon[0] > tcommon[1] && tcommon[0] < tcommon[2]
      code[tcommon[0]], code[tcommon[1]] =  code[tcommon[1]], code[tcommon[0]] 
    elsif tcommon[1] > tcommon[2] && tcommon[0] < tcommon[2]
      code[tcommon[1]], code[tcommon[2]] =  code[tcommon[2]], code[tcommon[1]] 
    else
      code[tcommon[0]], code[tcommon[2]] =  code[tcommon[2]], code[tcommon[0]] 
    end
  end

  tcommon = [-1, -1, -1]  # reset
end

puts "Shortest secret passcode = #{code.join}. Took #{Time.now - start} secs."

=begin 

t = ["3", "1", "9"], code = []
t = ["6", "8", "0"], code = ["3", "1", "9"]
t = ["1", "8", "0"], code = ["3", "1", "9", "6", "8", "0"]
tcommon = [1, 4, 5], notcommon = []
t = ["6", "9", "0"], code = ["3", "1", "9", "6", "8", "0"]
tcommon = [3, 2, 5], notcommon = []
t = ["1", "2", "9"], code = ["3", "1", "6", "9", "8", "0"]
tcommon = [1, -1, 3], notcommon = [1]
t = ["6", "2", "0"], code = ["3", "1", "6", "2", "9", "8", "0"]
tcommon = [2, 3, 6], notcommon = []
t = ["7", "6", "2"], code = ["3", "1", "6", "2", "9", "8", "0"]
tcommon = [-1, 2, 3], notcommon = [0]
t = ["6", "8", "9"], code = ["3", "1", "7", "6", "2", "9", "8", "0"]
tcommon = [3, 6, 5], notcommon = []
t = ["7", "6", "2"], code = ["3", "1", "7", "6", "2", "8", "9", "0"]
tcommon = [2, 3, 4], notcommon = []
t = ["3", "1", "8"], code = ["3", "1", "7", "6", "2", "8", "9", "0"]
tcommon = [0, 1, 5], notcommon = []
t = ["3", "6", "8"], code = ["3", "1", "7", "6", "2", "8", "9", "0"]
tcommon = [0, 3, 5], notcommon = []
t = ["7", "1", "0"], code = ["3", "1", "7", "6", "2", "8", "9", "0"]
tcommon = [2, 1, 7], notcommon = []
t = ["7", "2", "0"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [1, 4, 7], notcommon = []
t = ["7", "1", "0"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [1, 2, 7], notcommon = []
t = ["6", "2", "9"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [3, 4, 6], notcommon = []
t = ["1", "6", "8"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [2, 3, 5], notcommon = []
t = ["1", "6", "0"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [2, 3, 7], notcommon = []
t = ["6", "8", "9"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [3, 5, 6], notcommon = []
t = ["7", "1", "6"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [1, 2, 3], notcommon = []
t = ["7", "3", "1"], code = ["3", "7", "1", "6", "2", "8", "9", "0"]
tcommon = [1, 0, 2], notcommon = []
t = ["7", "3", "6"], code = ["7", "3", "1", "6", "2", "8", "9", "0"]
tcommon = [0, 1, 3], notcommon = []
Shortest secret passcode = 73162890 Took 0.004095 secs.
-----------------------------------------
Lots of great strategies here. I like the heuristics and statistical ideas! Anyway I used a LOT of if statements. My code ran in 4 ms.

For each new 3-digit data, I used an array, tcommon, to track the positions that its digits had in common with the passcode I was building. The elements of tcommon were positions in passcode that had values the same as the new 3-digit value. The key point: if the indexes in tcommon were in numerical order, passcode was ok and didn't need change. If parts were out of order, I swapped all the corresponding elements of passcode to match the order in the 3-digit data.

If it had nothing in common, I added the 3-digit data to the end of passcode.

If it had 1 digit in common, I used a set union and added the 2 non-common digits to the end of passcode.

If it had 2 digits in common, I checked the numerical order of the passcode indexes in tcommon. If out of order, I swapped them until they were in numerical order.

If it had all 3 digits in common, again I checked numerical order of passcode indexes in tcommon. Swapped again if needed.

Took many if statements. Looks ugly. But it worked in 4 ms and got the answer with just half the data.

=end