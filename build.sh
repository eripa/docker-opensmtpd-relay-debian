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
        docker build -q -t eripa/opensmtpd-relay-debian:${arch} -f Dockerfile-arm .
        docker push eripa/opensmtpd-relay-debian:${arch}
    else
      docker build -q -t eripa/opensmtpd-relay-debian:${arch} -f Dockerfile .
      docker tag eripa/opensmtpd-relay-debian:${arch} eripa/opensmtpd-relay-debian:latest
      docker push eripa/opensmtpd-relay-debian:${arch}
      docker push eripa/opensmtpd-relay-debian:latest
    fi
  done
)
