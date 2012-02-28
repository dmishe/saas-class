require 'test/unit'

require 'part1'
require 'part2'
require 'part3'
require 'part4'
require 'part5'


class HW1Test < Test::Unit::TestCase
  def test_palindrome
    assert palindrome?("A man, a plan, a canal -- Panama")
    assert palindrome?("Madam, I'm Adam!")
    assert !palindrome?("Abracadabra")
  end

  def test_count_words
    assert_equal(
      {'a' => 3, 'man' => 1, 'canal' => 1, 'panama' => 1, 'plan' => 1}, 
      count_words("A man, a plan, a canal -- Panama"))

    assert_equal(
      {'doo' => 3, 'bee' => 2}, 
      count_words("Doo bee doo bee doo"))
  end
  
  def test_rps
    assert_raise(WrongNumberOfPlayersError) { rps_game_winner([]) }
    assert_raise(WrongNumberOfPlayersError) { rps_game_winner([1, 2, 3]) }
    
    assert_raise(NoSuchStrategyError) do 
      rps_game_winner([[ "Armando", "A" ], [ "Dave", "S" ]])
    end
    assert_raise(NoSuchStrategyError) do 
      rps_game_winner([[ "Armando", "P" ], [ "Dave", "A" ]])
    end
    
    assert_equal(
      ["Dave", "R"], 
      rps_game_winner([[ "Armando", "S" ], [ "Dave", "R" ]]), 
      "Rock beats Scissors")
    assert_equal(
      ["Armando", "S"], 
      rps_game_winner([[ "Armando", "S" ], [ "Dave", "P" ]]),
      "Scissors beats Paper")
    assert_equal(
      ["Armando", "P"], 
      rps_game_winner([[ "Armando", "P" ], [ "Dave", "R" ]]))
    
    assert_equal(
      ["Armando", "S"], 
      rps_game_winner([[ "Armando", "S" ], [ "Dave", "S" ]]),
      "First player wins stalemate")
  end
  
  def test_rps_tournament
    # assert_equal(["Richard", "R"], rps_tournament_winner([
    #   [
    #     [ ["Armando", "P"], ["Dave", "S"] ],
    #     [ ["Richard", "R"],  ["Michael", "S"] ],
    #   ],
    #   [ 
    #     [ ["Allen", "S"], ["Omer", "P"] ],
    #     [ ["David E.", "R"], ["Richard X.", "P"] ]
    #   ]
    #   ]))
      
    assert_equal(["A3", "R"], rps_tournament_winner([
      [
        [ ["A1", "P"], ["A2", "S"] ],
        [ ["A3", "R"],  ["A4", "S"] ],            #A3, R
      ],
      [
        [ ["Armando", "P"], ["Dave", "S"] ],
        [ ["Richard", "R"],  ["Michael", "S"] ],  #Richard, R
      ],
      [
        [ ["Armando", "P"], ["Dave", "S"] ],
        [ ["Richard", "R"],  ["Michael", "S"] ],  #Richard, R
      ],
      [ 
        [ ["Allen", "S"], ["Omer", "P"] ],
        [ ["David E.", "R"], ["Richard X.", "P"] ]#Allen, S
      ]
      ]*4))
  
      
    assert_equal(["Richard", "R"], rps_tournament_winner([ ["Richard", "R"],  ["Michael", "S"] ]))  
  end
  
  def test_anagrams
    input = [["cars", "racs", "scar"], ["four"], ["for"], ["potatoes"], ["creams", "scream"]]
    output = combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams', 'scream'])
    assert (input - output).length == 0, "lists should have the same content"
    
    assert ([["A", "a"]] - combine_anagrams(["a", "A"]))
  end
  
  def test_desserts
    dessert = Dessert.new("icecream", 150)
    assert dessert.delicious?
    assert dessert.healthy?
    dessert.name = "new_name"
    
    dessert.calories = 300
    assert !dessert.healthy?
    
    jelly = JellyBean.new("icecream", 150, "strawberry")
    assert jelly.delicious?
    assert jelly.healthy?
    
    jelly.flavor = 'black licorice'
    assert !jelly.delicious?
  end
  
  def test_meta
    f = Foo.new
    f.bar = 1
    f.bar = 2
    assert f.bar_history == [nil, 1, 2]
    
    x = Foo.new
    x.bar = "a"
    x.bar = "b"
    assert x.bar_history == [nil, "a", "b"]
  end
end
