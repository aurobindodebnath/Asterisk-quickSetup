#!/bin/bash

#NOTE: This script must be run as root.

echo "Welcome to Setting up asterisk!!!"


#check if root
if [[ $EUID -ne 0 ]]; then
echo "This script must be run as root! Exiting ..."
exit 1
fi

echo "Step 1: DOWNLOADING ASTERISK"
cd ~
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz

echo "Step 2: UPDATING AND INSTALLING ESSENTIAL PACKAGES"
apt-get update
#add keystrokes if necessary
apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev libjansson-dev
#can add keystrokes

echo "STEP 3: UNZIPPING ASTERISK"
tar -zxvf asterisk-13-current.tar.gz
x=`ls -d */|grep "ast"`
cd $x

echo "STEP 4: CONFIGURING AND INSTALLING ASTERISK"
./configure
make
make install
make samples
cd ~
cp ~/quickSetup/asterisk/init.d/asterisk /etc/init.d/asterisk

echo "STEP 5: MANAGING USERS AND PERMISSION"
useradd -d /var/lib/asterisk asterisk
#add password keystrokes if necessary
chown -R asterisk /var/spool/asterisk /var/lib/asterisk /var/run/asterisk

echo "STEP 6: COPYING AND MOVING ESSENTIAL FILES"
cp ~/quickSetup/asterisk/default/asterisk /etc/default/asterisk
update-rc.d asterisk default
mv /etc/asterisk/sip.conf /etc/asterisk/sip.conf.orig
mv /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.orig
cp ~/quickSetup/asterisk/sip.conf /etc/asterisk/sip.conf
cp ~/quickSetup/asterisk/extensions.conf /etc/asterisk/extensions.conf

echo "STEP 7: RUNNING ASTERISK"
/etc/init.d/asterisk start

