FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Gerekli paketler
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk wget ssh rsync vim iputils-ping net-tools

# Hadoop indir ve kur
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz && \
    tar -xzf hadoop-3.3.5.tar.gz -C /opt && \
    mv /opt/hadoop-3.3.5 /opt/hadoop && \
    rm hadoop-3.3.5.tar.gz

# Ortam değişkenleri
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# hadoop kullanıcı ve grup oluştur
RUN groupadd -r hadoop && useradd -ms /bin/bash -g hadoop hadoop

# Hadoop dizinlerine sahiplik ver
RUN mkdir -p /hadoop/dfs/name /hadoop/dfs/data && \
    chown -R hadoop:hadoop /hadoop && \
    chown -R hadoop:hadoop $HADOOP_HOME

# SSH ayarları (hadoop kullanıcısı için)
USER hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

USER root  # SSH servisi root ile başlatılmalı

# Hadoop konfigürasyon dosyalarını kopyala
COPY config/* $HADOOP_HOME/etc/hadoop/
COPY config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Varsayılan komut
CMD ["/entrypoint.sh"]
