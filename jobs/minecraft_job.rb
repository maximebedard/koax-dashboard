require_relative '../lib/minecraft'
require 'logger'
require 'timeout'

HOST = "70.83.22.14"
PORT = 25565

@logger = Logger.new "logs/minecraft.log"

@query = DashboardQueries::Minecraft.new(HOST, PORT)

current_ping = 999


SCHEDULER.every '5s', :first_in => 0 do |job|
	begin
		status = @query.get_status
  	send_event('numplayers', {
  		min: 0, 
  		max: status[:maxplayers], 
  		value: status[:numplayers] 
		})

  	last_ping= current_ping.to_i
  	current_ping = status[:delay].to_i

  	send_event('status', { image: '/minecraft_online.png' })
  	send_event('ping', { text: "#{current_ping} ms", moreinfo: "last : #{last_ping} ms" })
  rescue StandardError => e
  	@logger.error(e)
  	send_event('status', { image: '/minecraft_offline.png' })
    send_event('ping', { text: "Server Offline"})
  end

end