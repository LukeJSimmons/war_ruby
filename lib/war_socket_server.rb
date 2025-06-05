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

  def accept_new_client(player_name="Random Player")
    client = @server.accept_nonblock

    unless player_name
      message_client(client, "Please input your name:")
      name = client.read_nonblock(1000)
      message_client(client, "Hi #{name}!") if name
    end

    players << WarPlayer.new(player_name,[],client)
    clients << client
    message_client(client, "Welcome to war!")
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    # puts "No client to accept"
  end

  def create_game_if_possible
    message_all_clients("Waiting for players...")
    return unless players.count == 2

    message_all_clients("We're ready to start")

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
        client.puts "Press any key to continue:"
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

  private

  def message_client(client, message)
    client.puts message
  end

  def message_all_clients(message)
    clients.each { |client| client.puts message }
  end
end