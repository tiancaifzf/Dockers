FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/ss2
ARG SS2_URL=https://github.com/riobard/go-shadowsocks2/releases/download/v0.0.9/shadowsocks2-linux-x64.gz
ARG TZ=Asia/Hong_Kong

RUN apk add --update --no-cache wget ca-certificates tzdata gzip \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ss2/go-ss2
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -qO- ${SS2_URL} | gzip -d > go-ss2 \
    && chmod +x go-ss2

EXPOSE 8488/tcp 8488/udp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
