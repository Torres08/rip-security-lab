#!/usr/bin/env bash
# unpoison-r4.sh — remove the fake route from R4 without rebuilding
set -e

podman exec -i rip-r4 vtysh <<'EOF'
conf t
no ip route 10.10.20.0/24 Null0
router rip
 version 2
 no redistribute static
end
EOF

echo "[+] Poison removed on R4"