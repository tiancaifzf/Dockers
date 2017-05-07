#!/bin/sh

# Path Init
root_dir=${RUN_ROOT:-'/frp'}
cmd_conf="${root_dir}/_supervisord.conf"

cmdArgs="$*"
if [ -n "$cmdArgs" ]; then
  ( ${root_dir}/${cmdArgs} ) || echo "choose [frps] or [frpc] to run"
  exit 0
fi

if [ -z "${Args}" ]; then
  echo "set ENV:Args to run"
  exit 0
fi

# Gen supervisord.conf
cat > ${cmd_conf} <<EOF
[supervisord]
nodaemon=true

[program:frp]
command=${root_dir}/${Args} -c ${root_dir}/conf/${Args}.conf
autorestart=true
redirect_stderr=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0

EOF

/usr/bin/supervisord -c ${cmd_conf}
