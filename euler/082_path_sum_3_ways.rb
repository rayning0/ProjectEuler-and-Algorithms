# http://projecteuler.net/problem=82
# Find the minimal path sum, in matrix.txt, containing a 80 by 80 matrix, from the
# left column to right column by moving 3 ways (up, down, and right).

# Dijkstra's algorithm with priority queue
class PathSum
  INPUT_FILE = './081_matrix.txt'
  ROWS, COLS = 80, 80
  INFINITY = (2 ** (0.size * 8 - 2) - 1)  # max Fixnum integer value

  attr_accessor :matrix, :input, :start, :finish, :dist, :pqueue

  def initialize(startcol = 0, finishcol = COLS - 1)
    @start, @finish = [0, startcol], [0, finishcol]
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
    min_dist = INFINITY
    min_path = []
    ROWS.times do |startrow|
      @start[0] = startrow
      setup
      while pqueue
        node = dequeue
        row, col = node.keys.first[0], node.keys.first[1]

        if col == finish[1]   # we're done!
          path = print_path(row, col)
          dist_across = path.inject(0) { |length, n| length + matrix[n[0]][n[1]] }
          puts "Distance: #{dist_across}"
          if dist_across < min_dist
            min_dist = dist_across
            min_path = path
          end
          break
        end

        uprow = [row - 1, col] if row - 1 >= 0
        downrow = [row + 1, col] if row + 1 <= ROWS - 1
        rightcol = [row, col + 1] if col + 1 <= finish[1]

        # Go through each adjacent node
        [uprow, downrow, rightcol].each do |n|
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
    end

    puts "\nSmallest Path Distance: #{min_dist}"
    puts "Shortest Path: #{min_path}"
  end

  def dist_3_ways(row, col)
    return INFINITY unless row.between?(0, ROWS - 1) && col.between?(start[1], finish[1])
    dist[row][col]
  end

  def print_path(row, col)
    final_path = []
    # find path by going backwards, from finish point to start.
    # pick each node that has LOWER total distance, to left and up.
    until row == start[0] && col == start[1]
      final_path.unshift([row, col])

      left = dist_3_ways(row, col - 1)
      up = dist_3_ways(row - 1, col)
      down = dist_3_ways(row + 1, col)

      # min total distance value, in LEFT, UP, and DOWN directions
      min = [left, up, down].each_with_index.min.last
      case min
      when 0 then col -= 1
      when 1 then row -= 1
      else row += 1
      end
    end
    final_path.unshift([row, col])
    print "Path: #{final_path} "
    final_path
  end
end

PathSum.new.min_path
