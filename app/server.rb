require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    while (client = server.accept)
      until client.eof?
        client.write("+PONG\r\n") if client.gets.chomp == 'PING'
      end
    end
    client.close
  end
end

YourRedisServer.new(6379).start
