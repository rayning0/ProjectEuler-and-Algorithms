# See http://www.ruby-doc.org/stdlib-2.0/libdoc/forwardable/rdoc/Forwardable.html
require 'forwardable'

class PriorityQueue
  extend Forwardable
  attr_reader :queue

  def initialize
    @queue = {}
  end

  def_delegators :queue, :size, :empty?, :[], :[]=
  def_delegator :queue, :has_key?, :contains?

  def enq(key, value = nil)
    queue[key] = value  # key = vertex name, value = total distance
  end

  def deq
    return nil if queue.empty?
    minvalue = queue.values.min
    minkey = queue.key(minvalue)
    queue.delete(minkey)
    {minkey => minvalue}
    # Hash[*queue.shift] <- use if want normal (not priority) queue
  end

  def pop
    return nil if queue.empty?
    last_key = queue.keys.last
    last_value = queue[last_key]
    queue.delete(last_key)
    {last_key => last_value}
  end
end