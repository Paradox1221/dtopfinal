#!/usr/bin/env bash
set -euo pipefail

DISPLAY_NUM="${DISPLAY_NUM:-1}"
VNC_PORT="${VNC_PORT:-5901}"
NOVNC_PORT="${NOVNC_PORT:-6080}"
GEOMETRY="${GEOMETRY:-1920x1080}"
DEPTH="${DEPTH:-24}"
VNC_PASSWD="${VNC_PASSWD:-codespace}"

mkdir -p "${HOME}/.vnc"

if [ ! -f "${HOME}/.vnc/passwd" ]; then
  printf "%s\n" "${VNC_PASSWD}" | vncpasswd -f > "${HOME}/.vnc/passwd"
  chmod 600 "${HOME}/.vnc/passwd"
fi

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

vncserver ":${DISPLAY_NUM}" \
  -geometry "${GEOMETRY}" \
  -depth "${DEPTH}" \
  -localhost no \
  -rfbport "${VNC_PORT}"

nohup websockify --web=/usr/share/novnc/ "${NOVNC_PORT}" "localhost:${VNC_PORT}" \
  > "${HOME}/.vnc/novnc.log" 2>&1 &

cat <<EOF

Linux desktop started.

Open Codespaces port ${NOVNC_PORT} in browser (noVNC web client).
Optional direct VNC port: ${VNC_PORT}
VNC password: ${VNC_PASSWD}

Tip:
  bash .devcontainer/scripts/stop-desktop.sh
EOF
