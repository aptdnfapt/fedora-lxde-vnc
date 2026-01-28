## Environment Variables

- `RESOLUTION`: Screen resolution (default: 1280x720)
- `VNC_PORT`: VNC port (default: 5901)

Example:

```bash
docker run -d -p 5901:5901 -e RESOLUTION=1920x1080 --name fedora-vnc fedora-lxde-vnc
```

## VPN Setup (Surfshark + WireGuard)

To run the container through a VPN using Gluetun:

1. Get Surfshark WireGuard credentials:
   - Log into Surfshark account
   - Go to VPN > Manual Setup > Desktop or mobile > WireGuard
   - Generate a new keypair
   - Copy the **Private key** and **Address** (IPv4) from the config file

2. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. Run with VPN:
   ```bash
   docker-compose -f docker-compose-vpn.yml up -d
   ```

   This will run both Gluetun (VPN client) and the Fedora VNC container with all traffic routed through the VPN.

4. Access via VNC on host: `5901` (gluetun handles the port forwarding)

## Installation Scripts

The container includes scripts in `/root/scripts/`:

- `install-ghostty.sh` - Install Ghostty terminal emulator
- `install-chromium.sh` - Install Ungoogled Chromium browser
- `install-opencode.sh` - Install opencode-ai CLI tool

To run any script inside the container:
```bash
docker exec fedora-vnc /root/scripts/install-ghostty.sh
```
