## Virtual Linux Desktop in Codespaces (XFCE + noVNC)

This repository is configured to run a browser-accessible Linux desktop inside GitHub Codespaces.

### 1) Open in Codespaces
- Click **Code** → **Codespaces** → **Create codespace on main**.
- Wait for post-create setup to finish (desktop packages install automatically).

### 2) Start the desktop
Run:

```bash
bash .devcontainer/scripts/start-desktop.sh
```

### 3) Open the desktop
- In the **Ports** tab, open port **6080** (`Linux Desktop (noVNC)`).
- This opens the desktop in your browser.

### Default credentials
- Default VNC password: `codespace`
- You can override it before start:

```bash
export VNC_PASSWD='your-strong-password'
bash .devcontainer/scripts/start-desktop.sh
```

### Stop desktop
```bash
bash .devcontainer/scripts/stop-desktop.sh
```

### Troubleshooting
- If port 6080 doesn’t load, restart the desktop:
```bash
bash .devcontainer/scripts/stop-desktop.sh
bash .devcontainer/scripts/start-desktop.sh
```
- If XFCE fails to launch, rebuild the container:
  - Command Palette → **Codespaces: Rebuild Container**
- Check logs:
```bash
cat ~/.vnc/*.log
cat ~/.vnc/novnc.log
```
