require 'test/unit'



class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1.0}
  def convert_to(currency, divide=false)
    singular_currency = currency.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      if divide
        return self / @@currencies[singular_currency]
      else
        return self * @@currencies[singular_currency]
      end
    end
  end
  
  def method_missing(method_id)
    convert_to(method_id) or super
  end
  
  def in(currency)
    convert_to(currency, divide=true)
  end
end


def _palindrome?(string)
  # determines whether a given word or phrase is a palindrome
  cleaned = string.gsub(/\W/, '').downcase

  cleaned == cleaned.reverse
end


class String; def palindrome?; _palindrome?(self) end; end

module Enumerable
  def palindrome?
    self.to_a.respond_to?(:reverse) ? self.to_a == self.to_a.reverse : false
  end
end

class VPT
  include Enumerable
  
  @@l = [1,2,3,2,1]
  def each
    @@l.each {|x| yield x}
  end
end

class HW2Test < Test::Unit::TestCase
  def test_a
    assert 2.rupee.in(:dollar).between?(0.037, 0.039)
    assert 3.yen.in(:dollar).between?(0.038, 0.040)
    assert 6.euro.in(:dollar).between?(7.75, 7.76)
    assert 2.rupees.in(:dollars).between?(0.037, 0.039)
    assert 3.yen.in(:dollars).between?(0.038, 0.040)
    assert 6.euros.in(:dollars).between?(7.75, 7.76)
    assert 5.rupees.in(:yen).between?(7.2, 7.4)
  end
  
  def test_b
    assert "A man, a plan, a canal -- Panama".palindrome?
    assert "a man a plan a canal panama".palindrome?
  end
  
  def test_c
    assert [1,2,3,2,1].palindrome?
    assert ["a", "b", "c", "b", "a"].palindrome?
    assert ![1,2,3,4,3,2].palindrome?
    assert !Hash.new.palindrome?
    assert !{"hello"=> "world"}.palindrome?
    assert !(1..2).palindrome?
    
    pvalue = Hash.new.palindrome?
    assert pvalue.is_a?(TrueClass) || pvalue.is_a?(FalseClass)

    assert VPT.new.palindrome?
  end
end
