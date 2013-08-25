puts "Enter an integer"
dec = gets.chomp.to_i

=begin
i = 2

while (dec % 2**i != dec) do 
	print "#{dec} mod 2^#{i} = " 
	puts dec % 2**i
	i += 1
end
=end

def dec2bin(number)
    number = Integer(number)
    if(number == 0) then 0 end
        
    ret_bin = ""
    while(number != 0)
    	
        ret_bin = String(number % 10) + ret_bin
        
        number = number / 10
        
    end
    puts ret_bin
end

dec2bin(dec)