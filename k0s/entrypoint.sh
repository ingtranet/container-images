#!/bin/sh

# From https://github.com/k0sproject/k0s/blob/6eb4d3030ea9f0b3558021848b759cb68b7ba465/docker-entrypoint.sh

# Ensure we have some semi-random machine-id
if [ ! -f  /etc/machine-id ]; then
    dd if=/dev/urandom status=none bs=16 count=1 | md5sum | cut -d' ' -f1 > /etc/machine-id
fi

# Network fixups adapted from kind: https://github.com/kubernetes-sigs/kind/blob/master/images/base/files/usr/local/bin/entrypoint#L176
docker_embedded_dns_ip='127.0.0.11'
# first we need to detect an IP to use for reaching the docker host
docker_host_ip="$(ip -4 route show default | cut -d' ' -f3)"
dns_server=${DNS_SERVER:-$docker_host_ip}

# now we can ensure that DNS is configured to use our IP
cp /etc/resolv.conf /etc/resolv.conf.original
sed -e "s/${docker_embedded_dns_ip}/${dns_server}/g" /etc/resolv.conf.original >/etc/resolv.conf

# write config from environment variable
if [ ! -z "$K0S_CONFIG" ]; then
  mkdir -p /etc/k0s
  echo -n "$K0S_CONFIG" > /etc/k0s/config.yaml
fi

exec "$@"