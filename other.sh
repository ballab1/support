#!/bin/bash

declare start=$(date +%s)
export  CONTAINER_TAG="$( date +%Y%m%d )"
export  CBF_VERSION=dev
set -o verbose

cd ~/support

#docker-compose build base
#docker-compose build openjdk
#docker-compose build supervisord
#docker-compose build nginx_base
#docker-compose build php5
#docker-compose build php7

docker-compose build openjre
docker-compose build perl
docker-compose build carton
docker-compose build files-librd
docker-compose build files-kafka
docker-compose build movefiles
docker-compose build alpinefull
docker-compose build gradle
docker-compose build postgres



set +o verbose
declare finish=$(date +%s)
declare -i elapsed=$(( finish - start ))
printf "Time elapsed: %02d:%02d:%02d\n"  $((elapsed / 3600)) $((elapsed % 3600 / 60)) $((elapsed % 60)) 
