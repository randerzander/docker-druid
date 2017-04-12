FROM centos

RUN yum install -y wget
RUN yum install -y java-1.8.0-openjdk-devel
ADD scripts /scripts

#ZooKeeper setup
ARG ZOOKEEPER_URL
ARG ZOOKEEPER_SUBFOLDER
RUN sh /scripts/ADD.sh ZOOKEEPER
RUN cp /zookeeper/conf/zoo_sample.cfg /zookeeper/conf/zoo.cfg

#Druid setup
ARG DRUID_URL
ARG DRUID_SUBFOLDER
RUN sh /scripts/ADD.sh DRUID

# Tranquility setup
ARG TRANQUILITY_URL
ARG TRANQUILITY_SUBFOLDER
RUN sh /scripts/ADD.sh TRANQUILITY

ADD data /data
ADD conf /druid/conf

CMD sh /scripts/start.sh
