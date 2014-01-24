
require_relative 'minecraft_query'
require 'test/unit'
require 'pp'
 
class TestMinecraftQuery < Test::Unit::TestCase
 
	DEFAULT_HOST = "localhost"
	DEFAULT_PORT = 25566

  def test_get_status
    query = MinecraftQuery.new DEFAULT_HOST, DEFAULT_PORT
    status = query.get_status

    assert_equal("A Minecraft Server", status[:motd])
    assert_equal("SMP", status[:gametype])
    assert_equal("world", status[:map])
    assert_equal(0, status[:numplayers])
    assert_equal(20, status[:maxplayers])
  end

  def test_get_server_info
  	query = MinecraftQuery.new DEFAULT_HOST, DEFAULT_PORT
  	query.get_server_info
  end
 
end