#!/bin/bash

# Ortam değişkenlerini tanımla
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# SSH servisini başlat (root olarak çalışmalı)
service ssh start

# hadoop kullanıcısı ile çalıştırılacak script bloğu
su - hadoop -c "
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=\$PATH:\$JAVA_HOME/bin

# Eğer NameNode isek ve daha önce formatlanmamışsa formatla
if [[ \"\$HOSTNAME\" == \"namenode\" && ! -d \"/hadoop/dfs/name/current\" ]]; then
    hdfs namenode -format
fi

# Servise göre doğru bileşeni başlat
if [[ \"\$HOSTNAME\" == \"namenode\" ]]; then
    hdfs namenode && hdfs secondarynamenode && tail -f /dev/null
elif [[ \"\$HOSTNAME\" == datanode* ]]; then
    hdfs datanode && tail -f /dev/null
fi
"
