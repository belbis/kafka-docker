FROM ubuntu:trusty

MAINTAINER belbis

##############################
#         Dockerfile         #
# builds an image on ubuntu  #
# trusty 14.04 that can run  #
# a kafka broker             #
##############################

# for download and start of kafka later on
ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.11"

# let upstart know were in a container
ENV container docker

# ensure java && docker installed
RUN apt-get update
RUN apt-get install -y default-jdk wget curl git
#RUN wget -qO- https://get.docker.com/ | sh

# add the download script to docker; run download
ADD kafka-download.sh /tmp/kafka-download.sh
RUN /tmp/kafka-download.sh


# extract kafka
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

# ensure kafka volume recognized
VOLUME ["/kafka"]

# set kafka env
ENV KAFKA_HOME=/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

# ensure custom scripts in bin
ADD kafka-server-start.sh /usr/bin/kafka-server-start.sh
ADD broker-list.sh /usr/bin/broker-list.sh
CMD kafka-server-start.sh

# expose port
EXPOSE 9092
