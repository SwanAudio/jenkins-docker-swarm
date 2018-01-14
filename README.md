<p align='center'>
  <a href='https://swanaudio.com'>
    <img src='https://swanaudio.com/assets/swan-audio-logo-final-alt.svg' height='130' alt='Swan Audio'>
  </a>
</p>

<p align='center'>
  <a href='https://hub.docker.com/r/swanaudio/jenkins-swarm-slave'>
    <img src='https://img.shields.io/docker/build/swanaudio/jenkins-swarm-slave.svg'>
  </a>
  <img src='https://img.shields.io/github/release-date/swanaudio/jenkins-docker-swarm.svg'>
</p>

A docker file for deploying jenkins swarm plugin agents, that have docker installed, to a docker swarm.

Usage
-----

Due to docker-swarm not supporting broadcast in overlay networking, the
name jenkins-master must be used for the master server.

Example compose file (should probably use nginx proxy to port 80 and
better secret management for real usage):

```
version: '3.5'
services:
  jenkins-master:
    image: jenkins/jenkins:lts
    volumes:
      - jenkins-data:/var/jenkins_home
    ports:
      - 50000:50000
      - target: 8080
        published: 8080
        protocol: tcp
        mode: host
    networks:
      - jenkins-network
      - bridge
  jenkins-agent:
    image: swanaudio/jenkins-swarm-slave
    networks:
      - jenkins-network
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    secrets:
      - jenkins-password
      - jenkins-username

networks:
  bridge:
    external: true
    name: bridge
  jenkins-network:
    driver: overlay
    attachable: true

volumes:
  jenkins-data:

secrets:
  jenkins-password:
    file: jenkinspw
  jenkins-username:
    file: jenkinsuser
```
