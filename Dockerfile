FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/opt
ARG BIN_URL=https://github.com/ginuerzh/gost/releases/download/v2.4-dev/gost_2.4-dev20170303_linux_amd64.tar.gz

RUN apk add --update --no-cache wget supervisor ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

# some package in gost need glibc
RUN wget -qO /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk \
    && apk add glibc-2.25-r0.apk

# /opt/gost
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -qO- ${BIN_URL} | tar xz \
    && mv gost_*/gost gost \
    && rm -rf gost_*

ENV Args="-L=:8080"

ADD entrypoint.sh ${RUN_ROOT}/entrypoint.sh
RUN chmod +x ${RUN_ROOT}/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
