FROM centos

RUN yum install -y wget
RUN yum install -y java-1.8.0-openjdk-devel

#ZooKeeper setup
ARG ZOOKEEPER_URL=https://archive.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
ARG ZOOKEEPER_SUBFOLDER=zookeeper-3.4.6
RUN wget ${ZOOKEEPER_URL} -O /zookeeper.tgz
RUN tar -xzvf /zookeeper.tgz
RUN mv /${ZOOKEEPER_SUBFOLDER} /zookeeper
RUN cp /zookeeper/conf/zoo_sample.cfg /zookeeper/conf/zoo.cfg

#Druid setup
ARG DRUID_URL=http://static.druid.io/artifacts/releases/druid-0.9.2-bin.tar.gz
ARG DRUID_SUBFOLDER=druid-0.9.2
RUN wget ${DRUID_URL} -O /druid.tgz
RUN tar -xzvf /druid.tgz
RUN mv /${DRUID_SUBFOLDER} /druid

# Tranquility setup
ARG TRANQUILITY_URL=http://static.druid.io/tranquility/releases/tranquility-distribution-0.8.0.tgz
ARG TRANQUILITY_SUBFOLDER=tranquility-distribution-0.8.0
RUN wget ${TRANQUILITY_URL} -O /tranquility.tgz
RUN tar -xzvf /tranquility.tgz
RUN mv ${TRANQUILITY_SUBFOLDER} /tranquility

ADD conf /druid/conf
ADD scripts /scripts

CMD sh /scripts/start.sh
