require 'socket'
require_relative 'war_game'
require_relative 'war_player'

class WarSocketServer
  attr_accessor :needs_client_input, :responses

  def initialize
    @needs_client_input = true
    @responses = []
  end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def players
    @players ||= []
  end

  def clients
    @clients ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    players << WarPlayer.new(player_name)
    clients << client
    client.puts "Welcome to war!"
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    # puts "No client to accept"
  end

  def create_game_if_possible
    return unless players.count == 2

    clients.each { |client| client.puts "We're ready to start" }

    game = WarGame.new
    game.start
    games << game
    game
  end

  def run_game(game)
    until game.winner
      run_round(game)
    end
    clients.each { |client| client.puts "#{game.winner} is the winner!" }
  end

  def run_round(game)
    clients.each do |client|
      sleep(0.1) if needs_client_input
      begin
        responses << client.read_nonblock(1000)
      rescue IO::WaitReadable
      end
    end

    if responses.count > 1 || !needs_client_input
      round_results = game.play_round
      responses.clear
      clients.each { |client| client.puts round_results }
    end
  end

  def stop
    @server.close if @server
  end
end