def ugly?(n)
  for d in [2, 3, 5, 7]
    return true if n % d == 0
  end
  false
end

File.open(ARGV[0]).each_line do |n|
  c = 0
  n = n.strip.split('')
  len = n.size
  if len == 1
    if ugly?(n[0].to_i) 
      puts 1 
    else 
      puts 0
    end 
    next
  end

  expr, expr2 = [], []
  sign = ["+", "-", ""]
  # makes nested array of all permutations of sign, for len - 1 spots
  s = sign.repeated_permutation(len - 1).to_a   

  (0..(3**(len - 1) - 1)).each do |e|
    expr[e] = n[0]
    
    (1..len - 1).each do |i|
      # n[0] + s[0][0] + n[1] + s[0][1] + n[2] + ...
      expr[e] += s[e][i - 1] + n[i]
    end

    if expr[e].split(/[+-]/).any?{|x| x =~ /^0+/}            # if expr has leading 0's in any term
      e2 = expr[e].split(/[+-]/).map{|x| x = Integer(x, 10).to_s} # Turns everything into base 10 number
      expr2[e] = e2[0]
      badjust = 0

      (1..e2.size - 1).each do |i|
        badjust += 1 if s[e][i - 1] == '' 
        expr2[e] += s[e][i - 1 + badjust] + e2[i]  # adjusts symbol location by # of blanks.
      end

    else 
      expr2[e] = expr[e]
    end

    c += 1 if ugly?(eval(expr2[e]))
  end

  puts c
end