# By Raymond Gan
# See "rspec_screen_output.txt" for RSpec results

class Matrix
  # add missing method to Ruby Matrix class
  def []=(row, column, value)
    @rows[row][column] = value
  end
end

class Graph
  attr_reader :graphfile, :graphtype, :num_vertices
  attr_accessor :adj_lists, :a_matrix, :cadj_lists, :ca_matrix

  def initialize(filename)
    @adj_lists, @cadj_lists = [], []
    @graphfile = read_file(filename)
    @graphtype = graphfile[0]
    @num_vertices = graphfile[1].to_i
    @adj_lists = read_vertices
    @adj_lists = read_edges(0, 1)
    @a_matrix = adj_matrix
  end

  def read_file(filename)
    IO.readlines(filename).map(&:chomp) # reads graph file as array
  end

  # creates adjacency matrix
  def adj_matrix
    m = Matrix.zero(num_vertices) # creates zero matrix (num_vertices x num_vertices)
    graphfile[num_vertices + 2..-1].each do |edge|
      vertex1name, vertex2name = edge.split[0], edge.split[1]
      vnum1 = vertex_num_for(vertex1name)
      vnum2 = vertex_num_for(vertex2name)
      m[vnum1, vnum2] = 1
    end
    m
  end

  # helps create adjacency list---array of Vertex objects
  def read_vertices
    (0..num_vertices - 1).map do |v|
      adj_lists[v] = Vertex.new(graphfile[v + 2], nil)
    end
  end

  # returns final version of adjacency lists
  def read_edges(start, finish)
    graphfile[num_vertices + 2..-1].each do |edge|
      vertex1name, vertex2name = edge.split[start], edge.split[finish]
      weight = edge.split[2].to_i

      vnum1 = vertex_num_for(vertex1name)
      vnum2 = vertex_num_for(vertex2name)

      # add vnum2 to front of vnum1's adjacency list
      adj_lists[vnum1].adj_list = Neighbor.new(vnum2, adj_lists[vnum1].adj_list, weight, vertex2name)
      if (graphtype == "undirected")
        # for undirected graph, add vnum1 to front of vnum2's adjacency list
        adj_lists[vnum2].adj_list = Neighbor.new(vnum1, adj_lists[vnum2].adj_list, weight, vertex1name)
      end
    end
    adj_lists
  end

  # helps create adjacency list. given vertex name, return vertex number.
  def vertex_num_for(name)
    adj_lists.each_with_index do |vertex, index|
      return index if vertex.name == name
    end
  end

  # make copy of graph (used when we do reverse_graph)
  def copy_graph
    @cadj_lists = adj_lists.clone
    @ca_matrix = a_matrix.clone
  end

  # returns array of adjacent vertices pointing OUT from vertex
  def adj_vertices(vertex, a_lists)
    adj = []
    a_lists.each do |v|
      if v.name == vertex
        neighbor = v.adj_list
        while !neighbor.nil?
          adj << neighbor.name
          neighbor = neighbor.next
        end
        break
      end
    end
    adj
  end

  # returns array of adjacent vertices pointing INTO vertex
  def inward_vertices(vertex, a_lists)
    inward = []
    adj_lists.each do |v|
      adj_vertices(v.name, a_lists).each do |adj_v|
        if adj_v == vertex
          inward << v.name
          break
        end
      end
    end
    inward
  end

  # prints adjacency list version of graph
  def print_graph
    puts
    adj_lists.each do |vertex|
      print "#{vertex.name}"
      neighbor = vertex.adj_list
      while !neighbor.nil?
        print " --> #{neighbor.name} (#{neighbor.weight})"
        neighbor = neighbor.next
      end
      puts
    end
  end

  # returns summed distance between array of vertices
  def dist(*vertex_names)
    total, total_old = 0, 0
    vertex_names[0..-2].each_with_index do |name, index|
      vertex_start = adj_lists[vertex_num_for(name)]
      neighbor = vertex_start.adj_list

      while !neighbor.nil?
        if neighbor.name == vertex_names[index + 1]
          total += neighbor.weight
          break
        else
          neighbor = neighbor.next
        end
      end

      return "NO SUCH ROUTE" if total == total_old
      total_old = total
    end
    total
  end

  # returns total distance of a path of vertices
  def path_length(path)
    return 0 if path.size <= 1
    (0..path.size - 2).map {|i| dist(path[i], path[i + 1])}.inject(&:+)
  end

  # number of paths between 2 vertices, for given range of stops,
  # using adjacency matrix A.
  # (A^n)[i, j] = # of paths between vertices i and j with n stops

  # Reference: https://www.math.ucdavis.edu/~daddel/linear_algebra_appl/Applications/GraphTheory/GraphTheory_9_17/node9.html
  def maxtrips(start, finish, stops1, stops2)
    vnum1 = vertex_num_for(start)
    vnum2 = vertex_num_for(finish)
    (stops1..stops2).map {|n| (a_matrix**n)[vnum1, vnum2]}.inject(&:+)
  end

  # returns shortest distance between 2 vertices, using Dijkstra's algorithm with priority queue
  def shortest_length(start, finish)
    infinity = (2**(0.size * 8 - 2) - 1)  # max Fixnum integer value
    distances = {}  # smallest distance from starting vertex to this one
    previous = {}
    cyclic = start == finish # true if starting vertex = ending vertex
    loops = 0       # useful for cyclic path
    vertex_pq = PriorityQueue.new

    adj_lists.each do |vertex|
      vname = vertex.name
      if vname == start
        distances[vname] = 0
        vertex_pq.enq(vname, 0)
      else
        distances[vname] = infinity
        vertex_pq.enq(vname, infinity)
      end
      previous[vname] = nil
    end

    while vertex_pq
      loops += 1
      # if cyclic, pretend starting vertex is unvisited. put it back in queue.
      if cyclic && loops == 2
        vertex_pq.enq(start, infinity)
        distances[start] = infinity
      end
      # vertex currently being checked. picks closest one first.
      current = vertex_pq.deq
      vname = current.keys.first

      # if we've arrived at final vertex, return shortest distance
      # if cyclic, skip this code during first loop
      if vname == finish && loops > 1
        shortest_path = []
        vname2 = vname
        while previous[vname2]
          shortest_path << vname2
          vname2 = previous[vname2]
          previous[start] = nil if cyclic # pretend starting vertex is unvisited
        end
        shortest_path = [start] + shortest_path.reverse
        print "Shortest path: #{shortest_path}, Length = #{path_length(shortest_path)}\n"
        return distances[finish]
      end

      # leave if we never get to final vertex
      break if vname == nil || distances[vname] == infinity

      adj_vertices(vname, adj_lists).each do |vertex|
        alt_distance = distances[vname] + dist(vname, vertex)
        # if total distance to neighbor < last minimum total distance
        # to neighbor, replace it with this new distance
        if alt_distance < distances[vertex]
          distances[vertex] = alt_distance
          previous[vertex] = vname
          vertex_pq.enq(vertex, alt_distance)
        end
      end
    end

  end

  # finds shortest path between 2 vertices (fewest edges), using breadth-first search (BFS)
  def fewest_edges(start, finish)
    queue = [start]
    path, dequeue = [], []
    visited, distance, previous = {}, {}, {}
    infinity = (2**(0.size * 8 - 2) - 1)  # max Fixnum integer value
    adj_lists.each do |v|
      visited[v.name] = false
      distance[v.name] = infinity
      previous[v.name] = nil
    end
    distance[start] = 0
    cyclic = start == finish  # if start/end with same vertex
    visited[start] = true if !cyclic
    loops = 0

    while !queue.empty?
      loops += 1
      current = queue.shift # queue is FIFO
      dequeue << current    # array of dequeued vertices
      puts "\ncurrent = #{current}, queue = #{queue}"

      if current == finish
        break if !cyclic
        break if loops > 1 # if cyclic
      end

      adj_vertices(current, adj_lists).each do |adj_vertex|
        if !visited[adj_vertex]
          visited[adj_vertex] = true
          queue << adj_vertex
          distance[adj_vertex] = distance[current] + 1
          previous[adj_vertex] = current
          puts "adjacent vertex = #{adj_vertex}, queue = #{queue}"
          # print "visited = #{visited}\n"
          # print "distance = #{distance}\n"
        end
      end
    end
    print_graph
    print "Dequeued vertices: #{dequeue}\n"
    path = [finish]
    vname = finish
    while previous[vname]
      path << previous[vname]
      vname = previous[vname]
      previous[start] = nil if cyclic
    end
    path = path.reverse
    puts "\nShortest distance from #{start} to #{finish}: #{distance[finish]} edges."
    print "Path: #{path}\n\n"

    distance[finish]
  end

  # Tarjan's algorithm to find all strongly connected components (SCCs)
  def scc_tarjan
    index = 0 # numbers nodes consecutively in the order discovered
    stack, scc, vertices = [], [], []

    # create new Struct, if not already defined
    if Struct::const_defined?("TarjanVertex")
      Struct.const_get("TarjanVertex")
    else
      Struct.new("TarjanVertex", :name, :index, :lowlink)
    end

    adj_lists.each do |v|
      # -1 means vertex is unvisited
      vertex = Struct::TarjanVertex.new(v.name, -1, -1)
      vertices << vertex  # array of all TarjanVertex objects in graph
    end
    vertices.each do |vertex|
      tarjan_dfs(vertex, scc, stack, index, vertices) if vertex.index == -1
    end
    # return nested array of all SCCs in graph
    # NOTE: all SCCs are found in REVERSE topological order.
    # If we reverse nested array, we get topological sort of the SCCs!
    scc
  end

  def tarjan_dfs(parent, scc, stack, index, vertices)
    # Set depth index for vertex to smallest unused index
    parent.index = index
    # lowlink is roughly the smallest index of any node known to be reachable from the vertex
    parent.lowlink = index
    index += 1
    stack << parent

    adj_vertices(parent.name, adj_lists).each do |adj_vertex|
      # since adj_vertices returns array of strings,
      # must convert to TarjanVertex objects
      child = vertices.select {|v| v.name == adj_vertex}.first

      if child.index == -1  # if child vertex not yet visited
        puts "visiting child: #{child.name}"
        tarjan_dfs(child, scc, stack, index, vertices) # recurse on child

        # change parent's lowlink to smaller lowlink of parent and child)
        parent.lowlink = [parent.lowlink, child.lowlink].min

      # vertex points to earlier (already visited) one in stack,
      # with lower index. thus it's the current SCC
      elsif stack.include?(child)
        parent.lowlink = [parent.lowlink, child.lowlink].min
      end
    end

    # if a vertex's lowlink = its index here, this # cannot go any lower.
    # vertex MUST be root of the SCC.
    if parent.lowlink == parent.index
      component = []  # a single SCC

      # pop off entire SCC, one vertex at a time
      begin
        last_stack_item = stack.pop
        component << last_stack_item.name
      end while last_stack_item != parent # we're back at the root
      scc << component.sort # done with a single SCC
    end
  end

  # reverses direction of all edges in graph
  # adj_lists and a_matrix will be changed for whole program
  def reverse_graph
    copy_graph  # clone copy of old graph in cadj_lists, ca_matrix
    read_vertices
    read_edges(1, 0)
    @a_matrix = a_matrix.transpose
  end

  def copy_graph
    @cadj_lists = adj_lists.clone
    @ca_matrix = a_matrix.clone
  end

  # return to original graph, after reverse_graph
  def rereverse_graph
    @a_matrix = ca_matrix
    read_vertices
    read_edges(0, 1)
    adj_lists
  end

  # finds all connected components of graph
  def cc
    preorder, postorder, visited, cc, ccs = [], [], [], [], []
    @count = 0
    id = {}
    adj_lists.each do |v|
      if !visited.include?(v.name)
        dfs_visit(v.name, adj_lists, id, visited, preorder, postorder)
        @count += 1
        puts "***Back in cc method***\n"
      end
    end

    puts "id = #{id}\n\n"

    (0..id.values.last).each do |i|
      id.each do |vertex, component|
        cc << vertex if i == component
      end
      ccs << cc.sort if cc != []
      cc = []
    end
    print "ccs: #{ccs}\n\n"
    ccs
  end

  # generic depth-first search
  # returns preorder and reverse postorder (topological sort) visits
  def dfs(a_lists)
    @count = 0
    id = {}
    preorder, postorder, visited = [], [], []
    a_lists.each do |v|
      if !visited.include?(v.name)
        dfs_visit(v.name, a_lists, id, visited, preorder, postorder)
      end
    end
    return preorder, postorder.reverse
  end

  def dfs_visit(vertex, a_lists, id, visited, preorder, postorder)
    visited << vertex
    id[vertex] = @count
    preorder << vertex   # add vertex to queue BEFORE recursion
    print "vertex: #{vertex}, id: #{id}\n"
    print "preorder: #{preorder}\npostorder: #{postorder}\n\n"
    adj_vertices(vertex, a_lists).each do |adj_v|
      if !visited.include?(adj_v)
        dfs_visit(adj_v, a_lists, id, visited, preorder, postorder)
      end
    end
    postorder << vertex  # add vertex to queue AFTER recursion
    return preorder, postorder, id
  end

  # Kosaraju–Sharir algorithm to find strongly-connected components (SCCs)
  def scc_kosaraju
    start = adj_lists[0].name
    @count = 0
    id = {}
    preorder, postorder, visited = [], [], []

    # adj_lists changes to that of reversed graph.
    # old graph is in cadj_lists.
    reverse_graph
    puts "1. Finds reverse postorder of reversed graph, with DFS:"
    preorder, rev_postorder = dfs(adj_lists)
    print "#{rev_postorder}\n"

    id = {}
    scc, sccs = [], []
    preorder, postorder, visited = [], [], []

    puts "2. Finds SCCs from preorder of original graph, with DFS, using rev. postorder of vertices above"

    rev_postorder.each do |vertex|
      if !visited.include?(vertex)
        dfs_visit(vertex, cadj_lists, id, visited, preorder, postorder)
      end
      @count += 1
    end
    puts "id = #{id}\n\n"

    (0..id.values.last).each do |i|
      id.each do |vertex, component|
        scc << vertex if i == component
      end
      sccs << scc.sort if scc != []
      scc = []
    end
    print "sccs: #{sccs}\n\n"
    rereverse_graph   # change graph back to original
    sccs
  end

  # returns nested array of all cycles in graph
  def all_cycles
    cycles = []
    start = adj_lists.first.name
    visited = [start] # stack
    previous = {}
    adj_lists.each {|v| previous[v.name] = nil}
    # each cycle may not be bigger than biggest SCC (strongly connected component)
    if max_cycle_length > 1
      answer = all_cycles_dfs(visited, previous, cycles)
    else
      return "NO CYCLES EXIST"
    end
    print "Cycles: #{answer}\n\n"
    answer
  end

  def all_cycles_dfs(visited, previous, cycles)
    adj_vertices(visited.last, adj_lists).each do |vertex|
      #print "Visited stack: #{visited}\n"
      previous[vertex] = visited.last
      if !visited.include?(vertex)
        visited << vertex
        all_cycles_dfs(visited, previous, cycles)
        visited.pop
      else  # found cycle
        cycle = []
        vname = vertex
        while previous[vname] != vertex && !cycle.include?(vname)
          cycle << vname
          vname = previous[vname]
        end
        cycle << vname

        # if cycle not already found and has no repeated vertices
        if (cycles & all_rotations(cycle.reverse) == []) && cycle == cycle.uniq
          cycles << cycle.reverse
        end
      end
    end
    cycles
  end

  # returns # of paths between start and finish, for given range of stops
  def trips(start, finish, stops1, stops2)
    total_paths = 0
    cycles = all_cycles   # all cycles in graph
    (stops1..stops2).each do |stops|
      path, paths = [], []
      visited = [start]
      puts "\nSTOPS GOAL = #{stops}\n"
      num_paths = trips_dfs(start, finish, stops, visited, path, paths, cycles)
      puts "\n--- Total paths for #{stops} stops: #{num_paths}"
      total_paths += num_paths
    end
    puts "\n==> Total paths from #{start} to #{finish}, for #{stops1} to #{stops2} stops: #{total_paths} <==\n"
    total_paths
  end

  #recursive depth-first search, with stack
  def trips_dfs(start, finish, stops, visited, path, paths, cycles)
    adj_vertices(visited.last, adj_lists).each do |vertex|
      print "Visited stack: #{visited}, Next vertex: #{vertex}\n"
      s = visited.size  # stops, including added vertex

      if visited.last == finish && cycles != "NO CYCLES EXIST"

        # try adding cycles if we hit finish vertex too early

        visited_before_cycles = visited
        # picks expanded cycles that begin with finish vertex
        ec = expanded_cycles(cycles).select{|c| c.first == finish}

        # keep adding cycles till we reach stops
        ec.each do |cycle1|
          visited, paths, break_loop = try_cycles(visited, cycle1, paths, stops, 0)
          visited1 = visited

          ec.each do |cycle2|
            begin
              visited, paths, break_loop = try_cycles(visited, cycle2, paths, stops, 0)
            end until break_loop
            visited = visited1
          end

          visited = visited_before_cycles
        end

      elsif !visited.include?(vertex) && dist(visited.last, vertex) != "NO SUCH ROUTE" && s <= stops
        visited << vertex
        path = visited

        if vertex == finish && s == stops
          paths << path
          print "\n*** Path: #{path}, Stops: #{s}, Length: #{path_length(path)}\n\n"
          visited.pop
          break
        end

        trips_dfs(start, finish, stops, visited, path, paths, cycles)
        visited.pop
        visited.pop if visited.size.between?(2, 3) && stops <= 1
        visited = [start] if visited == []
      end
    end
    paths.size
  end

  # returns # of paths between start and finish, with length < max_distance
  def lesstrips(start, finish, max_distance)
    total_paths, distance = 0, 0
    path, paths = [], []
    visited = [start]
    cycles = all_cycles   # all cycles in graph
    puts "MAX DISTANCE = #{max_distance}\n"
    total_paths += lesstrips_dfs(start, finish, max_distance, distance, visited, path, paths, cycles)
    puts "\n==> Total paths from #{start} to #{finish}, with distance < #{max_distance}: #{total_paths}\n"
    total_paths
  end

  #recursive depth-first search, with stack
  def lesstrips_dfs(start, finish, max_distance, distance, visited, path, paths, cycles)
    adj_vertices(visited.last, adj_lists).each do |vertex|
      print "Visited stack: #{visited}, Next vertex: #{vertex}\n"
      totald = distance + dist(visited.last, vertex)

      if visited.last == finish && cycles != "NO CYCLES EXIST"

        # try adding cycles

        visited_before_cycles = visited
        # picks expanded cycles that begin with finish vertex
        ec = expanded_cycles(cycles).select{|c| c.first == finish}

        # keep adding cycles till we reach max distance
        ec.each do |cycle1|
          visited, paths, break_loop = try_cycles(visited, cycle1, paths, 0, max_distance)
          visited1 = visited

          ec.each do |cycle2|
            begin
              visited, paths, break_loop = try_cycles(visited, cycle2, paths, 0, max_distance)
            end until break_loop
            visited = visited1
          end

          visited = visited_before_cycles
        end

      elsif !visited.include?(vertex) && totald != "NO SUCH ROUTE" && totald < max_distance
        visited << vertex
        path = visited
        distance = totald

        if vertex == finish
          paths << path
          print "\n*** Path: #{path}, Length: #{path_length(path)}\n\n"
          visited.pop
          break
        end

        lesstrips_dfs(start, finish, max_distance, distance, visited, path, paths, cycles)
        visited.pop
        visited.pop if visited.size.between?(2, 3)
        visited = [start] if visited == []
      end
    end
    paths.size
  end

  private

  def try_cycles(visited, cycle, paths, stops, max_distance)
    # if max_distance = 0, this method is called from trips_dfs
    # if stops = 0, this method is called from lesstrips_dfs

    # ex: merges [A,B,C] + cycle [C,D,C] into [A,B,C,D,C]
    path = visited[0..-2].concat(cycle)

    #print "Trying cycle: #{path}\n"
    distance = path_length(path)
    s = path.size - 1
    break_loop = false

    if paths.include?(path) || (s > stops && max_distance == 0) ||
      (distance >= max_distance && stops == 0)
      break_loop = true
    elsif s == stops && max_distance == 0
      paths << path
      print "\n*** Path: #{path}, "
      print "Stops: #{stops}, "
      print "Length: #{distance}\n"
      print "*** Paths: #{paths}\n\n"
    elsif stops == 0
      paths << path
      print "\n*** Path: #{path}, Length: #{distance}\n"
      print "*** Paths: #{paths}\n\n"
    end
    visited = path
    return visited, paths, break_loop
  end

  # all circular rotations of a cycle. used to check if cycle was already found.
  def all_rotations(array)
    (1..array.size).collect {|i| array.rotate(i)}
  end

  # returns all rotations of each cycle, with first vertex added to end
  # ex: for [B,C,E], we get [B,C,E,B], [C,E,B,C], [E,B,C,E]
  def expanded_cycles(cycles)
    cycles.collect {|cycle|
      all_rotations(cycle).map {|cycle| cycle +[cycle.first]}
    }.flatten(1)
  end

  # Each cycle may not be bigger than biggest SCC (strongly connected component).
  # Has 0 cycles if no component size > 1
  def max_cycle_length
    scc_kosaraju.map{|scc| scc.size}.max
  end
end