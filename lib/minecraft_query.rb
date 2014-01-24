
require 'socket'
require 'timeout'


class MinecraftQuery
	MAGIC_TOKEN           = "\xFE\xFD"
	PACKET_TYPE_CHALLENGE = [9].pack('C')
	PACKET_TYPE_QUERY     = [0].pack('C')
	ID_TOKEN              = [0].pack('l>')

	def initialize(host, port, timeout=3, retries=3)
		@timeout = timeout
		@retries = 0
		@max_retries = retries
		@socket = UDPSocket.new :INET
		@socket.connect host, port
	end

	def get_status
		handshake() if @challenge.nil?
		
		send_packet PACKET_TYPE_QUERY, @challenge
		status = parse_status(read_packet())

		return status
	end

	def get_server_info
		handshake() if @challenge.nil?

		send_packet PACKET_TYPE_QUERY, @challenge + ID_TOKEN
		plugins = parse_server_info(read_packet())

		return plugins
	end

	def parse_status(packet)

		blocks = packet[:buffer].split("\x00")
		
		return {
			:motd => blocks[0],
			:gametype => blocks[1],
			:map => blocks[2],
			:numplayers => (blocks[3].to_i(10) rescue 0),
			:maxplayers => (blocks[4].to_i(10) rescue 0),
			:hostport => blocks[5][0,2].unpack('s<')[0],
			:hostname => blocks[5][2, blocks[5].size]
		}

	end

	def parse_server_info(packet)
		# TODO
		blocks = packet[:buffer].split("\x00")
		return {
			:temp => blocks
		}
	end

	def send_packet(type, data="")
		msg = MAGIC_TOKEN + type + ID_TOKEN + data
		@socket.send msg, 0
	end

	def read_packet
		Timeout::timeout(@timeout) do
			msg, addr = @socket.recvfrom(1460)
			return { 
				:type => msg[0].unpack('C'),
				:id => msg[1..5].unpack('l>'),
				:buffer => msg[5..msg.size]
			}	
		end
	end

	def handshake
		send_packet PACKET_TYPE_CHALLENGE
		begin
			packet = read_packet
			@challenge = [packet[:buffer].to_i].pack('l>').force_encoding('utf-8')
		rescue
			if @retries < @max_retries
				handshake()
			else
				raise
			end
		end
	end

	private :send_packet, 
		:read_packet, 
		:handshake, 
		:parse_status,
		:parse_server_info

end
