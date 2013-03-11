#!/bin/bash

# $1 count
# $2 filename
# $3 dictionary
# $4 number of slave nodes
# where the stuff to crack is : ./tocrack

if [ "$3" = "brute_force" ]; then
	./GenTheRipper/run/john --incremental=all -stdout | awk -v n=$1 -v s=$4 'NR % s == n' | ./JohnTheRipper/run/john --stdin tocrack
else
	./JohnTheRipper/run/john -wo:Dictionaries/$3_$1 tocrack
fi
mkdir ~/$2/
mv output$1 ~/$2/
./JohnTheRipper/run/john --show tocrack > ~/$2/output$1
