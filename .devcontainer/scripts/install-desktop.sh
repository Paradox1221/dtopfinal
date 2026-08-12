#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  xfce4 xfce4-goodies \
  tigervnc-standalone-server tigervnc-common \
  novnc websockify \
  dbus-x11 xterm \
  ca-certificates curl

mkdir -p "${HOME}/.vnc"
cat > "${HOME}/.vnc/xstartup" <<'EOF'
#!/usr/bin/env bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x "${HOME}/.vnc/xstartup"

echo "Desktop dependencies installed."
