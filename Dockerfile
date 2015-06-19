FROM ubuntu:trusty

MAINTAINER belbis

# for download and start of kafka later on
ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.11"

# let upstart know were in a container
ENV container docker

# ensure java && docker installed
RUN apt-get update
RUN apt-get install -y unzip openjdk-8-jdk
RUN wget curl git docker.io jq

# add the download script
ADD kafka-download.sh /tmp/kafka-download.sh
RUN /tmp/download-kafka.sh

# extract kafka
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

# ensure kafka volume recognized
VOLUME ["/kafka"]

# set kafka env
ENV KAFKA_HOME=/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

# ensure custom scripts in bin
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
CMD start-kafka.sh

# expose port
EXPOSE 9092
