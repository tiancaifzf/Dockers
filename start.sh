#!/bin/sh

SSR_PASS=${SSR_PASS:-shadowsocksPassword}
KCP_PASS=${KCP_PASS:-kcptunPassword}

sed -i "s/shadowsocksPassword/${SSR_PASS}/g" /etc/shadowsocks.json
sed -i "s/kcptunPassword/${KCP_PASS}/g" /etc/kcptun.json

/usr/bin/supervisord
