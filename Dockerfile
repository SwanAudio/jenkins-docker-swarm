# Since there is no reason to have curl on the final image, use a multi-stage
# build to pull down the latest swarm client without needing the dependency.
FROM alpine:latest

ENV SWARM_CLIENT 3.8

WORKDIR /

RUN apk add --no-cache curl
RUN curl -fL -o swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$SWARM_CLIENT/swarm-client-$SWARM_CLIENT.jar
RUN apk del curl

# ---

FROM openjdk:alpine

LABEL maintainer="evan@swanaudio.com"

RUN apk add --no-cache docker

RUN addgroup -S jenkins && adduser -S -g jenkins -G docker jenkins
USER jenkins

WORKDIR /home/jenkins

COPY --from=0 --chown=jenkins:jenkins /swarm-client.jar .
COPY --chown=jenkins:jenkins start-slave.sh /home/jenkins

VOLUME /home/jenkins/workspace

EXPOSE 33848/udp

ENTRYPOINT ["./start-slave.sh"]
