require_relative 'war_game'

games = []

100.times do
  game = WarGame.new
  game.start
  until game.winner do
    puts game.play_round
  end
  puts "Winner: #{game.winner.name}"
  games << game
end

win_ratio = "Win Ratio | #{games.select { |game| game.winner.name == "Player 1" }.count}%"
average_rounds = "Average Rounds | #{games.map(&:rounds).reduce(0) { |sum, num| sum + num }/games.count}"

puts win_ratio
puts average_rounds