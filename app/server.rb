require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.new(server.accept) do |session|
        connection = RedisConnection.new(session)
        until connection.eof?
          connection.execute_command
        end

        connection.close
      end
    end
  end
end


class RedisConnection
  def initialize(session)
    @session = session
  end

  def execute_command
    command, *params = handle_input
    if command == "ECHO"
      body = params.join(' ')
      writeline("$#{body.size}\r\n#{body}\r\n")
    elsif command == "PING"
      writeline("+PONG\r\n")
    end
  end

  def readline
    @session.gets.chomp
  end

  def eof?
    @session.eof?
  end

  def writeline(...)
    @session.puts(...)
  end

  def handle_input
    _, *args = readline.chars
    args_count = args.join.to_i

    argv = []
    args_count.times do 
      _ = readline
      argv << readline
    end

    argv
  end

  def close 
    @session.close
  end
end

YourRedisServer.new(6379).start
