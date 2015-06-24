require './factors_caching'

# Results of sample run are in file "factors.output"

# Compare speed of factors vs. factors_cache methods:
FactorsCaching.new.compare_speed_factors

# From "factors.output": "65 cache wins. 35 no cache wins."

puts "\nCompare speed of get_factors vs. get_factors_cache methods:"
@cache_count, @no_cache_count = 0, 0

100.times do
  integers = Array.new(5) { |num| rand(1000) }
  cache, no_cache = FactorsCaching.new(integers).compare_speed_get_factors
  if cache < no_cache
    @cache_count += 1
  else
    @no_cache_count += 1
  end
end

puts "#{@cache_count} cache wins. #{@no_cache_count} no cache wins."

# From "factors.output": "98 cache wins. 2 no cache wins."

puts "\nCompare speed of multiples vs. multiples_sieve methods:"
@sieve_count, @no_sieve_count = 0, 0

100.times do
  integers = Array.new(8) { |num| rand(100) + 2 }
  sieve, no_sieve = FactorsCaching.new(integers).compare_speed_multiples
  if sieve < no_sieve
    @sieve_count += 1
  else
    @no_sieve_count += 1
  end
end

puts "#{@sieve_count} sieve wins. #{@no_sieve_count} no sieve wins."

# From "factors.output": 2 sieve wins. 98 no sieve wins.
