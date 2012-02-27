require 'test/unit'

class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end


def palindrome?(string)
  # determines whether a given word or phrase is a palindrome
  cleaned = string.gsub(/\W/, '').downcase

  cleaned == cleaned.reverse
end

def count_words(words)
  # Given a string of input, return a hash whose keys are words in the string
  # whose values are the number of times each word appears 

  Hash[words.downcase.scan(/\w+/).group_by { |x|x }.map {|k,v| [k, v.length]}]
end

def rps_game_winner(players)
  strategies = ["P", "R", "S"]
  rules = [ # first wins
    ["R", "S"],
    ["S", "P"],
    ["P", "R"]
    ]

  raise WrongNumberOfPlayersError unless players.length == 2
  raise NoSuchStrategyError unless (players.map {|x| x[1]} - strategies).empty?
  
  player_strategies = players.map {|x| x[1]}
  
  return players[0] if player_strategies[0] == player_strategies[1]
  
  # see if we have player choices in rules, in reverse for second player
  return players[0] if rules.include? player_strategies
  return players[1] if rules.include? player_strategies.reverse
end

def rps_game_tournament(tournament)
  # TODO: fix with recursion
  rps_game_winner(tournament.map do |round|
    rps_game_winner(round.map {|x| rps_game_winner(x)})    
  end)  
end

def combine_anagrams(words)
  words.group_by { |word| word.chars.sort.join }.values
end


class Dessert
  attr_accessor :calories
  
  def initialize(name, calories)
    @name = name
    @calories = calories
  end

  def healthy?
    @calories < 200
  end

  def delicious?
    true
  end
end

class JellyBean < Dessert
  attr_accessor :flavor
  
  def initialize(name, calories, flavor)
    super(name, calories)
    @flavor = flavor
  end

  def delicious?
    return false if @flavor == 'black licorice'
    super
  end
end


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
    assert_equal(["Richard", "R"], rps_game_tournament([
      [
        [ ["Armando", "P"], ["Dave", "S"] ],
        [ ["Richard", "R"],  ["Michael", "S"] ],
      ],
      [ 
        [ ["Allen", "S"], ["Omer", "P"] ],
        [ ["David E.", "R"], ["Richard X.", "P"] ]
      ]
      ]))
  end
  
  def test_anagrams
    input = [["cars", "racs", "scar"], ["four"], ["for"], ["potatoes"], ["creams", "scream"]]
    output = combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams', 'scream'])
    assert (input - output).length == 0, "lists should have the same content"
  end
  
  def test_desserts
    dessert = Dessert.new("icecream", 150)
    assert dessert.delicious?
    assert dessert.healthy?
    
    dessert.calories = 300
    assert !dessert.healthy?
    
    jelly = JellyBean.new("icecream", 150, "strawberry")
    assert jelly.delicious?
    assert jelly.healthy?
    
    jelly.flavor = 'black licorice'
    assert !jelly.delicious?
  end
    
end
