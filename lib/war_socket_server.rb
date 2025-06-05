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

  def accept_new_client(player_name=nil)
    client = @server.accept_nonblock


    unless player_name
      message_client(client, "Please input your name:")
      until player_name
        sleep(0.2)
        begin
          player_name = client.read_nonblock(1000).chomp
        rescue IO::WaitReadable
        end
      end
    end

    # player_name = request_player_name_from(client) until player_name
    
    players << WarPlayer.new(player_name,[],client)
    clients << client
    
    message_client(client, "Welcome to war #{player_name}!")
    message_all_clients("Waiting for players...") unless clients.count > 1
  rescue IO::WaitReadable, Errno::EINTR
  end

  def create_game_if_possible
    return unless players.count == 2

    message_all_clients("We're ready to start")
    message_all_clients("#{players.first.name} vs #{players[1].name}")
    message_all_clients("Press any key to continue:")

    game = WarGame.new(players)
    games << game
    game.start
  end

  def run_game(game)
    until game.winner
      run_round(game)
    end
    clients.each { |client| client.puts "#{game.winner} is the winner!" }
  end

  def run_round(game)
    get_client_input

    if responses.count > 1 || !needs_client_input
      round_results = game.play_round
      responses.clear
      message_all_clients("\n#{round_results}\n")
      message_all_clients("Press any key to continue:")
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

  def request_player_name_from(client)
    message_client(client, "Please input your name:")
    until player_name
      sleep(0.2)
      begin
        client.read_nonblock(1000).chomp
      rescue IO::WaitReadable
      end
    end
  end

  def get_client_input
    clients.each do |client|
      sleep(0.1) if needs_client_input
      begin
        responses << client.read_nonblock(1000)
      rescue IO::WaitReadable
      end
    end
  end
end