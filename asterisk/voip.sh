
#NOTE: One might need to update the version as current might not always point to version 13.26.0

echo "Building Asterisk from source"
cd ~
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz
apt-get update
#add keystrokes if necessary
apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev libjansson-dev
#can add keystrokes

tar -zxvf asterisk-13-current.tar.gz
cd asterisk-13.26.0
./configure
make
make install
make samples
cd ~
cp ~quickSetup/asterisk/init.d/asterisk /etc/init.d/asterisk

useradd -d /var/lib/asterisk asterisk
#add password keystrokes if necessary
chown -R asterisk /var/spool/asterisk /var/lib/asterisk /var/run/asterisk
cp ~quickSetup/asterisk/default/asterisk /etc/default/asterisk
update-rc.d asterisk default

echo "Setting up config files"
mv /etc/asterisk/sip.conf /etc/asterisk/sip.conf.orig
mv /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.orig
cp ~quickSetup/asterisk/sip.conf /etc/asterisk/sip.conf
cp ~quickSetup/asterisk/extensions.conf /etc/asterisk/extensions.conf

echo "Lets run Asterisk"
/etc/init.d/asterisk start

