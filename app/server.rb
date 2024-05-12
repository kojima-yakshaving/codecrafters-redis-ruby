require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.new(server.accept) do |client|
        until client.eof?
          client.write("+PONG\r\n") if client.gets.chomp == 'PING'
        end

        client.close
      end
    end
  end
end

YourRedisServer.new(6379).start
