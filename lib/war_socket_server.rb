require 'socket'
require_relative 'war_game'
require_relative 'war_player'

class WarSocketServer
  def initialize
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
    players << WarPlayer.new
    clients << client
    client.puts "Welcome to war!"
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    return unless players.count == 2

    game = WarGame.new
    game.start
    games << game
    clients.each { |client| client.puts "War is starting..." }
    begin
      sleep(0.1)
      input = clients.first.read_nonblock(1000)
    rescue IO::WaitReadable
    end
    input
    # game.play_round
  end

  def stop
    @server.close if @server
  end
end