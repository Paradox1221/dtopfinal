#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> Updating package lists..."
sudo apt-get update

echo "==> Installing repository tools..."
sudo apt-get install -y --no-install-recommends \
  software-properties-common

echo "==> Enabling Ubuntu Universe repository..."
sudo add-apt-repository -y universe

echo "==> Updating package lists..."
sudo apt-get update

echo "==> Installing XFCE, TigerVNC, noVNC, and Falkon..."
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

# ------------------------------------------------------------
# Verify Falkon
# ------------------------------------------------------------

if ! command -v falkon >/dev/null 2>&1; then
    echo "ERROR: Falkon was not installed."
    echo "Package information:"
    apt-cache policy falkon || true
    exit 1
fi

echo "==> Falkon successfully installed:"
falkon --version || true

# ------------------------------------------------------------
# VNC configuration
# ------------------------------------------------------------

echo "==> Configuring TigerVNC..."

mkdir -p "${HOME}/.vnc"

# Disable VNC authentication
cat > "${HOME}/.vnc/config" <<'EOF'
SecurityTypes=None
EOF

# Remove any existing VNC password
rm -f "${HOME}/.vnc/passwd"

# ------------------------------------------------------------
# XFCE startup
# ------------------------------------------------------------

echo "==> Configuring XFCE startup..."

cat > "${HOME}/.vnc/xstartup" <<'EOF'
#!/usr/bin/env bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

exec startxfce4
EOF

chmod +x "${HOME}/.vnc/xstartup"

# ------------------------------------------------------------
# Falkon desktop shortcut
# ------------------------------------------------------------

echo "==> Creating Falkon desktop shortcut..."

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

# ------------------------------------------------------------
# XFCE default backdrop
# ------------------------------------------------------------

echo "==> Resetting XFCE desktop configuration..."

XFCE_CONFIG="${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"

if [ -f "${XFCE_CONFIG}" ]; then
    rm -f "${XFCE_CONFIG}"
fi

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------

echo
echo "=========================================="
echo " Desktop installation complete!"
echo "=========================================="
echo
echo "Falkon:       $(command -v falkon)"
echo "VNC auth:     DISABLED"
echo "Falkon icon:  ${HOME}/Desktop/falkon.desktop"
echo "Backdrop:     XFCE default"
echo
echo "Falkon version:"
falkon --version || true
echo
echo "Run the desktop with:"
echo "  bash .devcontainer/scripts/start-desktop.sh"
echo
