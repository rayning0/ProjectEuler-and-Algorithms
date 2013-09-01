# http:#permute.tchs.info/01example.php

start = Time.now
a = [*0..3]

=begin
def QuickPerm(a)
  perms = []
  n = a.length
  p = [*0..n]   # p = index control array.p[n] > 0 controls iteration and the index boundary for i
  i, j = 0, 0   # Upper Index i, Lower Index j
  b = a.dup
  perms << b
  i = 1   # setup first swap points to be 1 and 0 respectively (i & j)

  while i < n
    p[i] -= 1          # decrease index "weight" for i by one
    i.even? ? j = 0 : j = p[i]   # If i is odd then j = p[i] otherwise j = 0
    a[i], a[j] = a[j], a[i]
    b = a.dup
    perms << b
    i = 1              # reset index i to 1 (assumed)

    while (p[i] == 0)     
       p[i] = i        # reset p[i] zero value
       i += 1          # set new index value for i (increase by one)
    end
  end

  perms
end

QuickPerm(a).map(&:join).sort
puts "It took #{Time.now - start} secs."  # It took 1 min for 10 digit number.
=end


# --------------------------------------
# http:#www.freewebs.com/permute/soda_submit.html  (SEPA algorithm)

def permute(str, len)

   key = len - 1
   newkey = len - 1

# The key value is the first value from the end which is smaller 
# than the value to its immediate right        

   while (key > 0) && (str[key] <= str[key-1])
      key -= 1
   end

   key -= 1

   # If key < 0 the data is in reverse sorted order, which is the last permutation. 

   return 0 if key < 0 

    #str[key+1] is greater than str[key] because of how key 
    # was found. If no other is greater, str[key+1] is used   

   newkey = len - 1
   while (newkey > key) && (str[newkey] <= str[key])
      newkey -= 1
   end

   str[key], str[newkey] = str[newkey], str[key]

   # variables len and key are used to walk through the tail,
   # exchanging pairs from both ends of the tail.  len and 
   # key are reused to save memory                           

   len -= 1
   key += 1

   # The tail must end in sorted order to produce the next permutation. 

   while len > key
      str[key], str[newkey] = str[newkey], str[key]
      key += 1
      len -= 1
   end

   return 1
end


