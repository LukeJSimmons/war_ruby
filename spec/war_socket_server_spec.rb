require_relative 'spec_helper'

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
    @output = @socket.read_nonblock(150000) # not gets which blocks
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
    sleep 0.1 # Ensure server is ready for clients
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
    end

    describe '#accept_new_client' do
      it 'asks for client player name' do
         client1.provide_input('jim')
        @server.accept_new_client
        expect(client1.capture_output). to match (/name/i)
      end

      it 'client can send player name' do
        client1.provide_input('jim')
        @server.accept_new_client
        expect(client1.capture_output).to match (/jim/i)
      end
    end

    describe '#message_client' do
      it 'can send a message to client' do
        @server.accept_new_client("Player 1")
        expect(client1.capture_output). to match (/welcome/i)
      end
    end


    describe '#create_game_if_possible' do
      it 'returns nil if only one player' do
          @server.accept_new_client("Player 1")
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
        expect(client1.capture_output).to match (/welcome/i)
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
        
        expect(client1.capture_output).to match (/start/i)
        expect(client2.capture_output).to match (/start/i)
      end

      it 'displays names to all clients when ready to start' do
        client1.capture_output
        client2.capture_output

        @server.create_game_if_possible
        
        expect(client1.capture_output).to match (/Player 2/i)
        expect(client2.capture_output).to match (/Player 1/i)
      end
    end

    describe '#run_game' do
      before do
        @server.needs_client_input = false
      end

      it 'displays round info message' do
        client1.provide_input("\n")
        client2.provide_input("\n")
        game = @server.create_game_if_possible

        expect {
          @server.run_game(game)
        }.to change(client1, :capture_output).to match (/took/i)
      end

      it 'displays winner message' do
        game = @server.create_game_if_possible

        expect {
          @server.run_game(game)
        }.to change(client1, :capture_output).to match (/winner/i)
      end
    end

    describe '#run_round' do
      it 'does not play the round unless clients give input' do
        game = @server.create_game_if_possible
        
        expect {
          @server.run_round(game)
        }.to_not change(game, :rounds)
      end

      it 'plays the round once both clients give input' do
        game = @server.create_game_if_possible
        client1.provide_input('ready')
        client2.provide_input('ready')
        
        expect {
          @server.run_round(game)
        }.to change(game, :rounds).by 1
      end
      it 'does not play the round if only one client inputs twice' do
        game = @server.create_game_if_possible
        client1.provide_input('first')
        client1.provide_input('second')
        
        expect {
          @server.run_round(game)
        }.to_not change(game, :rounds)
      end

      it 'adds client1 input to responses' do
        game = @server.create_game_if_possible
        client1.provide_input('first')
        
        expect {
          @server.run_round(game)
        }.to change(@server, :responses).to ["first\n"]
      end

      it 'adds client2 input to responses' do
        game = @server.create_game_if_possible
        client2.provide_input('first')
        
        expect {
          @server.run_round(game)
        }.to change(@server, :responses).to ["first\n"]
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