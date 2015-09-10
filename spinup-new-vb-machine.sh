#!/usr/bin/env bash

command -v docker-machine &>/dev/null
if [ $? != 0 ]; then
    echo "This script requires the docker-machine command"
    exit 1
fi

mac_name="$1"
if [ -z "$mac_name" ]; then
    mac_name="dns-local"
fi

docker-machine create \
               --driver virtualbox \
               --virtualbox-disk-size "20000" \
               --virtualbox-memory "384" \
               "$mac_name"
