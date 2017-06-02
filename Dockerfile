FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

ENV RUN_ROOT=/frp
ARG FRP_URL=https://github.com/fatedier/frp/releases/download/v0.11.0/frp_0.11.0_linux_amd64.tar.gz
ARG TZ=Asia/Hong_Kong

RUN apk add --update --no-cache wget supervisor ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /ssr/kcptun/server
RUN mkdir -p ${RUN_ROOT}/conf \
    && cd ${RUN_ROOT} \
    && wget -qO- ${FRP_URL} | tar xz \
    && mv frp_*/frpc client \
    && mv frp_*/frps server \
    && mkdir conf_tpl \
    && mv frp_*/*.ini conf_tpl/ \
    && rm frp_* -rf

VOLUME /frp/conf

ENV Args=server

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
