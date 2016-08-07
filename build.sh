#!/bin/bash
set -euo pipefail

script_dir=$(dirname "$0")
qemu_user_static_version="v2.6.0"

(
  cd "$script_dir"
  for arch in armv7 intel ; do
    echo "Building for ${arch}: opensmtpd-relay-debian:${arch}"
    if [ "$arch" == "armv7" ] ; then
        if [ ! -f qemu-arm-static ] ; then
          curl -LO "https://github.com/multiarch/qemu-user-static/releases/download/${qemu_user_static_version}/x86_64_qemu-arm-static.tar.gz"
          tar xfvz "x86_64_qemu-arm-static.tar.gz"
          /bin/rm -f "x86_64_qemu-arm-static.tar.gz"
        fi
        docker build -q -t opensmtpd-relay-debian:arm -f Dockerfile-arm .
    else
      docker build -q -t opensmtpd-relay-debian:intel -f Dockerfile .
    fi
  done
)
