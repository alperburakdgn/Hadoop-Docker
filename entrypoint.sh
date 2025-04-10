#!/bin/bash

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin


export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root

# Start SSH service
service ssh start

# Format only if namenode dir is empty
if [[ "$HOSTNAME" == "namenode" && ! -d "/hadoop/dfs/name/current" ]]; then
    hdfs namenode -format
fi



# Start Hadoop daemons
if [[ "$HOSTNAME" == "namenode" ]]; then
    start-dfs.sh && tail -f /dev/null
else
    hdfs datanode && tail -f /dev/null
fi
