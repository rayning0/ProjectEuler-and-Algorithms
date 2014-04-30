# By Raymond Gan
# See "rspec_screen_output.txt" for RSpec results

require 'spec_helper'

describe Graph do
  let(:g) {Graph.new("./data/directed.txt")}
  let(:h) {Graph.new("./data/undirected.txt")}
  let(:j) {Graph.new("./data/directed2.txt")}
  let(:k) {Graph.new("./data/directed_matrix.txt")}
  let(:scc) {Graph.new("./data/directed_scc.txt")}
  let(:m) {Graph.new("./data/directed3.txt")}
  let(:n) {Graph.new("./data/directed4.txt")}
  let(:p1) {Graph.new("./data/directed_p1.txt")}
  let(:p2) {Graph.new("./data/directed_p2.txt")}
  let(:p3) {Graph.new("./data/directed_p3.txt")}
  let(:ks) {Graph.new("./data/kosaraju.txt")}
  let(:ks2) {Graph.new("./data/tinyDAG.txt")}
  let(:ks3) {Graph.new("./data/tinyDG.txt")}
  let(:p23) {Graph.new("./data/undirected_p23.txt")}
  let(:cc1) {Graph.new("./data/tinyG.txt")}
  let(:p22) {Graph.new("./data/undirected_p22.txt")}
  let(:p21) {Graph.new("./data/undirected_p21.txt")}

  let(:graphfile_g) {["directed", "5", "A", "B", "C", "D", "E",
                      "A B 5",
                      "B C 4",
                      "C D 8",
                      "D C 8",
                      "D E 6",
                      "A D 5",
                      "C E 2",
                      "E B 3",
                      "A E 7"]}

  let(:graphfile_h) {["undirected", "8", "A", "B", "C", "D", "E", "F", "G", "H",
                      "A B 7",
                      "A C 8",
                      "B F 2",
                      "C F 6",
                      "C G 4",
                      "E H 1",
                      "F D 8",
                      "F G 9",
                      "F H 3"]}

  # checks both directed and undirected graphs
  describe "#read_file" do
    it "reads graph input file as an array" do
      expect(g.read_file("./data/directed.txt")).to eq(graphfile_g)
      expect(h.read_file("./data/undirected.txt")).to eq(graphfile_h)
    end
  end

  describe "#adj_matrix" do
    it "creates adjacency matrix from graph input file" do
      matrix_g = Matrix[[0, 1, 0, 1, 1], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1], [0, 0, 1, 0, 1], [0, 1, 0, 0, 0]]
      matrix_k = Matrix[[0, 1, 0, 1, 1], [1, 0, 1, 1, 0], [0, 0, 0, 1, 1], [1, 0, 1, 0, 1], [0, 0, 0, 0, 0]]
      expect(g.adj_matrix).to eq(matrix_g)
      expect(k.adj_matrix).to eq(matrix_k)
    end
  end

  describe "#read_vertices" do
    it "returns array of Vertex objects---adjacency list" do
      adj_lists = g.read_vertices
      expect(adj_lists[3].instance_of?(Vertex)).to eq(true)
      expect(adj_lists[3].name).to eq('D')
      expect(adj_lists[3].adj_list).to be_nil
      expect(adj_lists.size).to eq(5)
    end
  end

  describe "#adj_vertices" do
    it "returns array of vertices pointing out from given vertex" do
      expect(g.adj_vertices('A', g.adj_lists)).to eq(['E', 'D', 'B'])
      expect(g.adj_vertices('B', g.adj_lists)).to eq(['C'])
      expect(g.adj_vertices('C', g.adj_lists)).to eq(['E', 'D'])
      expect(g.adj_vertices('D', g.adj_lists)).to eq(['E', 'C'])
      expect(g.adj_vertices('E', g.adj_lists)).to eq(['B'])
    end
  end

  describe "#inward_vertices" do
    it "returns array of vertices pointing into given vertex" do
      expect(g.inward_vertices('A', g.adj_lists)).to eq([])
      expect(g.inward_vertices('B', g.adj_lists)).to eq(['A', 'E'])
      expect(g.inward_vertices('C', g.adj_lists)).to eq(['B', 'D'])
      expect(g.inward_vertices('D', g.adj_lists)).to eq(['A', 'C'])
      expect(g.inward_vertices('E', g.adj_lists)).to eq(['A', 'C', 'D'])
    end
  end

  describe "#read_edges" do
    it "returns final version of adjacency lists, containing Neighbor objects connected as linked lists" do
      adj_lists = g.read_edges(0, 1)
      # from input file, vertex A is connected to E, D, and B
      expect(adj_lists[0].adj_list.instance_of?(Neighbor)).to eq(true)
      expect(adj_lists[0].adj_list.name).to eq('E')
      expect(adj_lists[0].adj_list.weight).to eq(7)
      expect(adj_lists[0].adj_list.next.instance_of?(Neighbor)).to eq(true)
      expect(adj_lists[0].adj_list.next.name).to eq('D')
      expect(adj_lists[0].adj_list.next.weight).to eq(5)
      expect(adj_lists[0].adj_list.next.next.name).to eq('B')
      expect(adj_lists[0].adj_list.next.next.weight).to eq(5)
    end
  end

  describe "#vertex_num_for" do
    it "finds vertex number, given vertex name" do
      expect(g.vertex_num_for('A')).to eq(0)
      expect(g.vertex_num_for('B')).to eq(1)
      expect(g.vertex_num_for('C')).to eq(2)
      expect(g.vertex_num_for('D')).to eq(3)
      expect(g.vertex_num_for('E')).to eq(4)
    end
  end

  describe "#copy_graph" do
    it "clones graph into cadj_lists, ca_matrix" do
      g.copy_graph
      expect(g.cadj_lists == g.adj_lists).to eq(true)
      expect(g.ca_matrix == g.a_matrix).to eq(true)
    end

    it "but object_ids are different" do
      expect(g.cadj_lists.object_id == g.adj_lists.object_id).to eq(false)
      expect(g.ca_matrix.object_id == g.a_matrix.object_id).to eq(false)
    end
  end

  describe "#reverse_graph" do
    it "reverses all edges in graph and makes copy of old graph" do
      g.reverse_graph
      expect(g.a_matrix).to eq(Matrix[[0, 0, 0, 0, 0], [1, 0, 0, 0, 1], [0, 1, 0, 1, 0], [1, 0, 1, 0, 0], [1, 0, 1, 1, 0]])
      expect(g.adj_lists[0].adj_list).to eq(nil)
      expect(g.adj_lists[4].adj_list.name).to eq('A')
      expect(g.adj_lists[4].adj_list.weight).to eq(7)
      expect(g.adj_lists[4].adj_list.next.instance_of?(Neighbor)).to eq(true)
      expect(g.adj_lists[4].adj_list.next.name).to eq('C')
      expect(g.adj_lists[4].adj_list.next.weight).to eq(2)
      expect(g.adj_lists[4].adj_list.next.next.name).to eq('D')
      expect(g.adj_lists[4].adj_list.next.next.weight).to eq(6)

      # makes copy of old graph
      expect(g.ca_matrix).to eq(Matrix[[0, 1, 0, 1, 1], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1], [0, 0, 1, 0, 1], [0, 1, 0, 0, 0]])
      expect(g.cadj_lists[0].adj_list.name).to eq('E')
      expect(g.cadj_lists[0].adj_list.weight).to eq(7)
      expect(g.cadj_lists[0].adj_list.next.instance_of?(Neighbor)).to eq(true)
      expect(g.cadj_lists[0].adj_list.next.name).to eq('D')
      expect(g.cadj_lists[0].adj_list.next.weight).to eq(5)
      expect(g.cadj_lists[0].adj_list.next.next.name).to eq('B')
      expect(g.cadj_lists[0].adj_list.next.next.weight).to eq(5)
    end
  end

  describe "#rereverse_graph" do
    it "changes graph back to original, after reverse_graph" do
      expect(g.a_matrix).to eq(Matrix[[0, 1, 0, 1, 1], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1], [0, 0, 1, 0, 1], [0, 1, 0, 0, 0]])
      expect(g.adj_lists[0].adj_list.name).to eq('E')

      g.reverse_graph
      expect(g.a_matrix).to eq(Matrix[[0, 0, 0, 0, 0], [1, 0, 0, 0, 1], [0, 1, 0, 1, 0], [1, 0, 1, 0, 0], [1, 0, 1, 1, 0]])
      expect(g.adj_lists[0].adj_list).to eq(nil)
      expect(g.adj_lists[4].adj_list.name).to eq('A')

      g.rereverse_graph
      expect(g.a_matrix).to eq(Matrix[[0, 1, 0, 1, 1], [0, 0, 1, 0, 0], [0, 0, 0, 1, 1], [0, 0, 1, 0, 1], [0, 1, 0, 0, 0]])
      expect(g.adj_lists[0].adj_list.name).to eq('E')
    end
  end

  describe "#print_graph" do
    context "for directed graph" do
      it "prints graph as an adjacency list" do
        output_g = capture_stdout do
          g.print_graph
        end

        output_g.should include("A --> E (7) --> D (5) --> B (5)")
        output_g.should include("B --> C (4)")
        output_g.should include("C --> E (2) --> D (8)")
        output_g.should include("D --> E (6) --> C (8)")
        output_g.should include("E --> B (3)")
      end
    end

    context "for undirected graph" do
      it "prints graph as an adjacency list" do
        output_h = capture_stdout do
          h.print_graph
        end

        output_h.should include("A --> C (8) --> B (7)")
        output_h.should include("B --> F (2) --> A (7)")
        output_h.should include("C --> G (4) --> F (6) --> A (8)")
        output_h.should include("D --> F (8)")
        output_h.should include("E --> H (1)")
        output_h.should include("F --> H (3) --> G (9) --> D (8) --> C (6) --> B (2)")
        output_h.should include("G --> F (9) --> C (4)")
        output_h.should include("H --> F (3) --> E (1)")
      end
    end
  end

  describe "#dist" do
    it "finds distances between vertices" do
      expect(g.dist('A', 'B', 'C')).to eq(9)
      expect(g.dist('A', 'D')).to eq(5)
      expect(g.dist('A', 'D', 'C')).to eq(13)
      expect(g.dist('A', 'E', 'B', 'C', 'D')).to eq(22)
      expect(g.dist('A', 'E', 'D')).to eq("NO SUCH ROUTE")
    end
  end

  describe "#path_length" do
    it "finds total distance of a path of vertices" do
      expect(g.path_length(%w[C D C E B C])).to eq(25)
      expect(g.path_length(%w[C D C])).to eq(16)
      expect(g.path_length(%w[C E B C])).to eq(9)
      expect(g.path_length(%w[C E B C D C])).to eq(25)
      expect(g.path_length(%w[C D C E B C])).to eq(25)
      expect(g.path_length(%w[C D E B C])).to eq(21)
      expect(g.path_length(%w[C E B C E B C])).to eq(18)
      expect(g.path_length(%w[C E B C E B C E B C])).to eq(27)
    end
  end

  # uses adjacency matrix way
  # k is graph (Fig. 15) from here: https://www.math.ucdavis.edu/~daddel/linear_algebra_appl/Applications/GraphTheory/GraphTheory_9_17/node9.html
  describe "#maxtrips" do
    it "finds number of trips between 2 vertices with given range of stops" do
      expect(g.maxtrips('C', 'C', 1, 3)).to eq(2) # for max of 3 stops
      expect(g.maxtrips('A', 'C', 4, 4)).to eq(3) # for exactly 4 stops
      expect(k.maxtrips('P2', 'P5', 3, 3)).to eq(4) # for example 3 stops
      expect(k.maxtrips('P3', 'P2', 1, 3)).to eq(1) # for max of 3 stops. UC Davis page has mistake at bottom. Answer is 1, not 2.
      expect(j.maxtrips('A', 'P', 4, 4)).to eq(3) # for exactly 3 stops
    end
  end

  describe "#shortest_length" do
    it "finds length of shortest distance between 2 vertices" do
      expect(g.shortest_length('A', 'C')).to eq(9)
      expect(g.shortest_length('B', 'B')).to eq(9)
      expect(g.shortest_length('C', 'C')).to eq(9)
      expect(h.shortest_length('A', 'E')).to eq(13) # undirected graph
      expect(m.shortest_length('C', 'C')).to eq(2)
    end
  end

  # finds shortest path between 2 vertices (fewest edges), using breadth-first search (BFS)
  describe "#fewest_edges" do
    it "finds shortest path between 2 vertices (fewest edges)" do
      expect(g.fewest_edges('A', 'C')).to eq(2)
      expect(g.fewest_edges('B', 'B')).to eq(3)
      expect(g.fewest_edges('C', 'C')).to eq(2)
      expect(p1.fewest_edges('A', 'H')).to eq(4)
    end
  end

  describe "#all_cycles" do
    # excludes self-loops (like A->A)
    it "finds nested array of all cycles in graph" do
      expect(g.all_cycles).to eq([["B", "C", "E"], ["B", "C", "D", "E"], ["D", "C"]])
      expect(j.all_cycles).to eq("NO CYCLES EXIST")
      expect(n.all_cycles).to eq([["6", "3"], ["4", "6", "3"], ["1", "2", "0"]])
    end
  end

  describe "#trips" do
    it "finds number of trips between 2 vertices with given range of stops" do
      expect(g.trips('C', 'C', 1, 3)).to eq(2)  # original question
      expect(g.trips('A', 'C', 4, 4)).to eq(3)  # original question

      expect(g.trips('A', 'C', 3, 3)).to eq(1)
      expect(g.trips('A', 'C', 2, 2)).to eq(2)
      expect(g.trips('A', 'C', 1, 1)).to eq(0)
      expect(g.trips('A', 'C', 1, 4)).to eq(6)  # note 6 = 1 + 2 + 0

      expect(g.trips('A', 'B', 1, 1)).to eq(1)
      expect(j.trips('A', 'P', 4, 4)).to eq(3)
      expect(g.trips('B', 'B', 3, 4)).to eq(2)
      expect(g.trips('D', 'D', 2, 4)).to eq(3)
      expect(g.trips('E', 'E', 3, 4)).to eq(2)

      expect(g.trips('C', 'C', 9, 9)).to eq(2)
      expect(g.trips('C', 'C', 1, 9)).to eq(19)
    end
  end

  describe "#lesstrips" do
    it "finds number of trips between 2 vertices with distance < amount" do
      expect(g.lesstrips('C', 'C', 30)).to eq(7)
    end
  end

  describe "#dfs" do
    context "for normal graph" do
      it "shows preorder and reverse postorder of vertices visited by recursive DFS" do
        # preorder
        expect(ks2.dfs(ks2.adj_lists)[0]).to eq(["0", "5", "4", "1", "6", "9", "11", "12", "10", "2", "3", "7", "8"])
        # reverse postorder
        expect(ks2.dfs(ks2.adj_lists)[1]).to eq(["8", "7", "2", "3", "0", "6", "9", "10", "11", "12", "1", "5", "4"])
      end
    end

    context "for reversed graph" do
      it "shows preorder and reverse postorder of vertices visited by recursive DFS" do
      ks.reverse_graph
      # preorder (in Coursera lecture)
      expect(ks.dfs(ks.adj_lists)[0]).to eq(["0", "6", "8", "7", "2", "4", "11", "9", "12", "10", "5", "3", "1"])
      # reverse
      expect(ks.dfs(ks.adj_lists)[1]).to eq(["1", "0", "2", "4", "5", "3", "11", "9", "12", "10", "6", "7", "8"])
      end
    end
  end

  describe "#scc_tarjan" do
    it "finds nested array of all strongly connected components (SCCs) in graph" do
      # graph g has >= 1 cycle for [B, C, D, E]
      expect(g.scc_tarjan).to eq([["B", "C", "D", "E"], ["A"]])
      # graph h is an undirected graph and thus full of cycles
      expect(h.scc_tarjan).to eq([["A", "B", "C", "D", "E", "F", "G", "H"]])
      # tree j has 0 cycles: there's no component > size 1
      expect(j.scc_tarjan).to eq([["O"], ["N"], ["G"], ["M"], ["P"], ["L"], ["F"], ["C"], ["I"], ["K"], ["J"], ["E"], ["H"], ["D"], ["B"], ["A"]])
      # graph k has >= 1 cycle for [P1, P2, P3, P4]
      expect(k.scc_tarjan).to eq([["P5"], ["P1", "P2", "P3", "P4"]])

      # graph scc has 3 SCCs (and thus >= 3 cycles), shown here:
      # http://iwillgetthatjobatgoogle.tumblr.com/post/19060679724/finding-strongly-connected-components-of-graph
      # NOTE: all SCCs are found in REVERSE topological order.
      # If we reverse nested array, we get topological sort of the SCCs!
      expect(scc.scc_tarjan).to eq([["f", "g"], ["c", "d", "h"], ["a", "b", "e"]])

      expect(m.scc_tarjan).to eq([["B", "C", "D", "E"], ["A"]])
      expect(n.scc_tarjan).to eq([["7"], ["5"], ["3", "4", "6"], ["0", "1", "2"]])
      expect(p1.scc_tarjan).to eq([["E"], ["A", "B", "C", "F", "G", "H"], ["D"]])
      expect(p2.scc_tarjan).to eq([["A"], ["B"], ["D"], ["C"], ["H"], ["G"], ["F"], ["E"]])
      expect(p3.scc_tarjan).to eq([["D", "E", "I", "J"], ["H"], ["A", "B", "C", "F", "G"]])
      expect(ks.scc_tarjan).to eq([["1"], ["0", "2", "3", "4", "5"], ["10", "11", "12", "9"], ["6", "8"], ["7"]])
      expect(ks2.scc_tarjan).to eq([["4"], ["5"], ["1"], ["12"], ["11"], ["10"], ["9"], ["6"], ["0"], ["3"], ["2"], ["7"], ["8"]])
      expect(ks3.scc_tarjan).to eq([["1"], ["0", "2", "3", "4", "5"], ["10", "11", "12", "9"], ["6", "8"], ["7"]])
    end
  end

  describe "#scc_kosaraju" do
    it "returns SCCs using Kosaraju 2-pass algorithm" do
       expect(ks.scc_kosaraju).to eq([["1"], ["0", "2", "3", "4", "5"], ["10", "11", "12", "9"], ["6", "8"], ["7"]])
       expect(ks3.scc_kosaraju).to eq([["1"], ["0", "2", "3", "4", "5"], ["10", "11", "12", "9"], ["6", "8"], ["7"]])
       expect(g.scc_kosaraju).to eq([["B", "C", "D", "E"], ["A"]])
       expect(h.scc_kosaraju).to eq([["A", "B", "C", "D", "E", "F", "G", "H"]])
       expect(j.scc_kosaraju).to eq([["P"], ["O"], ["N"], ["M"], ["L"], ["K"], ["J"], ["I"], ["H"], ["G"], ["F"], ["E"], ["D"], ["C"], ["B"], ["A"]])
       expect(k.scc_kosaraju).to eq([["P5"], ["P1", "P2", "P3", "P4"]])
       expect(scc.scc_kosaraju).to eq([["f", "g"], ["c", "d", "h"], ["a", "b", "e"]])
       expect(m.scc_kosaraju).to eq([["B", "C", "D", "E"], ["A"]])
       expect(n.scc_kosaraju).to eq([["7"], ["5"], ["3", "4", "6"], ["0", "1", "2"]])
       expect(p1.scc_kosaraju).to eq([["E"], ["A", "B", "C", "F", "G", "H"], ["D"]])
       expect(p2.scc_kosaraju).to eq([["D"], ["A"], ["B"], ["C"], ["H"], ["G"], ["F"], ["E"]])
       expect(p3.scc_kosaraju).to eq([["D", "E", "I", "J"], ["H"], ["A", "B", "C", "F", "G"]])
       expect(ks2.scc_kosaraju).to eq([["12"], ["11"], ["10"], ["9"], ["4"], ["5"], ["6"], ["7"], ["8"], ["3"], ["1"], ["0"], ["2"]])
    end
  end

  describe "#cc" do
    it "finds all connected components (CCs) of a graph" do
      expect(p23.cc).to eq([["A", "B", "F", "G"], ["C", "H"], ["D", "E", "I", "J"]])
      expect(cc1.cc).to eq([["0", "1", "2", "3", "4", "5", "6"], ["7", "8"], ["10", "11", "12", "9"]])
    end
  end
end
