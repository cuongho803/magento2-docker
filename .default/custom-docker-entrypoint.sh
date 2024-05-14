#!/bin/bash

output=$(cat /etc/os-release)

if [ "$(echo "$output" | grep 'ID=debian')" ]; then
    echo "debian"
    update-ca-certificates
elif [ "$(echo "$output" | grep 'ID=ubuntu')" ]; then
    echo "ubuntu"
    update-ca-certificates
else
    echo "Unknown distribution"
fi

ORIGIN_DOCKER_ENTRYPOINT="/docker-entrypoint.sh"

# ps -ef | grep php-fpm

# echo "param: $@"
# echo "path entrypoint: $ORIGIN_DOCKER_ENTRYPOINT"
# bash -x $ORIGIN_DOCKER_ENTRYPOINT "$@"
bash $ORIGIN_DOCKER_ENTRYPOINT "$@"