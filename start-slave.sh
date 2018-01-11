#!/usr/bin/env sh
set -e

java -jar swarm-client.jar -fsroot /home/jenkins/workspace -executors 2 $(cat /run/secrets/jenkins-password)
