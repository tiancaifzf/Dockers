#!/bin/sh

# Path Init
root_dir=${RUN_ROOT:-'/opt'}
cmd_conf="${root_dir}/_supervisord.conf"

cmdArgs="$*"
if [ -n "$cmdArgs" ]; then
  ${root_dir}/gost -logtostderr -v=5 $cmdArgs
  exit 0
fi

Args=${Args:--L=:8080}

cat > ${cmd_conf} <<EOF
[supervisord]
nodaemon=true

[program:gost]
command=${root_dir}/gost ${Args} > /dev/null
autorestart=true

EOF

/usr/bin/supervisord -c ${cmd_conf}
