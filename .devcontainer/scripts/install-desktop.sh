#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  xfce4 \
  xfce4-goodies \
  tigervnc-standalone-server \
  tigervnc-common \
  novnc \
  websockify \
  dbus-x11 \
  xterm \
  ca-certificates \
  curl \
  falkon

mkdir -p "${HOME}/.vnc"

cat > "${HOME}/.vnc/xstartup" <<'EOF'
#!/usr/bin/env bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF

chmod +x "${HOME}/.vnc/xstartup"

# Add Falkon to the desktop
mkdir -p "${HOME}/Desktop"

cat > "${HOME}/Desktop/falkon.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Falkon
Comment=Web Browser
Exec=falkon
Icon=falkon
Terminal=false
Categories=Network;WebBrowser;
StartupNotify=true
EOF

chmod +x "${HOME}/Desktop/falkon.desktop"

echo "Desktop dependencies installed."
echo "Falkon installed and added to desktop."
