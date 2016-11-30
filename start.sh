#!/bin/sh

SSR_PASS=${SSR_PASS:-shadowsocksPassword}
KCP_PASS=${KCP_PASS:-kcptunPassword}

sed "s/shadowsocksPassword/${SSR_PASS}/g" /etc/shadowsocks.json > /etc/shadowsocks_mod.json
sed "s/kcptunPassword/${KCP_PASS}/g" /etc/kcptun.json > /etc/kcptun_mod.json

/usr/bin/supervisord
