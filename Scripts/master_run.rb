#!/usr/bin/ruby

require "open3"

#global variables
$results_folder = "Cracked"

def bash input
	streams = Open3.popen3 input
	out = ""
	while((line=streams[1].gets) != nil)
		out += line
	end
	return out
end

def check_for_files slave_ips, filename
	Thread.new do 
		finshed = false
		while !finished do 
			slave_ips.each do |s|
				bash "scp pi@#{s}:~/#{filename}/* ~/#{$results_folder}/#{file_name}/"
			end
			sleep 5
			password = bash "cat ~/#{$results_folder}/#{file_name}/* | grep :" #either empty or filename:password
			how_many_done =  bash("ls -l ~/#{$results_folder}/#{file_name}/ | wc -l").to_i - 1
			finished = password.include?(":") || (how_many_done >= slave_ips.size)
		end
		kill_john slave_ips
		Thread.exit
	end
end

def kill_john slave_ips
	slave_ips.each do |s|
		bash "ssh pi@#{s} \"killall john\""
	end
end
# ARGV[0] file to crack
# ARGV[1] format
# ARGV[2] wordlist

#May want to abstract this so it can work on a list from a file or DNS
master_ip = bash("ifconfig -v | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'")
master_ip = master_ip.split("\n")[0] # If there multiple interfaces take the first
#Need to be root for arp scan to work but I don't want to give it root either find a 
#way to add it to some user group like wireshark or don't use it.
slave_ips = bash "cat pis" 
slave_ips = slave_ips.scan /\d{3}\.\d{3}\.\d+\.\d+/ #first + may not be neccessary
slave_ips.delete master_ip
=begin
if(wordlist.is_new)
	split dictionary
end
=end
input_for_john = bash("python ~/JohnTheRipper/run/#{ARGV[1]}2john.py #{ARGV[0]} >tocrack") #Could be .pl or ...
count = 0
file_name = ARGV[0].split("/")[-1]
bash "mkdir ~/#{$results_folder}"
bash "mkdir ~/#{$results_folder}/#{file_name}"
slave_ips.each do |s|
# 	bash "scp test_#{count} pi@#{s}:~/"
	bash "scp tocrack pi@#{s}:~/"
	bash "cat slave_script.sh | ssh pi@#{s} bash -s - #{master_ip} #{count} #{file_name} &"
	count += 1
end