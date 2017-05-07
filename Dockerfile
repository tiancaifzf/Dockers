FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/frp
ARG KCP_URL=https://github.com/fatedier/frp/releases/download/v0.9.3/frp_0.9.3_linux_amd64.tar.gz

RUN apk add --update --no-cache wget supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT}/conf \
    && cd ${RUN_ROOT} \
    && wget -qO- ${KCP_URL} | tar xz \
    && mv frp_*/frpc client \
    && mv frp_*/frpc_min.ini conf/client.ini \
    && mv frp_*/frps server \
    && mv frp_*/frps_min.ini conf/server.ini \
    && rm frp_*_amd64 -rf

VOLUME /frp/conf

ENV Args=server

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
