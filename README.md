## Environment Variables

- `RESOLUTION`: Screen resolution (default: 1280x720)
- `VNC_PORT`: VNC port (default: 5901)

Example:

```bash
docker run -d -p 5901:5901 -e RESOLUTION=1920x1080 --name fedora-vnc fedora-lxde-vnc
```

## Installation Scripts

The container includes scripts in `/root/scripts/`:

- `install-ghostty.sh` - Install Ghostty terminal emulator
- `install-chromium.sh` - Install Ungoogled Chromium browser
- `install-opencode.sh` - Install opencode-ai CLI tool

To run any script inside the container:
```bash
docker exec fedora-vnc /root/scripts/install-ghostty.sh
```
