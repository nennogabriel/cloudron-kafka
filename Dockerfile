# Use the Cloudron base image as the starting point
FROM cloudron/base:4.0.0@sha256:31b195ed0662bdb06a6e8a5ddbedb6f191ce92e8bee04c03fb02dd4e9d0286df

ARG KAFKA_VERSION=3.3.2
ARG SCALA_VERSION=2.13.8

RUN apt-get update && apt-get install default-jdk -y

# Install necessary packages
RUN apt-get update && apt-get install -y zookeeperd

# Download and extract Apache Kafka
RUN wget https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka-$KAFKA_VERSION-src.tgz && \
    tar -xzf kafka-$KAFKA_VERSION-src.tgz && \
    rm kafka-$KAFKA_VERSION-src.tgz && \
    mv kafka-$KAFKA_VERSION-src /kafka && \
    cd /kafka && \
    ./gradlew jar -PscalaVersion=$SCALA_VERSION

RUN ln -s kafka-$KAFKA_VERSION-src kafka

ENV PATH /kafka/bin:$PATH
ENV KAFKA_ADVERTISED_LISTENERS "PLAINTEXT://localhost:9092,PLAINTEXT_HOST://localhost:29092"
ENV KAFKA_LISTENER_SECURITY_PROTOCOL_MAP "PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT"
ENV KAFKA_BROKER_ID=1
ENV KAFKA_ZOOKEEPER_CONNECT=localhost:2181
ENV KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1

# Expose the necessary ports for Apache Kafka
EXPOSE 2181 29092 9092

# Start Apache Kafka
CMD /kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties & \
    /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
