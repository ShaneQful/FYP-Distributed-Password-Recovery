#!/bin/bash

# $1 master_ip
# $2 count
# $3 filename
# where the stuff to crack is : ./tocrack

# echo $4 > tocrack
./JohnTheRipper/run/john -wo:~/Dictionaries/$4_$2 tocrack
mkdir ~/$3/
mv output$2 ~/$3/
./JohnTheRipper/run/john --show tocrack > ~/$3/output$2
