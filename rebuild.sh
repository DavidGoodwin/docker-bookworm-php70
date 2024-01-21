#!/bin/bash

OUT=$(mktemp)

exec 1>$OUT 2>$OUT

set -xu

cd $(dirname $0)

docker login -u davidgoodwin -p $(< .docker.pass)


# --build-arg=http_proxy="http://192.168.86.66:3128" \
# --build-arg=https_proxy="http://192.168.86.66:3128" \

docker build \
    --rm \
    -t davidgoodwin/debian-bookworm-php70:latest \
    -t davidgoodwin/debian-bookworm-php70:$(date +%F) \
    --pull \
    .
RETVAL=$?

if [ $RETVAL -ne 0 ]; then
    exec 1>/dev/stderr
    echo "Problems building? docker build returned: $RETVAL"
    cat $OUT
    exit 1
fi





docker push davidgoodwin/debian-bookworm-php70:$(date +%F)
docker push davidgoodwin/debian-bookworm-php70:latest




