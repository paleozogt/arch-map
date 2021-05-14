# Architecture Mapper Utility

Architecture names are all over the place.

Take 32-bit arm:
 * [Docker](https://github.com/docker-library/official-images#architectures-other-than-amd64) calls it `arm32v7`
 * [Golang](https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63#a-list-of-valid-goarch-values) calls it `arm`
 * [Debian](https://www.debian.org/releases/stretch/i386/ch02s01.html.en) calls it `armhf`
 * Debian's [GCC](https://wiki.debian.org/Multiarch/Tuples#Used_solution) calls it `arm-linux-gnueabi`

If you're cross-compiling for multiple arches, managing all these names becomes complicated.  This script does that mapping, with input [Docker style](https://github.com/docker-library/official-images#architectures-other-than-amd64) (e.g., `arm32v7`).

The script is meant to be sourced, so that it can load env vars.  It uses the `ARCH` env var as its input.

## Sourcing directly

You can source it directly:
```
$ ARCH=arm32v7 . ./arch-map
$ echo DOCKER_ARCH=$DOCKER_ARCH
$ echo GOARCH=$GOARCH
$ echo DPKG_ARCH=$DPKG_ARCH
$ echo TRIPLET=$TRIPLET
DOCKER_ARCH=arm32v7
GOARCH=arm
DPKG_ARCH=armhf
TRIPLET=arm-linux-gnueabi
```

## In Dockerfiles

It's also really useful in Dockerfiles.  Here we source the script to let us know what cross-compiler (if any) to install:
```
FROM paleozogt/arch-map as archmap
FROM ubuntu

COPY --from=archmap /bin/arch-map /bin/arch-map

ARG ARCH
RUN . /bin/arch-map \
 && if [ "$(dpkg --print-architecture)" = "$DPKG_ARCH" ]; then \
       apt-get update && apt-get install -y \
              g++ \
    && rm -rf /var/lib/apt/lists/* \
  ; else \
       apt-get update && apt-get install -y \
              g++-$TRIPLET \
    && rm -rf /var/lib/apt/lists/* \
  ; fi
```

See the test folder for more examples of how the script can be used.

## Sourcing from Docker

You can also source it using Docker:
```
$ docker run --rm -it paleozogt/arch-map:0.1-arm32v7 | source /dev/stdin
$ echo DOCKER_ARCH=$DOCKER_ARCH
$ echo GOARCH=$GOARCH
$ echo DPKG_ARCH=$DPKG_ARCH
$ echo TRIPLET=$TRIPLET
DOCKER_ARCH=arm32v7
GOARCH=arm
DPKG_ARCH=armhf
TRIPLET=arm-linux-gnueabi
```
