=begin    http://projecteuler.net/problem=19

1 Jan 1900 was a Monday.

Thirty days has September,
April, June and November.
All the rest have thirty-one,
Saving February alone,
Which has twenty-eight, rain or shine.
And on leap years, twenty-nine.

A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

=end

require 'date'

DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
MONTHS = %w[January February March April May June July August September October November December]
MONTHDAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]   # Days in each month

# start values --------
year = 1901
dow = DAYS[2] # Day of week = Tuesday
day = 1       # Day of month
month = 0     # 0 = January, 1 = February, etc.

# end values ----------
endyear   = 2000
endday    = 31
endmonth  = 11

sundays = 0   # number of Sundays on 1st of month (where day = 1)

def leapyear?(y)
  return true if y % 400 == 0                     # a leap century
  return true if (y % 100 != 0) && (y % 4 == 0)   # normal leap year
  false
end

def nextmonthyear(m, d, y)    
  if leapyear?(y) && m == 1   # if it's Feb. in a leap year
    if d > 29
      d -= 29
      m = 2
      return m, d, y
    elsif d == 29       # not checking for this caused me to be short by 4!
      return m, d, y    # it added 1 extra day every Feb. 29!
    end
  end

  if d > MONTHDAYS[m]   # if days > # of days in that month,
    d -= MONTHDAYS[m]   # change d to days for next month
    m += 1              # increase month
    if m > 11           # if now December, 
      m = 0             # change to January
      y += 1            # increase year
    end
  end

  return m, d, y
end

while true
  print "#{MONTHS[month]} #{day}, #{year} is #{dow} "

  dater = Date.new(year, month+1, day)  # Ruby class to find day of the week, given a date
  print "**FALSE**" if Date::DAYNAMES[dater.wday] != dow  # Check your calcs match Ruby day of the week

  if day == 1 && dow == DAYS[0]
    sundays += 1
    puts "* Sundays: #{sundays}"
  else
    puts
  end

  if dow != DAYS[0]         # if it's not Sunday, force next loop to move to Sunday
    days_till_Sun = 7 - DAYS.index(dow)
    day += days_till_Sun    
    dow = DAYS[0]
  else
    day += 7
  end

  break if (year == endyear) && (month == endmonth) && (day >= endday)
  month, day, year = nextmonthyear(month, day, year)  # if we've moved to next month, adjust month/day
end 

puts "#{MONTHS[month]} #{day}, #{year} is #{dow} "
sundays += 1 if day == 1 && dow = DAYS[0]
puts "# of Sundays that fell on 1st of month = #{sundays}"
