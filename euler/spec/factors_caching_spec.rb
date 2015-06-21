require './spec_helper'
require '../factors_caching'

describe FactorsCaching do
  describe '#factors' do
    it 'takes 0' do
      expect(subject.factors(0)).to eq([])
    end
    it 'takes prime number' do
      expect(subject.factors(47)).to eq([])
    end
    it 'takes number w/ multiple factors' do
      expect(subject.factors(1000)).to eq([2, 4, 5, 8, 10, 20,
        25, 40, 50, 100, 125, 200, 250, 500])
    end
  end

  describe '#run' do
    it 'takes empty array' do
      expect(subject.run([])).to eq({})
    end

    it 'takes prime number' do
      expect(subject.run([13])).to eq({ 13 => [] })
    end

    it 'takes number w/ multiple factors' do
      expect(subject.run([20])).to eq({ 20 => [2, 4, 5, 10] })
    end

    it 'take multiple integers and shows their factors' do
      expect(subject.run([10, 5, 2, 20])).to eq({ 10 => [2, 5],
        5 => [], 2 => [], 20 => [2, 4, 5, 10] })
    end
  end
end