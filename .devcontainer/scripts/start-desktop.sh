#!/usr/bin/env bash
set -euo pipefail

DISPLAY_NUM="${DISPLAY_NUM:-1}"
VNC_PORT="${VNC_PORT:-5901}"
NOVNC_PORT="${NOVNC_PORT:-6080}"
GEOMETRY="${GEOMETRY:-1920x1080}"
DEPTH="${DEPTH:-24}"

mkdir -p "${HOME}/.vnc"

# ------------------------------------------------------------
# Disable VNC authentication
# ------------------------------------------------------------

cat > "${HOME}/.vnc/config" <<'EOF'
SecurityTypes=None
EOF

# Remove any old password file
rm -f "${HOME}/.vnc/passwd"

# ------------------------------------------------------------
# XFCE startup
# ------------------------------------------------------------

if [ ! -x "${HOME}/.vnc/xstartup" ]; then
  cat > "${HOME}/.vnc/xstartup" <<'EOF'
#!/usr/bin/env bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

exec startxfce4
EOF

  chmod +x "${HOME}/.vnc/xstartup"
fi

# ------------------------------------------------------------
# Stop existing sessions
# ------------------------------------------------------------

echo "==> Stopping existing VNC session..."

vncserver -kill ":${DISPLAY_NUM}" >/dev/null 2>&1 || true

echo "==> Stopping existing noVNC/websockify process..."

pkill -f "websockify.*${NOVNC_PORT}" >/dev/null 2>&1 || true

# ------------------------------------------------------------
# Start TigerVNC
# ------------------------------------------------------------

echo "==> Starting TigerVNC..."

vncserver ":${DISPLAY_NUM}" \
  -geometry "${GEOMETRY}" \
  -depth "${DEPTH}" \
  -localhost no \
  -SecurityTypes None \
  -I-KNOW-THIS-IS-INSECURE \
  -rfbport "${VNC_PORT}"

# ------------------------------------------------------------
# Start noVNC
# ------------------------------------------------------------

echo "==> Starting noVNC..."

nohup websockify \
  --web=/usr/share/novnc/ \
  "${NOVNC_PORT}" \
  "localhost:${VNC_PORT}" \
  > "${HOME}/.vnc/novnc.log" 2>&1 &

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------

cat <<EOF

==========================================
 Linux desktop started!
==========================================

Desktop:       XFCE
Browser:       Falkon
VNC display:   :${DISPLAY_NUM}
VNC port:      ${VNC_PORT}
noVNC port:    ${NOVNC_PORT}
VNC auth:      DISABLED
Resolution:    ${GEOMETRY}

Open Codespaces port ${NOVNC_PORT} in your browser
to access the desktop through noVNC.

Stop the desktop with:

  bash .devcontainer/scripts/stop-desktop.sh

==========================================
EOF
