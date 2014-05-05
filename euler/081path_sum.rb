# http://projecteuler.net/problem=81
# Find the minimal path sum, in matrix.txt, containing a 80 by 80 matrix, from the top
# left to the bottom right by only moving right and down.

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
    @dist = Array.new(ROWS) { |row| Array.new(COLS) { |col| INFINITY } }

    # dist = min distance to that point, that we know so far
    @dist[start[0]][start[1]] = matrix[start[0]][start[1]]
    @pqueue = { [start[0], start[1]] => matrix[start[0]][start[1]] }  # priority queue
  end

  def min_path
    s = Time.now
    while pqueue
      # Dequeue. Takes closest node (lowest total distance) first.
      minvalue = pqueue.values.min
      minkey = pqueue.key(minvalue)
      pqueue.delete(minkey)
      current = { minkey => minvalue }

      if current.keys.first == [finish[0], finish[1]]
        puts "It took #{Time.now - s} secs."
        print_path
        break
      end
      row, col = current.keys.first[0], current.keys.first[1]

      downrow = [row + 1, col] if row + 1 <= finish[0]
      rightcol = [row, col + 1] if col + 1 <= finish[1]

      # Go through each adjacent node
      [downrow, rightcol].each do |node|
        alt_distance = dist[row][col] + matrix[node[0]][node[1]]

        # if total dist to each adj node < min dist to there now, replace min dist at node
        if alt_distance < dist[node[0]][node[1]]
          dist[node[0]][node[1]] = alt_distance
          # Put each adjacent node on priority queue
          pqueue[node] = alt_distance
        end
      end
    end

    puts "Min distance: #{dist[finish[0]][finish[1]]}"
  end

  def print_path
    row, col = finish[0], finish[1]
    final_path = []
    # find path by going backwards, from finish point to start.
    # pick each node that has LOWER total distance, to left and up.
    until row == start[0] && col == start[1]
      final_path.unshift([row, col])
      dist[row][col - 1] < dist[row - 1][col] ? col -= 1 : row -= 1
    end
    final_path.unshift([row, col])
    print "Final path: #{final_path}\n"
  end
end

PathSum.new.min_path
