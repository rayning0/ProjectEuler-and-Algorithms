email = IO.readlines(ARGV[0]).map(&:strip)
email.each do |e|
  if e =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
    puts 'true'
  else
    puts 'false'
  end
end