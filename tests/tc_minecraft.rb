
require_relative '../lib/minecraft'
require 'test/unit'
require 'pp'
 
class TestMinecraftQuery < Test::Unit::TestCase
 
	DEFAULT_HOST = "70.83.22.14"
	DEFAULT_PORT = 25565

  def test_get_status
    status = DashboardQueries::Minecraft.new(DEFAULT_HOST, DEFAULT_PORT).get_status

    assert_equal("A Minecraft Server", status[:motd])
    assert_equal("SMP", status[:gametype])
    assert_equal("world", status[:map])
    assert_equal(0, status[:numplayers])
    assert_equal(20, status[:maxplayers])
  end

  def test_get_server_info
  	server_info = DashboardQueries::Minecraft.new(DEFAULT_HOST, DEFAULT_PORT).get_server_info
  	
  end
 
end