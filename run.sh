#!/usr/bin/env bash

script_path () {
    local scr_path=""
    local dir_path=""
    local sym_path=""
    # get (in a portable manner) the absolute path of the current script
    scr_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && scr_path=$scr_path/$(basename -- "$0")
    # if the path is a symlink resolve it recursively
    while [ -h $scr_path ]; do
        # 1) cd to directory of the symlink
        # 2) cd to the directory of where the symlink points
        # 3) get the pwd
        # 4) append the basename
        dir_path=$(dirname -- "$scr_path")
        sym_path=$(readlink $scr_path)
        scr_path=$(cd $dir_path && cd $(dirname -- "$sym_path") && pwd)/$(basename -- "$sym_path")
    done
    echo $scr_path
}

script_dir=$(dirname -- "$(script_path)")

# see: http://www.damagehead.com/blog/2015/04/28/deploying-a-dns-server-using-docker/
#      https://github.com/sameersbn/docker-bind

if [ -z "$1" ]; then
    echo "Please provide a name for the container, e.g. dns-local"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Please provide a root password for webmin"
    exit 1
fi

cd $script_dir
mkdir -p bind-data

docker run \
       -d \
       --dns=127.0.0.1 \
       --env="ROOT_PASSWORD=$2" \
       --name=$1 \
       --publish=53:53/udp --publish=10000:10000 \
       --volume=$script_dir/bind-data:/data \
       sameersbn/bind@sha256:951c6635c0476682871fdf6bdb5ae5e2749fc6f2f42ee3e14fbb85c3203302d4

docker logs -f $1
