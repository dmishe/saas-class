class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

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

def rps_tournament_winner(tournament)
  return rps_game_winner(tournament) if tournament.flatten.length == 4

  players = tournament.flatten.each_slice(2).to_a
  
  while players.length > 1
    players = players.each_slice(2).map { |x| rps_game_winner(x) }
  end
  
  players[0]
end
