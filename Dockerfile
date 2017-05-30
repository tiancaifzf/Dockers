FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/ssr
ARG SSR_URL=https://github.com/shadowsocksr/shadowsocksr/archive/92722c2ea96c0fa59a4c8e182d3993cdf018f361.zip
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v20170525/kcptun-linux-amd64-20170525.tar.gz
ARG TZ=Asia/Hong_Kong

RUN apk add --update --no-cache python libsodium wget unzip supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ssr/shadowsocks/server.py
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -q ${SSR_URL} \
    && unzip *.zip \
    && mv shadowsocksr-*/shadowsocks shadowsocks \
    && rm -rf shadowsocksr-* *.zip

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT}/kcptun \
    && cd ${RUN_ROOT}/kcptun \
    && wget -qO- ${KCP_URL} | tar xz \
    && rm client_* \
    && mv server_* server

ENV SSR=ssr://origin:aes-256-cfb:tls1.2_ticket_auth_compatible:12345678 \
    SSR_OBFS_PARAM=bing.com \
    SSR_PROTOCOL_PARAM=''

ENV KCP=kcp://fast2:aes: \
    KCP_EXTRA_ARGS=''

EXPOSE 8388/tcp 8388/udp 18388/udp

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
