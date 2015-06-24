require './spec_helper'
require '../factors_caching'

describe FactorsCaching do
  describe '#factors_cache' do
    it 'takes 0' do
      expect(subject.factors_cache(0)).to eq([])
    end
    it 'takes prime number' do
      expect(subject.factors_cache(47)).to eq([])
    end
    it 'takes number w/ multiple factors' do
      expect(subject.factors_cache(1000)).to eq([2, 4, 5, 8, 10, 20,
        25, 40, 50, 100, 125, 200, 250, 500])
    end
  end

  describe '#get_factors_cache' do
    it 'takes empty array' do
      expect(subject.get_factors_cache).to eq({})
    end

    it 'takes prime number' do
      subject.integers = [13]
      expect(subject.get_factors_cache).to eq(13 => [])
    end

    it 'takes number w/ multiple factors' do
      subject.integers = [20]
      expect(subject.get_factors_cache).to eq(20 => [2, 4, 5, 10])
    end

    it 'shows factors for multiple integers' do
      subject.integers = [10, 5, 2, 20]
      expect(subject.get_factors_cache).to eq(10 => [2, 5],
        5 => [], 2 => [], 20 => [2, 4, 5, 10])
    end
  end

  describe '#multiples' do
    it 'takes empty array' do
      expect(subject.multiples).to eq({})
    end

    it 'takes single integer' do
      subject.integers = [20]
      expect(subject.multiples).to eq(20 => [])
    end

    it 'shows multiples for multiple integers' do
      subject.integers = [2, 5, 10, 20, 25, 50, 100, 125]
      expect(subject.multiples).to eq(2 => [10, 20, 50, 100],
        5 => [10, 20, 25, 50, 100, 125], 10 => [20, 50, 100], 20 => [100],
        25 => [50, 100, 125], 50 => [100], 100 => [], 125 => [])
    end
  end
end