require 'spec_helper'
require 'roman_numbers'

describe RomanNumbers do
  let(:r) { RomanNumbers.new }

  describe '#to_roman' do
    it '' do
      expect(r.to_roman(29)).to eq('XXIX')
      expect(r.to_roman(1999)).to eq('MCMXCIX')
      expect(r.to_roman(38)).to eq('XXXVIII')
    end
  end

  describe '#from_roman' do
    it '' do
      expect(r.from_roman('XXIX')).to eq(29)
      expect(r.from_roman('MCMXCIX')).to eq(1999)
      expect(r.from_roman('XXXVIII')).to eq(38)
    end
  end
end
