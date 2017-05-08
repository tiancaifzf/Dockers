FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/frp
ARG KCP_URL=https://raw.githubusercontent.com/chenhw2/Dockers/FRP/frp_static_0.9.3_linux_amd64.tar.gz
ARG TZ=Asia/Hong_Kong

RUN apk add --update --no-cache wget supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT}/conf \
    && cd ${RUN_ROOT} \
    && wget -qO- ${KCP_URL} | tar xz \
    && mv frpc_linux_amd64 client \
    && mv frps_linux_amd64 server \
    && mv conf conf_tpl \
    && rm frp_*_amd64 -rf

VOLUME /frp/conf

ENV Args=server

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
