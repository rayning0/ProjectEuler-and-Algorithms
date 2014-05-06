# http://projecteuler.net/problem=83
# Find the minimal path sum, in matrix.txt, containing an 80 x 80 matrix, from
# top left to bottom right, by moving 4 directions (left, right, up, and down).

# Dijkstra's algorithm with priority queue
class PathSum
  INPUT_FILE = './081_matrix.txt'
  ROWS, COLS = 80, 80
  INFINITY = (2 ** (0.size * 8 - 2) - 1)  # max Fixnum integer value

  attr_accessor :matrix, :input, :start, :finish, :dist, :pqueue

  def initialize(start = [0, 0], finish = [ROWS - 1, COLS - 1])
    @start, @finish = start, finish
    @input = IO.readlines(INPUT_FILE).map(&:chomp) # reads file as array

    @matrix = Array.new(ROWS) do |row|
                Array.new(COLS) do |col|
                  input[row].split(',').map(&:to_i)[col]
                end
              end
    setup
  end

  def setup
    @dist = Array.new(ROWS) { |row| Array.new(COLS) { |col| INFINITY } }

    # dist = min distance to that point, that we know so far
    @dist[start[0]][start[1]] = matrix[start[0]][start[1]]
    @pqueue = { [start[0], start[1]] => matrix[start[0]][start[1]] }  # priority queue
  end

  # Takes closest node (lowest total distance) first.
  def dequeue
    minvalue = pqueue.values.min
    minkey = pqueue.key(minvalue)
    @pqueue.delete(minkey)
    { minkey => minvalue }
  end

  def min_path
    t = Time.now
    while pqueue
      node = dequeue
      row, col = node.keys.first[0], node.keys.first[1]

      if [row, col] == [finish[0], finish[1]]   # we're done!
        puts "Time: #{Time.now - t} secs"
        path = print_path(row, col)
        min_dist = path.inject(0) { |length, n| length + matrix[n[0]][n[1]] }
        break
      end

      uprow = [row - 1, col] if row - 1 >= 0
      downrow = [row + 1, col] if row + 1 <= finish[0]
      leftcol = [row, col - 1] if col - 1 >= 0
      rightcol = [row, col + 1] if col + 1 <= finish[1]

      # Go through each adjacent node
      [uprow, downrow, leftcol, rightcol].each do |n|
        next if n.nil?
        alt_distance = dist[row][col] + matrix[n[0]][n[1]]

        # if total dist to each adj node < min dist to there now, replace min dist at node
        if alt_distance < dist[n[0]][n[1]]
          dist[n[0]][n[1]] = alt_distance
          # Put each adjacent node on priority queue
          pqueue[n] = alt_distance
        end
      end
    end

    puts "\nSmallest Path Distance: #{min_dist}"
    puts "Shortest Path: #{path}"
  end

  def dist_4_ways(row, col)
    return INFINITY unless row.between?(start[0], finish[0]) && col.between?(start[1], finish[1])
    dist[row][col]
  end

  def print_path(row, col)
    final_path = []
    # find path by going backwards, from finish point to start.
    # pick each node that has LOWER total distance, to left and up.
    until row == start[0] && col == start[1]
      final_path.unshift([row, col])

      up = dist_4_ways(row - 1, col)
      down = dist_4_ways(row + 1, col)
      left = dist_4_ways(row, col - 1)
      right = dist_4_ways(row, col + 1)

      # min total distance value, in UP, DOWN, LEFT, RIGHT directions
      min = [up, down, left, right].each_with_index.min.last
      case min
      when 0 then row -= 1
      when 1 then row += 1
      when 2 then col -= 1
      else col += 1
      end
    end
    final_path.unshift([row, col])
  end
end

PathSum.new.min_path
