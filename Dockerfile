#
# Dockerfile for shadowsocks-libev and simple-obfs
#

FROM alpine:3.5

ARG TZ=Asia/Hong_Kong
ARG SS_VER=3.0.6
ARG SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz
ARG OBFS_VER=0.0.3
ARG OBFS_URL=https://github.com/shadowsocks/simple-obfs/archive/v$OBFS_VER.tar.gz

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD      chacha20-ietf-poly1305
ENV TIMEOUT     120
ENV DNS_ADDR    8.8.8.8
ENV DNS_ADDR_2  8.8.4.4
ENV ARGS=

RUN set -ex && \
    apk add --update --no-cache wget ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

RUN set -ex && \
    apk add --update --no-cache --virtual \
                                .build-deps \
                                autoconf \
                                automake \
                                build-base \
                                curl \
                                libev-dev \
                                libtool \
                                linux-headers \
                                udns-dev \
                                libsodium-dev \
                                mbedtls-dev \
                                openssl-dev \
                                pcre-dev \
                                tar \
                                udns-dev && \

    cd /tmp && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \

    cd /tmp && \
    curl -sSL $OBFS_URL | tar xz --strip 1 && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    cd .. && \

    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \

    apk del --purge \
                    .build-deps \
                    autoconf \
                    automake \
                    build-base \
                    curl \
                    libev-dev \
                    libtool \
                    linux-headers \
                    udns-dev \
                    libsodium-dev \
                    mbedtls-dev \
                    openssl-dev \
                    pcre-dev \
                    tar \
                    udns-dev && \
    rm -rf /tmp/* /var/cache/apk/*

USER nobody

EXPOSE $SERVER_PORT/tcp $SERVER_PORT/udp

CMD ss-server -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT \
              --fast-open \
              -d $DNS_ADDR \
              -d $DNS_ADDR_2 \
              -u \
              $ARGS
