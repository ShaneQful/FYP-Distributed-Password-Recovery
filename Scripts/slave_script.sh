#!/bin/bash

# $1 count
# $2 filename
# $3 dictionary
# where the stuff to crack is : ./tocrack

./JohnTheRipper/run/john -wo:Dictionaries/$3_$1 tocrack
mkdir ~/$2/
mv output$1 ~/$2/
./JohnTheRipper/run/john --show tocrack > ~/$2/output$1
