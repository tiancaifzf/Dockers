FROM alpine:edge
MAINTAINER CHENHW2 <https://github.com/chenhw2>

RUN apk update \
    && apk add python libsodium unzip wget \
    && rm -rf /var/cache/apk/*

RUN mkdir /ssr \
    && cd /ssr \
    && wget --no-check-certificate https://github.com/shadowsocksr/shadowsocksr/archive/manyuser.zip -O /tmp/manyuser.zip \
    && unzip -d /tmp /tmp/manyuser.zip \
    && mv /tmp/shadowsocksr-manyuser/shadowsocks /ssr/shadowsocks \
    && rm -rf /tmp/*

ADD shadowsocks.json /etc/shadowsocks.json

RUN \
    apk add --no-cache --virtual .build-deps curl \
    && mkdir -p /opt/kcptun \
    && cd /opt/kcptun \
    && curl -fSL https://github.com/xtaci/kcptun/releases/download/v20170221/kcptun-linux-amd64-20170221.tar.gz | tar xz \
    && rm client_linux_amd64 \
    && cd ~ \
    && apk del .build-deps \
    && apk add --no-cache supervisor

ADD kcptun.json /etc/kcptun.json

COPY supervisord.conf /etc/supervisord.conf

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
