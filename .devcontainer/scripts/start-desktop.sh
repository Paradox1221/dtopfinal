#!/usr/bin/env bash
set -euo pipefail

DISPLAY_NUM="${DISPLAY_NUM:-1}"
VNC_PORT="${VNC_PORT:-5901}"
NOVNC_PORT="${NOVNC_PORT:-6080}"
GEOMETRY="${GEOMETRY:-1920x1080}"
DEPTH="${DEPTH:-24}"

mkdir -p "${HOME}/.vnc"

# Disable VNC password authentication
cat > "${HOME}/.vnc/config" <<'EOF'
SecurityTypes=None
EOF

# Remove any old password file
rm -f "${HOME}/.vnc/passwd"

if [ ! -x "${HOME}/.vnc/xstartup" ]; then
  cat > "${HOME}/.vnc/xstartup" <<'EOF'
#!/usr/bin/env bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
  chmod +x "${HOME}/.vnc/xstartup"
fi

# Stop any old sessions safely
vncserver -kill ":${DISPLAY_NUM}" >/dev/null 2>&1 || true
pkill -f "websockify.*${NOVNC_PORT}" >/dev/null 2>&1 || true

# Start TigerVNC with no authentication
vncserver ":${DISPLAY_NUM}" \
  -geometry "${GEOMETRY}" \
  -depth "${DEPTH}" \
  -localhost no \
  -SecurityTypes None \
  -rfbport "${VNC_PORT}"

nohup websockify --web=/usr/share/novnc/ "${NOVNC_PORT}" "localhost:${VNC_PORT}" \
  > "${HOME}/.vnc/novnc.log" 2>&1 &

cat <<EOF

Linux desktop started.

Open Codespaces port ${NOVNC_PORT} in browser (noVNC web client).
Optional direct VNC port: ${VNC_PORT}
VNC authentication: DISABLED

Tip:
  bash .devcontainer/scripts/stop-desktop.sh
EOF
