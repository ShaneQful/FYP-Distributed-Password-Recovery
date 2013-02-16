#!/bin/bash

cd ~/
tar cvzf john.tar.gz JohnTheRipper
for i in $(nmap -sP 192.168.1.30-45 | grep -o -P "\d+\.\d+\.\d+.\d+");
do
	if [ "$1" != "$i" ] ; then
		scp john.tar.gz pi@$i:~/
		ssh pi@$i "rm -rf JohnTheRipper"
		ssh pi@$i "tar -xf john.tar.gz"
		echo "Test $i"
		ssh pi@$i "./JohnTheRipper/run/john -t -fo:odf"
	fi
done
