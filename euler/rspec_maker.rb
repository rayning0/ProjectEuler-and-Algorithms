=begin
By Raymond Gan, 4/30/14
Automatically makes RSpec files!

Reads in data text file in this format below (on separate lines)
See '/data/rspec_maker_input.txt' for sample format:

File name (assume 1 file per class. Your Ruby code in /lib.)
Class name
* (1 star)
Method name 1
All inputs (on separate lines)
(blank line)
All expected outputs (separate lines)
* (1 star)
Method name 2
etc........
= (end of file)

=end

INPUT_FILE = 'rspec_maker_input.txt'
OUTPUT_DIR = './spec/'

class RSpecMaker
  attr_accessor :filename, :classname, :method, :data_in, :data_out, :line
  def initialize
    @line = read_file
    @filename = line[0]
    @classname = line[1]
    @method = []
    @data_in = []
    @data_out = []
  end

  def read_file
    IO.readlines(INPUT_FILE).map(&:chomp) # reads file as array
  end

  def read_file_input
    i = 2
    m = -1
    inc, outc = 0, 0
    loop do
      # Start new method. Read data in.
      if line[i][0] == '*'
        m += 1
        @method[m] = line[i + 1]
        i += 2

        begin
          @data_in[inc] = line[i]
          i += 1
          inc += 1
        end until line[i] == ''

        @data_in << '*'   # mark end of data in
        inc += 1
      end

      # Read data out
      if line[i] == ''
        i += 1

        begin
          @data_out[outc] = line[i]
          i += 1
          outc += 1
        end until ['*', '='].include?(line[i])

        @data_out << '*'  # mark end of data out
        outc += 1
        i -= 1
      end
      break if line[i] == '='
      i += 1
    end
  end

  def write_spec_file
    inc = 0
    output_file = "#{OUTPUT_DIR}#{filename}_spec.rb"
    File.open(output_file, 'w') # overwrites old file
    File.open(output_file, 'a') do |f|
      f.puts "require 'spec_helper'"
      f.puts "require '#{filename}'"
      f.puts
      f.puts "describe #{classname} do"
      f.puts "  let(:#{classname[0].downcase}) { #{classname}.new }"

      method.size.times do |m|
        f.puts
        f.puts "  describe '##{method[m]}' do"
        f.puts "    it '' do"

        loop do
          if data_in[inc] == '*'  # hit end of data for this method
            inc += 1
            break
          end
          f.puts "      expect(#{classname[0].downcase}.#{method[m]}(#{data_in[inc]})).to eq(#{data_out[inc]})"
          inc += 1
        end
        f.puts "    end"
        f.puts "  end"
      end
      f.puts "end"
    end
  end

  def run
    read_file_input
    write_spec_file
  end
end

RSpecMaker.new.run