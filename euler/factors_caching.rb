# By Raymond Gan

require 'yaml'

class FactorsCaching
  attr_reader :factors_file
  attr_accessor :integers, :factor_hash

  def initialize(integers = [])
    @integers = integers.sort.uniq
    @factors_file = Dir.pwd + '/factors.dat'
    @factor_hash = File.file?(factors_file) ? YAML.load_file(factors_file) : {}
  end

  # Big-O complexity = O(log n)
  def factors(num)
    (2..Math.sqrt(num)).inject([]) do |ans, f|
      if num % f == 0
        ans << f
        ans << num / f unless f == num / f
      end
      ans
    end.sort
  end

  # If num exists in factor_hash, hash lookup is just O(1)
  # Usually faster than factors method
  def factors_cache(num)
    (2..Math.sqrt(num)).inject([]) do |ans, f|
      # Union of 2 arrays has O(m + n) cost that
      # may make this slower than factors method
      return ans | factor_hash[num] if factor_hash[num]
      if num % f == 0
        ans << f
        ans << num / f unless f == num / f
      end
      ans
    end.sort
  end

  # No caching at all
  def get_factors
    return {} if integers.empty?
    integers.inject({}) do |ans, num|
      ans[num] = factors(num)
      ans
    end
  end

  # Check for cache in 2 places:
  # 1. Initially for num
  # 2. If needed, check again for a factor of num
  # This is fastest overall way
  def get_factors_cache
    return {} if integers.empty?
    integers.inject({}) do |ans, num|
      ans[num] = factor_hash[num] ? factor_hash[num] : factors_cache(num)
      ans
    end
  end

  def cache_in_file
    File.open(factors_file, 'w') { |file| YAML.dump(factor_hash, file) }
  end

  def compare_speed_factors
    cache_count, no_cache_count = 0, 0
    puts "Compare speed of factors vs. factors_cache methods:"

    100.times do
      num = rand(1000)
      start = Time.now
      factors(num)
      time_no_cache = Time.now - start
      print "Time (no cache): #{time_no_cache}. "

      start = Time.now
      factors_cache(num)
      time_cache = Time.now - start
      puts "Time (cache): #{time_cache}."

      if time_cache < time_no_cache
        puts "cache wins"
        cache_count += 1
      else
        puts "no cache wins"
        no_cache_count += 1
      end
      puts
    end

    puts "#{cache_count} cache wins. #{no_cache_count} no cache wins."
  end

  def compare_speed_get_factors
    start = Time.now
    get_factors
    time_no_cache = Time.now - start
    print "Time (no cache): #{time_no_cache}. "

    start = Time.now
    new_factor_hash_cache = get_factors_cache
    time_cache = Time.now - start
    puts "Time (cache): #{time_cache}."

    if time_cache < time_no_cache
      puts "cache wins"
    else
      puts "no cache wins"
    end

    factor_hash.merge!(new_factor_hash_cache)
    cache_in_file
    return time_cache, time_no_cache
  end

#------------------------------------------------------

  # Faster than O(n * n), since inner loop size shrinks
  def multiples
    return {} if integers.empty?
    length = integers.size
    ans = {}
    if length > 1
      (0..length - 2).each do |i|
        num = integers[i]
        ans[num] = []

        integers[i + 1..-1].each do |multiple|
          ans[num] << multiple if multiple % num == 0
        end

      end
    end
    ans[integers[-1]] = []
    ans
  end

  # Using Sieve of Eratosthenes-like way. Takes O(n * n)
  # Slower than multiples method
  def multiples_sieve
    return {} if integers.empty?
    length = integers.size
    last = integers[-1]
    ans = {}
    if length > 1
      (0..length - 2).each do |i|
        num = integers[i]
        # Creating multiples of num take O(n)
        multiples_of_num = num.step(last, num).to_a.drop(1)
        # Intersecting 2 arrays takes O(m+n)
        ans[num] = integers & multiples_of_num
      end
    end
    ans[last] = []
    ans
  end

  def compare_speed_multiples
    start = Time.now
    multiples
    time_no_sieve = Time.now - start
    print "Time (no sieve): #{time_no_sieve}. "

    start = Time.now
    multiples_sieve
    time_sieve = Time.now - start
    puts "Time (sieve): #{time_sieve}."

    if time_sieve < time_no_sieve
      puts "sieve wins"
    else
      puts "no sieve wins"
    end
    puts
    return time_sieve, time_no_sieve
  end
end
