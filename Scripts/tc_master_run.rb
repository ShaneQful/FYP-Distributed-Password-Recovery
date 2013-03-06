require 'test/unit'
require 'master_run.rb'

class TC_Master_Run < Test::Unit::TestCase
	def setup
		
	end
	
	def test_bash
		assert(bash("echo test") == "test\n", "That's not what bash would do")
	end
	
	def test_grab_password
		assert(grab_password("/home/pi/WebUI/test-security.pdf:security") == "security", "Not grabbing the password")
		assert(grab_password("/home/eve/WebUI/alice's-data.odt:unsecure") == "unsecure", "Not grabbing the password")
		assert(grab_password("/home/eve/WebUI/bob's-data.docx:test:::jkds::fkjds::sadas") == "test:::jkds::fkjds::sadas", "Not grabbing the password")
	end
	
	def test_get_slaves
		$get_slaves_bash = "echo 192.168.1.2"
		assert(get_slaves(nil) == ["192.168.1.2"], "Not getting any slaves")
		assert(get_slaves("192.168.1.2") == [], "Our client is a slave :(")
		$get_slaves_bash = "echo -e \"shajda\nwkjsa\n192.168.1.78\nasjdha192.168.1.4\n192.168.1.2\""
		assert(get_slaves("192.168.1.2").size == 2, "There a different number of slaves than there should be")
	end
end