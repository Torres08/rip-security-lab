#!/bin/sh

for d in 10.10.20.1 172.16.120.1 172.16.130.1 172.16.140.1 10.30.40.1; do
  ip route del default via "$d" 2>/dev/null || true
done

ip route flush cache 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1 || true
sysctl -w net.ipv4.conf.all.forwarding=1 >/dev/null 2>&1 || true
apk update >/dev/null 2>&1 || true
apk add --no-cache tcpdump >/dev/null 2>&1 || true
exec /usr/lib/frr/docker-start
