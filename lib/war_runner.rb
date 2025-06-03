require_relative 'war_game'

show_output = true
total_games = 1000
games = []

puts "Do you want to show the game output?"
input = gets.chomp
show_output = input == 'yes' ? true : false

puts "How many games would you like it to play?"
total_games = gets.chomp.to_i

total_games.times do
  game = WarGame.new
  game.start
  if show_output
    puts game.play_round until game.winner
    puts "Winner: #{game.winner.name}"
  else
    game.play_round until game.winner
  end
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
