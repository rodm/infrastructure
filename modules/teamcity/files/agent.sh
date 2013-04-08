#!/bin/sh
#
# Startup script for TeamCity Build Agent
#
# description: Run TeamCity Build Agent
# processname: agent

PRGDIR=`dirname $0`
TEAMCITY_HOME=`cd $PRGDIR/.. ; pwd`
TEAMCITY_CONF=$TEAMCITY_HOME/conf
HOSTNAME=`hostname -s`

AGENT_DIR=$TEAMCITY_HOME/agent
AGENT_CONF=$TEAMCITY_HOME/conf/agent

if [ ! -f $TEAMCITY_CONF/$HOSTNAME.conf ]; then
    echo "No configuration file found for this host '$HOSTNAME'"
    exit 1
fi
. $TEAMCITY_CONF/$HOSTNAME.conf

JAVA_OPTS=-Dteamcity-agent
#JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true"

if [ ! -f $AGENT_CONF/$HOSTNAME.properties ]; then
    echo "No agent properties file found for this host '$HOSTNAME'"
    exit 1
fi
CONFIG_FILE=$AGENT_CONF/$HOSTNAME.properties
#LOG_DIR=
TZ=Europe/London

export JAVA_HOME JAVA_OPTS
export CATALINA_HOME CATALINA_BASE
export CONFIG_FILE TZ

if [ ! -x $AGENT_DIR/bin/agent.sh ]; then
    echo "TeamCity Agent script must have execute permission set"
    exit 1
fi
cd $AGENT_DIR/bin
exec ./agent.sh $*

