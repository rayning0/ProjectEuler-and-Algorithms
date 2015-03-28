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

p merge_sort([11, 15, 4, 2, 19,13, 4, 10, 7, 19])