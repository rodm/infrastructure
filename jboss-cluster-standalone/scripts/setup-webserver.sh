#!/bin/sh

CLUSTER_FILE=mod_cluster-1.2.6.Final-linux2-x64-so.tar.gz
MODCLUSTER_URL=http://downloads.jboss.org/mod_cluster//1.2.6.Final/linux-x86_64/$CLUSTER_FILE

# Install packages required to run as a webserver
yum -y clean all
yum -y install wget
yum -y install httpd

# Install and configure mod_cluster
mkdir -p /vagrant/files
if [ ! -f /vagrant/files/$CLUSTER_FILE ]; then
    wget --no-proxy $MODCLUSTER_URL -O /vagrant/files/$CLUSTER_FILE
fi

tar -xzf /vagrant/files/$CLUSTER_FILE -C /usr/lib64/httpd/modules/

cp /vagrant/config/modcluster.conf /etc/httpd/conf.d

# Disable proxy balancer module
sed -i -e "s/^\(LoadModule proxy_balancer_module.*\)/#\1/" /etc/httpd/conf/httpd.conf

# Allow connections
iptables -I INPUT 5 -p tcp --dport 80 -j ACCEPT
iptables -I INPUT 6 -p tcp --dport 7000 -j ACCEPT
iptables --line-numbers -L INPUT -n
/sbin/service iptables save

/etc/init.d/httpd start
