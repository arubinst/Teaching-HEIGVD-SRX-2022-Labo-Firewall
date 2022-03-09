#!/bin/bash
#
# openlan.sh
#
# Get rid of all the mess 
# created by the lab
# WARNING : this will delete all the lab files !

docker-compose down
yes | docker image prune -a
yes | docker builder prune
yes | docker network prune
