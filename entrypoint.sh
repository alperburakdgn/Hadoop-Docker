#!/bin/bash

# SSH servisi başlatılmayacak çünkü root yetkisi yok ve gerek de yok

# Format işlemi sadece ilk çalıştırmada yapılmalı
if [[ "$HOSTNAME" == "namenode" && ! -d "/hadoop/dfs/name/current" ]]; then
    hdfs namenode -format
fi

# Hadoop servislerini başlat
if [[ "$HOSTNAME" == "namenode" ]]; then
    hdfs namenode && hdfs secondarynamenode && tail -f /dev/null
elif [[ "$HOSTNAME" == datanode* ]]; then
    hdfs datanode && tail -f /dev/null
fi
