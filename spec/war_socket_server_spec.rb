require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
    @server.start
    sleep 0.2 # Ensure server is ready for clients
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    @server.stop
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  context 'with one client' do
    let(:client1) { MockWarSocketClient.new(@server.port_number) }

    before do
      @clients.push(client1)
      @server.accept_new_client("Player 1")
    end

    describe '#create_game_if_possible' do
      it 'returns nil if only one player' do
          expect(@server.create_game_if_possible).to eq nil
      end
    end
  end

  context 'with two clients' do
    let(:client1) { MockWarSocketClient.new(@server.port_number) }
    let(:client2) { MockWarSocketClient.new(@server.port_number) }

    before do
      @clients.push(client1)
      @server.accept_new_client("Player 1")

      @clients.push(client2)
      @server.accept_new_client("Player 2")
    end

    describe '#accept_new_client' do
      it "accepts both clients" do
        expect(@server.clients.count).to be 2
      end

      it 'sends a welcome message to each client' do
        expect(client1.capture_output).to match /welcome/i
      end
    end

    describe '#create_game_if_possible' do
      it 'returns a WarGame' do
        expect(@server.create_game_if_possible).to respond_to :deck
      end

      it 'sends a start message to all clients when ready to start' do
        client1.capture_output
        client2.capture_output

        @server.create_game_if_possible
        
        expect(client1.capture_output).to match /start/i
        expect(client2.capture_output).to match /start/i
      end
    end

    describe '#run_round' do
      it 'does not play the round unless clients give input' do
        game = @server.create_game_if_possible
        
        expect {
          @server.run_round(game)
        }.to_not change(game, :rounds)
      end

      it 'plays the round once clients give input' do
        game = @server.create_game_if_possible
        client1.provide_input('ready')
        client2.provide_input('ready')
        
        expect {
          @server.run_round(game)
        }.to change(game, :rounds).by 1
      end
    end
  end

  #TODO: Write tests for run_game
  
  # it "doesn't start the game until both players input" do
  #   client1 = MockWarSocketClient.new(@server.port_number)
  #   @clients.push(client1)
  #   @server.accept_new_client("Player 1")

  #   client2 = MockWarSocketClient.new(@server.port_number)
  #   @clients.push(client2)
  #   @server.accept_new_client("Player 2")

  #   @server.create_game_if_possible

  #   expect(@server.games.first.rounds).to eq 0
  # end

  # it "starts the game until both players input" do
  #   client1 = MockWarSocketClient.new(@server.port_number)
  #   @clients.push(client1)
  #   @server.accept_new_client("Player 1")

  #   client2 = MockWarSocketClient.new(@server.port_number)
  #   @clients.push(client2)
  #   @server.accept_new_client("Player 2")

  #   client1.provide_input('message')
  #   client2.provide_input('message')

  #   @server.create_game_if_possible

  #   expect(@server.games.first.rounds).to eq 1
  # end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end