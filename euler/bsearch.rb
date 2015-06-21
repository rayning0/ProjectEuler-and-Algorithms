# Binary search. Input array must be sorted in ascending order.
require 'benchmark'

class BSearch
  def self.recursive(arr, val, low = 0, high = arr.length - 1)
    return nil if low > high
    mid = (low + high) / 2
    case
      when arr[mid] > val then recursive(arr, val, low, mid - 1)
      when arr[mid] < val then recursive(arr, val, mid + 1, high)
      else return mid
    end
  end

  def self.iterative(arr, val)
    low, high = 0, arr.length - 1
    while low <= high
      mid = (low + high) / 2
      case
        when arr[mid] > val then high = mid - 1
        when arr[mid] < val then low = mid + 1
        else return mid
      end
    end
    nil
  end

  def self.bsearch(arr, val)
    arr.bsearch { |v| val - v } # Ruby's own bsearch method
  end
end

# Benchmark.bm do |run|
#   run.report { BSearch.recursive([1,5,10,19,24], 24) }
#   run.report { BSearch.iterative([1,5,10,19,24], 24) }
#   run.report { BSearch.bsearch([1,5,10,19,24], 24) }
# end

# Output:
#        user     system      total        real
#    0.000000   0.000000   0.000000 (  0.000012)
#    0.000000   0.000000   0.000000 (  0.000009)
#    0.000000   0.000000   0.000000 (  0.000020)

# Iterative binary search is faster than both recursive
# and Ruby's own bsearch method!
