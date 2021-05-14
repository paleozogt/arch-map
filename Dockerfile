ARG ARCH
FROM paleozogt/busybox:1.33.1-glibc-$ARCH
ARG ARCH

ADD arch-map /bin/

ENV ARCH=$ARCH
ENV ARCHMAP_PRINT=1
CMD sh /bin/arch-map
