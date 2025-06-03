require_relative 'war_game'

total_games = 1000
games = []

total_games.times do
  game = WarGame.new
  game.start
  puts game.play_round until game.winner
  puts "Winner: #{game.winner.name}"
  games << game
end

win_ratio = "Win Ratio | #{(games.select { |game| game.winner.name == 'Player 1' }.count)/(total_games/100).to_f}%"
average_rounds = "Average Rounds | #{games.map(&:rounds).reduce(0) { |sum, num| sum + num } / games.count}"
most_rounds = "Most Rounds | #{games.map(&:rounds).max}"
infinite_games = "Infinite Games | #{(games.select { |game| game.rounds > 5000 }.count)/(total_games/100).to_f}%"

puts win_ratio
puts average_rounds
puts most_rounds
puts infinite_games
