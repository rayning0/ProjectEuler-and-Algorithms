class Vertex
  attr_reader :name
  attr_accessor :adj_list

  def initialize(name, neighbors)
    @name = name
    @adj_list = neighbors
  end
end