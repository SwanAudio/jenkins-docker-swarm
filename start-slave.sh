#!/usr/bin/env sh
set -e

java -jar swarm-client.jar -fsroot /home/jenkins -executors 2 -master http://jenkins-master:8080 -username $(cat /run/secrets/jenkins-username) -password $(cat /run/secrets/jenkins-password)
