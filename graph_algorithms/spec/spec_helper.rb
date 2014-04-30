require 'neighbor'
require 'vertex'
require 'priority_queue'
require 'matrix'
require 'graph'
require 'stringio'
require 'pry'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.color_enabled = true
  config.order = 'default'
end

def capture_stdout(&blk)
  old = $stdout
  $stdout = fake = StringIO.new
  blk.call
  fake.string
  ensure
  $stdout = old
end
