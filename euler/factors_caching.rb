class FactorsCaching
  def run(integers)
    return {} if integers.empty?
    integers.inject({}) do |ans, num|
      ans[num] = factors(num)
      ans
    end
  end

  def factors(num)
    (2..Math.sqrt(num)).inject([]) do |ans, f|
      if num % f == 0
        ans << f
        ans << num / f unless f == num / f
      end
      ans
    end.sort
  end
end
