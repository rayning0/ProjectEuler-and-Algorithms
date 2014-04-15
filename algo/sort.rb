# Raymond Gan - My own Ruby versions of different sorting algorithms. I read descriptions in Wikipedia and coded these independently
# http://en.wikipedia.org/wiki/Sorting_algorithm
# and http://www.sorting-algorithms.com/ are good sorting algorithm references

require 'benchmark'

# Keeps comparing/swapping adjacent elements from left to right, repeatedly
def bubble_sort(list)
  loop do
    swapped = false

    (list.size - 1).times do |i|
      if list[i] > list[i+1]    # if current > next
        list[i], list[i+1] = list[i+1], list[i]   # swap current and next values
        swapped = true
      end
    end

    # if swap happened, return to start and scans whole list again from left to right
    # else we're done
    break unless swapped  
  end
  list
end

# Starts from 2nd value and moves left, comparing it until it's < anything to the right. Repeats.
def insertion_sort(list)
  for i in 1..list.size - 1
    j = i - 1
    while j >=0 and list[j+1] < list[j]   # if current < previous
      list[j], list[j+1] = list[j+1], list[j]   # swap previous and current values. faster.

#     list[j+1] = list[j]   --- typical book way. slower.
      j -= 1
    end
#     list[j+1] = current   --- typical book way. slower.
  end
  list
end

# usually the slowest sort of all. does only n swaps. useful if swapping is expensive.
def selection_sort(list)
  (list.size - 1).times do |i|
    min = i     # starting min value
    for j in i+1..list.size - 1   # searches all values to right to find min
      min = j if list[j] < list[min]  # resets min
    end
    list[min], list[i] = list[i], list[min] # swaps min val with past min val, ignoring already sorted part
  end
  list
end

# same as insertion sort, but with a gap, which keeps getting cut in half
def shell_sort(list)
  gap = list.size / 2
  while gap > 0 do
    for i in gap..list.size - 1  
      j = i         
      while j >= gap and list[j] < list[j-gap]    # if current < previous. previous = gap values to the left
        list[j], list[j-gap] = list[j-gap], list[j] # swap current and previous
        j -= gap    # keep swapping current and previous until previous > current
      end
    end
    gap = gap / 2
  end
  list
end

# divide-and-conquer. recursive. 
# divides whole array into 1-element arrays, then merges them back (while sorting), 
# doubling size each time
def merge_sort(list)
  return list if list.length <= 1

  middle = list.length / 2
  left = list[0..middle - 1]
  right = list[middle..-1]
  left = merge_sort(left)
  right = merge_sort(right)
  merge(left, right)
end
 
def merge(left, right)
  merged = []
 
  while !left.empty? && !right.empty?
    if left.first <= right.first
      merged << left.shift
    else
      merged << right.shift
    end
  end

  # if right empty, add remaining left part to merged
  unless left.empty?
    merged += left
  end

  # if left empty, add remaining right part to merged
  unless right.empty?
    merged += right
  end
  merged
end

=begin   ---- shell sort ----
a = [15, 8, 4, 12, 4, 3, 10, 6, 2, 0]
gap = 5
i = 5
j = 5. new list = [3, 8, 4, 12, 4, 15, 10, 6, 2, 0]
i = 6
i = 7
i = 8
j = 8. new list = [3, 8, 4, 2, 4, 15, 10, 6, 12, 0]
i = 9
j = 9. new list = [3, 8, 4, 2, 0, 15, 10, 6, 12, 4]
gap = 2
i = 2
i = 3
j = 3. new list = [3, 2, 4, 8, 0, 15, 10, 6, 12, 4]
i = 4
j = 4. new list = [3, 2, 0, 8, 4, 15, 10, 6, 12, 4]
j = 2. new list = [0, 2, 3, 8, 4, 15, 10, 6, 12, 4]
i = 5
i = 6
i = 7
j = 7. new list = [0, 2, 3, 8, 4, 6, 10, 15, 12, 4]
j = 5. new list = [0, 2, 3, 6, 4, 8, 10, 15, 12, 4]
i = 8
i = 9
j = 9. new list = [0, 2, 3, 6, 4, 8, 10, 4, 12, 15]
j = 7. new list = [0, 2, 3, 6, 4, 4, 10, 8, 12, 15]
j = 5. new list = [0, 2, 3, 4, 4, 6, 10, 8, 12, 15]
gap = 1
i = 1
i = 2
i = 3
i = 4
i = 5
i = 6
i = 7
j = 7. new list = [0, 2, 3, 4, 4, 6, 8, 10, 12, 15]
i = 8
i = 9
Sorted 10 values. Your sort matches result of Ruby 'sort' method.
s = [0, 2, 3, 4, 4, 6, 8, 10, 12, 15]
=end

#puts "Enter list of numbers to sort, separated by spaces:"
#array = gets.chomp.split.map {|v| v.to_i } # makes array of integers

n = 10000
a = Array.new(n) { rand(n) }  # make array of random numbers

sorted = merge_sort(a)
if sorted == a.sort
  puts "Sorted #{n} values. Your sort matches result of Ruby 'sort' method."
#  puts "s = #{sorted}"
else
  puts "Sort is wrong. Check your code."
end

Benchmark.bm(7) do |x|
  x.report("shell  sort: ") {shell_sort(a)}
  x.report("bubble sort: ") {bubble_sort(a)}
  x.report("insert sort: ") {insertion_sort(a)}
  x.report("select sort: ") {selection_sort(a)}
  x.report("merge  sort: ") {merge_sort(a)}
  x.report("ruby   sort: ") {a.sort}
end

=begin
Ruby 2.0.0
Comparing speed of all sorting techniques. Output. The last column tells # of seconds. Select sort is the slowest.

Sorted 10000 values. Your sort matches result of Ruby 'sort' method.
              user     system      total        real
shell  sort:   0.120000   0.000000   0.120000 (  0.128072)
bubble sort:   0.000000   0.000000   0.000000 (  0.001883)
insert sort:   0.000000   0.000000   0.000000 (  0.002288)
select sort:  10.300000   0.080000  10.380000 ( 11.138458)
merge  sort:   0.040000   0.000000   0.040000 (  0.045420)
ruby   sort:   0.000000   0.000000   0.000000 (  0.000173)

=end
