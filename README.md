# Debian Bookworm with PHP 7.0

Why? Well ... legacy reasons I guess.

You wouldn't/shouldn't use this for anything 'new'.

## Features 

 * PHP 7.0 via deb.sury.org
 * Apache mod\_php
 
See also: https://hub.docker.com/r/davidgoodwin/debian-bookworm-php70/


## Building

```bash
# If you have squid somewhere, uncomment and move these into the build step below:
#    --build-arg=http_proxy="http://192.168.86.66:3128" \
#    --build-arg=https_proxy="http://192.168.86.66:3128" \
docker build \
    --rm \
    -t davidgoodwin/debian-bookworm-php70:latest \
    -t davidgoodwin/debian-bookworm-php70:$(date +%F) \
    --pull \
    .


docker push davidgoodwin/debian-bookworm-php70:$(date +%F)
docker push davidgoodwin/debian-bookworm-php70:latest
```

