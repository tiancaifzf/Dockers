FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/ss2
ARG SS2_URL=https://github.com/riobard/go-shadowsocks2/releases/download/v0.0.9/shadowsocks2-linux-x64.gz
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v20170525/kcptun-linux-amd64-20170525.tar.gz
ARG TZ=Asia/Hong_Kong

RUN apk add --update --no-cache python libsodium wget supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ss2/go-ss2
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -qO- ${SS2_URL} | gzip -d > go-ss2 \
    && chmod +x go-ss2

# /ss2/kcptun/server
RUN mkdir -p ${RUN_ROOT}/kcptun \
    && cd ${RUN_ROOT}/kcptun \
    && wget -qO- ${KCP_URL} | tar xz \
    && rm client_* \
    && mv server_* server

ENV SS=ss://AEAD_AES_128_GCM:12345678

ENV KCP=kcp://fast2:aes: \
    KCP_EXTRA_ARGS=''

EXPOSE 8488/tcp 8488/udp 18488/udp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
