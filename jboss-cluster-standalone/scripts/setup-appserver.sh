#!/bin/sh

JDK=jdk1.7.0_45
JDK_PATH=/vagrant/files/jdk-7u45-linux-x64.tar.gz
JBOSS=jboss-as-7.1.1.Final
JBOSS_URL=http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip

# Install packages required to run as an appserver
yum -y clean all
yum -y install wget

iptables -I INPUT 5 -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT 6 -p tcp --dport 8009 -j ACCEPT
iptables -I INPUT 7 -p udp -d 224.0.1.0/24 -j ACCEPT
iptables --line-numbers -L INPUT -n
/sbin/service iptables save

# Install Java and JBoss AS 7.1
mkdir -p /opt
cd /opt
if [ ! -d /opt/$JDK ]; then
#    wget -q --no-proxy JDK_URL -P /vagrant/files
    tar xf $JDK_PATH -C /opt
fi
if [ ! -d /opt/$JBOSS ]; then
    if [ ! -f /vagrant/files/${JBOSS}.zip ]; then
        wget -q --no-proxy $JBOSS_URL -P /vagrant/files
    fi
    unzip -q /vagrant/files/${JBOSS}.zip -d /opt
    ln -s /opt/${JBOSS} /opt/jboss
fi

export JAVA_HOME=/opt/jdk1.7.0_45
export JBOSS_HOME=/opt/jboss
${JBOSS_HOME}/bin/add-user.sh --silent=true admin admin123

IPADDR=$(hostname -I | sed -e "s/.*\(192\..*\)/\1/")
#${JBOSS_HOME}/bin/standalone.sh -c standalone-full-ha.xml -b ${IPADDR} -bmanagement ${IPADDR} &
${JBOSS_HOME}/bin/standalone.sh -c standalone-full-ha.xml -b ${IPADDR} -Djboss.socket.binding.port-offset=0 &
sleep 15
${JBOSS_HOME}/bin/jboss-cli.sh --file=/vagrant/config/modcluster.cli
