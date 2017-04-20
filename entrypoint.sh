#!/bin/sh

SSR_PASS=${SSR_PASS:-SSRPassword}
SSR_METHOD=${SSR_METHOD:-chacha20-ietf}
SSR_OBFS=${SSR_OBFS:-tls1.2_ticket_auth}
SSR_OBFS_PARAM=${SSR_OBFS_PARAM:-bing.com}

KCP_PASS=${KCP_PASS:-KCPPassword}
KCP_MODE=${KCP_MODE:-fast2}
KCP_CRYPT=${KCP_CRYPT:-salsa20}

# Path Init
root_dir=${RUN_ROOT:-'/ssr'}
ssr_cli="${root_dir}/shadowsocks/server.py"
kcp_cli="${root_dir}/kcptun/server"
ssr_conf="${root_dir}/_shadowsocksr.json"
kcp_conf="${root_dir}/_kcptun.json"
cmd_conf="${root_dir}/_supervisord.conf"

# Gen ssr_conf
cat > ${ssr_conf} <<EOF
{
  "port_password":{
    "8300":{"protocol":"origin", "obfs": "plain"},
    "8322":{"protocol":"auth_sha1_v2"},
    "8344":{"protocol":"auth_sha1_v4"},
    "8355":{"protocol":"auth_aes128_md5"},
    "8311":{"protocol":"auth_aes128_sha1"}
  },
  "password": "${SSR_PASS}",
  "method": "${SSR_METHOD}",
  "obfs": "${SSR_OBFS}",
  "obfs_param": "${SSR_OBFS_PARAM}",
  "workers": 5
}
EOF

# Gen kcp_conf
cat > ${kcp_conf} <<EOF
{
  "key": "${KCP_PASS}",
  "crypt": "${KCP_CRYPT}",
  "mode": "${KCP_MODE}"
}
EOF

# Gen supervisord.conf
cat > ${cmd_conf} <<EOF
[supervisord]
nodaemon=true

[program:shadowsocks]
command=/usr/bin/python ${ssr_cli} -c ${ssr_conf}
autorestart=true
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0

$(
  sed -n 's/.*"\([0-9]*\)".*protocol.*/\1/p' ${ssr_conf} | sort -u |while read port; do
    echo "[program:kcptun-${port}]"
    echo "command=${kcp_cli} -c ${kcp_conf} -t 127.0.0.1:${port} -l :1${port}"
    echo "autorestart=true"
    echo "redirect_stderr=true"
    echo "stdout_logfile=/var/log/kcptun-${port}.log"
    echo ""
  done
)
EOF

/usr/bin/supervisord -c ${cmd_conf}
