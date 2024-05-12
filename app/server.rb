require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    client = server.accept
    until client.eof?
      client.gets
      client.write("+PONG\r\n")
    end
    client.close
  end
end

YourRedisServer.new(6379).start
