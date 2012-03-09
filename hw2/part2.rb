require 'test/unit'

class CartesianProduct
  include Enumerable
  
  def initialize(a, b)
    @a = a
    @b = b
  end
  
  def each
    @a.each {|x| @b.each {|y| yield x, y}}
  end
end


class HW2Test < Test::Unit::TestCase
  def test_iterator
    a = [:a, :b, :c]
    b = [4, 5]
    
    assert CartesianProduct.new(a, b).to_a == [[:a,4],[:a,5],[:b,4],[:b,5],[:c,4],[:c,5]]
    assert CartesianProduct.new(b, a).to_a == [[4, :a], [4, :b], [4, :c], [5, :a], [5, :b], [5, :c]]
    assert CartesianProduct.new([:a,:b], []).to_a.empty?
  end
  
end