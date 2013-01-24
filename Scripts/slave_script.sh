#!/bin/bash

# $1 master_ip
# $2 count
# $3 filename
# where the stuff to crack is : ./tocrack

./JohnTheRipper/run/john -wordlist:test_$2 tocrack
./JohnTheRipper/run/john -show tocrack > output$2
mkdir ~/$3/
mv output$2 ~/$3/
