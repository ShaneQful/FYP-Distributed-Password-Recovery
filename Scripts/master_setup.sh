#!/bin/bash

wget http://openwall.com/john/g/john-1.7.9-jumbo-7.tar.gz
tar -xf john-1.7.9-jumbo-7.tar.gz
# only if still necessary 
wget https://raw.github.com/magnumripper/JohnTheRipper/unstable-jumbo/src/office_fmt_plug.c
mv office_fmt_plug.c john-1.7.9-jumbo-7/src/
cd john-1.7.9-jumbo-7/src
make clean
make generic # arm if i get the make file done
cd ../../
tar cvzf john.tar.gz john-1.7.9-jumbo-7/
mv john.tar.gz public_html/ #Or whatever other web dir it is
#assume dns router
for i in {1..9}
do
	ssh pi@rogue$i 'bash -s' < slave_setup.sh # fairly sure i insertion is wrong
done

