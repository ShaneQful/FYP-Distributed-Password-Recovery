#This should be changed for your own network setup
for i in $(nmap -sP 192.168.1.30-45 | grep -o -P "\d+\.\d+\.\d+.\d+"); 
do
	scp pi@$i:~/$1/* ~/Cracked/$1/ &
done
