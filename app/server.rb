require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def handle(input)
    puts input
  end

  def start
    server = TCPServer.new(@port)
    loop do
      # Thread.new(server.accept) do |client|
        client = server.accept
        rbuf = client.read
        translated = handle(rbuf)
        

        client.close
      # end
    end
  end
end

YourRedisServer.new(6379).start
