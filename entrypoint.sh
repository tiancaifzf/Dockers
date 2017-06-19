#!/bin/sh

echo "#Args: ${Args}"
echo '=================================================='
echo

# Path Init
root_dir=${RUN_ROOT:-'/ss2'}
ssr_cli="${root_dir}/go-ss2"

${ssr_cli} ${Args} -verbose
