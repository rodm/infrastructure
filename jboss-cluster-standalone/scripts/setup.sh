#!/bin/sh

grep "192.168.32.20" /etc/hosts > /dev/null
if [ "$?" = "1" ]; then
    sudo cat >> /etc/hosts <<EOF
192.168.32.20   webserver.localdomain webserver
192.168.32.31   appserver1.localdomain appserver1
192.168.32.32   appserver2.localdomain appserver2
192.168.32.33   appserver3.localdomain appserver3
EOF
fi

case "`hostname -s`" in
    webserver*)
        sh -x /vagrant/scripts/setup-webserver.sh
        ;;
    appserver*)
        sh -x /vagrant/scripts/setup-appserver.sh
        ;;
esac
