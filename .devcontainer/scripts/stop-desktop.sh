#!/usr/bin/env bash
set -euo pipefail

DISPLAY_NUM="${DISPLAY_NUM:-1}"
NOVNC_PORT="${NOVNC_PORT:-6080}"

vncserver -kill ":${DISPLAY_NUM}" >/dev/null 2>&1 || true
pkill -f "websockify.*${NOVNC_PORT}" >/dev/null 2>&1 || true

echo "Desktop stopped."
