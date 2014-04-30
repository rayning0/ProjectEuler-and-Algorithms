class Neighbor
  attr_reader :name, :weight, :next

  def initialize(vnum, neighbor, weight, name)
    @vnum = vnum
    @next = neighbor
    @weight = weight
    @name = name
  end
end