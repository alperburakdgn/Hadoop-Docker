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
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin

# hadoop kullanıcısı oluştur
RUN groupadd -r hadoop && useradd -ms /bin/bash -g hadoop hadoop

# Gerekli dizinleri oluştur ve sahipliğini ver
RUN mkdir -p /hadoop/dfs/name /hadoop/dfs/data /run/sshd && \
    chown -R hadoop:hadoop /opt/hadoop /hadoop /home/hadoop && \
    chmod 755 /run/sshd

# Hadoop konfigürasyon dosyaları ve entrypoint
COPY config/* $HADOOP_HOME/etc/hadoop/
COPY config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown hadoop:hadoop /entrypoint.sh

# Varsayılan kullanıcıyı hadoop yap
USER hadoop

# Entrypoint
CMD ["/entrypoint.sh"]
