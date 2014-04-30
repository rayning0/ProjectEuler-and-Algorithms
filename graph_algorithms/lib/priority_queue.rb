class PriorityQueue
  attr_reader :queue

  def initialize
    @queue = {}
  end

  def enq(key, value = nil)
    queue[key] = value  # key = vertex name, value = total distance
  end

  def deq
    if queue.empty?
      return nil
    else
      minvalue = queue.values.min
      minkey = queue.key(minvalue)
      queue.delete(minkey)
      {minkey => minvalue}
      # Hash[*queue.shift] <- use if want normal (not priority) queue
    end
  end

  def pop
    if queue.empty?
      return nil
    else
      last_key = queue.keys.last
      last_value = queue[last_key]
      queue.delete(last_key)
      {last_key => last_value}
    end
  end

  def contains?(key)
    queue.has_key?(key)
  end

  def size
    queue.size
  end

  def empty?
    queue.empty?
  end
end