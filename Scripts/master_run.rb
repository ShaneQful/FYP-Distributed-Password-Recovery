#!/usr/bin/ruby

require "open3"

#global variables
$results_folder = "Cracked"
#$get_slaves_bash = "nmap -sP 192.168.1.30-45" 
#arp-scan would be faster but needs root or own user group
$get_slaves_bash = "cat ~/WebUI/Scripts/pis"

def bash input
	puts input.inspect #debugging purposes
	streams = Open3.popen3 input
	out = ""
	while((line=streams[1].gets) != nil)
		out += line
	end
	return out
end

#Neccesary in the case that password contains
def grab_password with_file_name
	out = ""
	c = 0
	with_file_name.split(":").each do |i|
		if(c > 0)
			out << i+":"
		end
		c += 1
	end
	out = out[0..-2]
	return out
end

def check_for_files slave_ips, file_name
	finished = false
	while !finished do
		grab_files_bash = "" 
		slave_ips.each do |s|
			grab_files_bash += "scp pi@#{s}:~/#{file_name}/* ~/#{$results_folder}/#{file_name}/ &"
		end
		bash grab_files_bash[0 .. -2]
		password = bash "cat ~/#{$results_folder}/#{file_name}/* | grep :" #either empty or filename:password
		how_many_done =  bash("ls -l ~/#{$results_folder}/#{file_name}/ | wc -l").to_i - 1
		finished = password.include?(":") || (how_many_done >= slave_ips.size)
		sleep 5 # Can change this depending on what the overhead is
	end
	kill_john slave_ips
	if(password.include?(":")) 
		return grab_password(password)
	else
		return "Password not found, that or someone chose this rather clever password :P"
	end
end

def kill_john slave_ips
	slave_ips.each do |s|
		bash "ssh pi@#{s} \"killall john\""
	end
end

def get_slaves client_ip
	master_ip = bash("ifconfig -v | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'")
	master_ip = master_ip.split("\n")[0] # If there multiple interfaces take the first
	slave_ips = bash $get_slaves_bash
	slave_ips = slave_ips.scan /\d{3}\.\d{3}\.\d+\.\d+/ #first + may not be neccessary
	slave_ips.delete master_ip
	slave_ips.delete client_ip
end

def run_attack file_to_crack, doc_format, dictionary, client_ip
	slave_ips = get_slaves(client_ip)
	file_name = file_to_crack.split("/")[-1]
	what_ever2john = bash "ls ~/JohnTheRipper/run/*2john* | grep #{doc_format}"
	what_ever2john = what_ever2john.split("/")[-1]
	what_ever2john = what_ever2john.chomp
	bash "cd ~/JohnTheRipper/run/; ./#{what_ever2john} #{file_to_crack} > tocrack"
	count = 0
	bash "mkdir ~/#{$results_folder}"
	bash "mkdir ~/#{$results_folder}/#{file_name}"
	multi_slave_bash = ""
	slave_ips.each do |s|
		multi_slave_bash += "scp ~/JohnTheRipper/run/tocrack pi@#{s}:~/ &" #blocking
	end
	bash multi_slave_bash
	slave_ips.each do |s|
		Open3.popen3 "cat ~/WebUI/Scripts/slave_script.sh | ssh pi@#{s} bash -s - #{count} #{file_name} #{dictionary}"
		count += 1
	end
	puts check_for_files(slave_ips, file_name)
end
# ARGV[0] file to crack
# ARGV[1] format
# ARGV[2] wordlist
# ARGV[3] client ip to ignore
if __FILE__ == $0
	if(ARGV[0] &&  ARGV[1] && ARGV[2])
		run_attack ARGV[0], ARGV[1], ARGV[2], ARGV[3]
	else
		puts DATA.read
	end
end
__END__
Usage:
ruby master_run.rb filetocrack, format, wordlistname, (optional) iptoignore

This program is tested to work with ruby 1.9.3. If you are using another version,
especially a previous version of ruby. You may encounter issues. Please don't the
developer responsable and use a supported version of the language. 

ARGV[0] file to crack
ARGV[1] format
ARGV[2] wordlist
ARGV[3] client ip to ignore

