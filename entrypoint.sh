#!/bin/sh

# ss://cipher:pass
# SS=${SS:-ss://AEAD_AES_128_GCM:12345678}

# kcp://mode:crypt:key
# KCP=${KCP:-kcp://fast2:aes:}
# KCP_EXTRA_ARGS=${KCP_EXTRA_ARGS:-''}

echo "#CONFIG: ${SS}@:8488"
echo "#CONFIG: ${KCP} ${KCP_EXTRA_ARGS}"
echo '=================================================='
echo

# Path Init
root_dir=${RUN_ROOT:-'/ss2'}
ssr_cli="${root_dir}/go-ss2"
kcp_cli="${root_dir}/kcptun/server"
ss2_port=8488

# Gen kcp_conf
kcp2cmd(){
  kcp=$1
  kcp_extra_agrs=$2
  cmd='--mode \1 --crypt \2'
  cli=$(echo ${kcp} | sed "s#kcp://\([^:]*\):\([^:]*\):\([^:]*\).*#${cmd}#g")
  key=$(echo ${kcp} | sed "s#kcp://\([^:]*\):\([^:]*\):\([^:]*\).*#\3#g")
  [ "Z${key}" = 'Z' ] || cli=$(echo "${cli} --key ${key}")
  echo "${cli} ${kcp_extra_agrs}"
}

kcp_cmd=$(kcp2cmd ${KCP} ${KCP_EXTRA_ARGS})


( ${ssr_cli} -s ${SS}@:8488 -verbose ) &

${kcp_cli} -t 127.0.0.1:${ss2_port} -l :1${ss2_port} ${kcp_cmd}
