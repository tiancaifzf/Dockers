FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/ssr
ARG SSR_URL=https://github.com/shadowsocksr/shadowsocksr/archive/3.1.2.tar.gz
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v20170329/kcptun-linux-amd64-20170329.tar.gz
ARG TZ=Asia/Hong_Kong

RUN apk add --update --no-cache python libsodium wget supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ssr/shadowsocks/server.py
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -qO- ${SSR_URL} | tar xz \
    && mv shadowsocksr-*/shadowsocks shadowsocks \
    && rm -rf shadowsocksr-*

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT}/kcptun \
    && cd ${RUN_ROOT}/kcptun \
    && wget -qO- ${KCP_URL} | tar xz \
    && rm client_* \
    && mv server_* server

ENV SSR_PASS=SSRPassword \
    SSR_OBFS=tls1.2_ticket_auth \
    SSR_OBFS_PARAM=bing.com \
    SSR_METHOD=chacha20-ietf

ENV KCP_PASS=KCPPassword \
    KCP_MODE=fast2 \
    KCP_CRYPT=salsa20

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
