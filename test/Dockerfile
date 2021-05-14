ARG DISTRO=bionic
FROM paleozogt/arch-map as archmap
FROM ubuntu:$DISTRO

COPY --from=archmap /bin/arch-map /bin/arch-map

# tools
RUN apt-get update && apt-get install -y \
       file \
       golang-go \
 && rm -rf /var/lib/apt/lists/*

# cross-compiler
ARG ARCH
RUN . /bin/arch-map \
 && if [ "$(dpkg --print-architecture)" = "$DPKG_ARCH" ]; then \
       apt-get update && apt-get install -y \
              g++ \
              gccgo \
    && rm -rf /var/lib/apt/lists/* \
  ; else \
       apt-get update && apt-get install -y \
              g++-$TRIPLET \
              gccgo-$TRIPLET \
    && rm -rf /var/lib/apt/lists/* \
  ; fi

# foreign architecture repos
RUN . /bin/arch-map \
 && . /etc/os-release \
 && if [ "$(dpkg --print-architecture)" != "$DPKG_ARCH" ]; then \
       dpkg --add-architecture $DPKG_ARCH \
    && if [ "i386" != "$DPKG_ARCH" ] && [ "ppc64" != "$DPKG_ARCH" ]; then \
          sed -i "s~deb ~deb [arch=$(dpkg --print-architecture)] ~g" /etc/apt/sources.list \
       && echo "deb [arch=$DPKG_ARCH] http://ports.ubuntu.com/ubuntu-ports/ $VERSION_CODENAME main" >> /etc/apt/sources.list \
        ; fi \
  ; fi

# test downloading foreign arch packages
RUN . /bin/arch-map \
 && if [ "$(dpkg --print-architecture)" = "$DPKG_ARCH" ]; then \
       apt-get update && apt-get download \
              file \
    && rm -rf /var/lib/apt/lists/* \
  ; elif [ "ppc64" != "$DPKG_ARCH" ]; then \
       apt-get update && apt-get download \
              file:$DPKG_ARCH \
    && rm -rf /var/lib/apt/lists/* \
  ; fi

# test GOARCH
RUN . /bin/arch-map \
 && echo "package main\nfunc main() {}" > helloworld.go \
 && if [ "$GOARCH" = "ppc" ]; then \
      $TRIPLET-gccgo helloworld.go -o helloworld \
  ; else \
      go build -o helloworld \
  ; fi \
 && file helloworld
