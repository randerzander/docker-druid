#!/bin/bash -eu

export ZOOKEEPER_HOME=/zookeeper
export DRUID_HOME=/druid
export TRANQUILITY_HOME=/tranquility

$ZOOKEEPER_HOME/bin/zkServer.sh start

cd $DRUID_HOME
./bin/init

java `cat conf-quickstart/druid/historical/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/historical:lib/*" io.druid.cli.Main server historical > historical.log & 2>&1
java `cat conf-quickstart/druid/broker/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/broker:lib/*" io.druid.cli.Main server broker > broker.log & 2>&1
java `cat conf-quickstart/druid/coordinator/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/coordinator:lib/*" io.druid.cli.Main server coordinator > coordinator.log & 2>&1 
java `cat conf-quickstart/druid/overlord/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/overlord:lib/*" io.druid.cli.Main server overlord > overlord.log & 2>&1
java `cat conf-quickstart/druid/middleManager/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/middleManager:lib/*" io.druid.cli.Main server middleManager > middleManager.log & 2>&1

cd $TRANQUILITY_HOME
./bin/tranquility server -configFile $DRUID_HOME/conf/tranquility/server.json > tranquility.log & 2>&1
sleep 5
tail -f tranquility.log
