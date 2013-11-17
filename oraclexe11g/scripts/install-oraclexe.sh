#!/bin/sh

if [ -f /etc/init.d/oracle-xe ]; then
    echo "Oracle XE 11g is already installed"
    exit 0
fi

if [ ! -f /vagrant/files/oracle-xe-11.2.0-1.0.x86_64.rpm ]; then
    echo "Oracle XE installer file not found in files directory"
    exit 1
fi

ORACLE_PORT=1521
ORACLE_APEX_PORT=8080
ORACLE_PASSWORD=system

SWAP_FILE=/tmp/swapfile

dd if=/dev/zero of=$SWAP_FILE bs=1024 count=1572864
mkswap $SWAP_FILE
swapon $SWAP_FILE
swapon -a

swapon -s
rpm -ivh /vagrant/files/oracle-xe-11.2.0-1.0.x86_64.rpm

swapoff $SWAP_FILE
rm -f $SWAP_FILE
swapon -s

cat > xe.rsp <<EOF
$ORACLE_APEX_PORT
$ORACLE_PORT
$ORACLE_PASSWORD
$ORACLE_PASSWORD
y
EOF

/etc/init.d/oracle-xe configure < xe.rsp > xeinstall.log

iptables -I INPUT 5 -p tcp --dport $ORACLE_PORT -j ACCEPT
iptables -I INPUT 6 -p tcp --dport $ORACLE_APEX_PORT -j ACCEPT
/sbin/service iptables save
