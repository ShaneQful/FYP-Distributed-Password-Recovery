#!/usr/bin/ruby

require "open3"

#global variables
$results_folder = "Cracked"

def bash input
#     puts input.inspect #debugging purposes
	streams = Open3.popen3 input
	out = ""
	while((line=streams[1].gets) != nil)
		out += line
	end
	return out
end

def check_for_files slave_ips, file_name
    finished = false
    while !finished do 
        slave_ips.each do |s|
            bash "scp pi@#{s}:~/#{file_name}/* ~/#{$results_folder}/#{file_name}/"
        end
        password = bash "cat ~/#{$results_folder}/#{file_name}/* | grep :" #either empty or filename:password
        how_many_done =  bash("ls -l ~/#{$results_folder}/#{file_name}/ | wc -l").to_i - 1
        finished = password.include?(":") || (how_many_done >= slave_ips.size)
        sleep 5 # Can change this depending on what the overhead is
    end
    kill_john slave_ips
    return password
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
file_name = ARGV[0].split("/")[-1]
# =begin
what_ever2john = bash "ls ~/JohnTheRipper/run/*2john* | grep #{ARGV[1]}"
what_ever2john = what_ever2john.split("/")[-1]
what_ever2john = what_ever2john.chomp
# Have to calculate .. to directory or find a better way
bash "cd ~/JohnTheRipper/run/; ./#{what_ever2john} #{ARGV[0]} > tocrack"
# bash "cd ~/JohnTheRipper/run/; ./john -wo:all tocrack"
# sleep 2
# puts(bash "cd ~/JohnTheRipper/run/; ./john -show tocrack")
count = 0
bash "mkdir ~/#{$results_folder}"
bash "mkdir ~/#{$results_folder}/#{file_name}"
slave_ips.each do |s|
	bash "scp ~/JohnTheRipper/run/tocrack pi@#{s}:~/ &" #blocking
end
slave_ips.each do |s|
   Open3.popen3 "cat slave_script.sh | ssh pi@#{s} bash -s - #{master_ip} #{count} #{file_name} &"
   count += 1
end
# =end
puts check_for_files(slave_ips, file_name).split(":")[-1]
