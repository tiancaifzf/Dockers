FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/kcp
ARG KCP_URL=https://github.com/xtaci/kcptun/releases/download/v20170329/kcptun-linux-amd64-20170329.tar.gz

RUN apk add --update --no-cache wget supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT} \
    && cd ${RUN_ROOT} \
    && wget -qO- ${KCP_URL} | tar xz \
    && mv client_* client \
    && mv server_* server

ENV Args=server

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
