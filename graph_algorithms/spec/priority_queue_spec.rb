require 'spec_helper'

describe PriorityQueue do
  before do
    @p = PriorityQueue.new
    @p.enq('C', 10)
    @p.enq('Z', 5)
    @p.enq('D', 6)
  end

  describe '#enq' do
    it 'adds new item to queue' do
      @p.enq('B', 9)
      expect(@p.queue).to eq({'C' => 10, 'Z' => 5, 'D' => 6, 'B' => 9})
    end
  end

  describe '#deq' do
    it 'returns item with smallest value from queue and deletes it from queue' do
      expect(@p.deq).to eq({'Z' => 5})
      expect(@p.queue).to eq({'C' => 10, 'D' => 6})
      expect(@p.deq).to eq({'D' => 6})
    end

    it 'returns nil if queue is empty' do
      3.times {@p.deq}
      expect(@p.deq).to be_nil
    end
  end

  describe '#pop' do
    it 'returns last item added to queue' do
      expect(@p.pop).to eq({'D' => 6})
    end

    it 'returns nil if queue is empty' do
      3.times {@p.deq}
      expect(@p.pop).to be_nil
    end
  end
end