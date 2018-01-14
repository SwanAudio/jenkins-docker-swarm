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

WORKDIR /home/jenkins

COPY --from=0 /swarm-client.jar .
COPY start-slave.sh /home/jenkins

# Workaround for https://github.com/moby/moby/issues/2259
RUN mkdir -p /home/jenkins/workspace

# Backport support for docker 17.06 (version used on docker hub)
RUN chown -R jenkins:jenkins /home/jenkins

VOLUME /home/jenkins/workspace

USER jenkins

# The automatic host discovery feature of jenkins-swarm cannot currently
# be used with docker-swarm w/ overlay networking, due to:
# https://github.com/docker/libnetwork/issues/552
EXPOSE 33848/udp

ENTRYPOINT ["./start-slave.sh"]
