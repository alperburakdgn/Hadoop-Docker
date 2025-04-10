FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Java ve gerekli paketler
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk wget ssh rsync vim iputils-ping net-tools

# Hadoop kurulumu
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz && \
    tar -xzf hadoop-3.3.5.tar.gz -C /opt && \
    mv /opt/hadoop-3.3.5 /opt/hadoop && \
    rm hadoop-3.3.5.tar.gz

ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# SSH ayarları
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

COPY config/* $HADOOP_HOME/etc/hadoop/
COPY config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
