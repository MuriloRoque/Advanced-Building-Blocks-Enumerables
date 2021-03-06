# rubocop: disable Metrics/ModuleLength, Metrics/MethodLength, Style/CaseEquality, Style/IfInsideElse

module Enumerable
  def my_each(var = nil)
    return to_enum unless block_given?

    n = if var.nil?
          0
        else
          var
        end
    while n <= size - 1
      yield(to_a[n])
      n += 1
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    n = 0
    while n <= size - 1
      yield(to_a[n], n)
      n += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    result = []
    my_each do |n|
      result.push(n) if yield(n)
    end
    result
  end

  def my_all?(var = nil)
    result = true
    my_each do |n|
      if block_given?
        result = false unless yield(n)
      elsif var.nil?
        result = false unless n
      else
        result = false unless var === n
      end
    end
    result
  end

  def my_any?(var = nil)
    result = false
    my_each do |n|
      if block_given?
        return result = true if yield(n)
      elsif var.nil?
        return result = true if n
      else
        return result = true if var === n
      end
    end
    result
  end

  def my_none?(var = nil)
    result = true
    my_each do |n|
      if block_given?
        return result = false if yield(n)
      elsif var.nil?
        return result = false if n
      else
        return result = false if var === n
      end
    end
    result
  end

  def my_count(var = nil)
    result = []
    if block_given?
      my_each do |n|
        result.push(n) if yield(n)
      end
    elsif var.nil?
      return length
    else
      my_each do |n|
        result.push(n) if n == var
      end
    end
    result.length
  end

  def my_map(var = nil)
    return to_enum unless block_given? || var

    result = []
    if block_given? && var.nil?
      my_each do |n|
        result.push(yield(n))
      end
    else
      my_each do |n|
        result.push(var.call(n))
      end
    end
    result
  end

  def my_inject(var = nil, var2 = nil)
    if var
      if var.is_a? Symbol
        result = to_a[0]
        my_each(1) do |n|
          result = result.method(var).call(n)
        end
      elsif var2.is_a? Symbol
        result = var
        my_each do |n|
          result = result.method(var2).call(n)
        end
      elsif var.is_a? Integer
        result = var
        my_each do |n|
          result = yield(result, n)
        end
      else
        my_each(1) do |n|
          result = var.call(n)
        end
      end
      return result
    else
      result = to_a[0]
      my_each(1) do |n|
        result = yield(result, n)
      end
    end
    result
  end
end

# rubocop: enable Metrics/ModuleLength, Metrics/MethodLength, Style/CaseEquality, Style/IfInsideElse

def multiply_els(arr)
  arr.my_inject { |product, n| product * n }
end
