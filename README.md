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

## Temporarily Disable VPN

For faster package installations and system updates, you can temporarily disable the VPN without killing the containers:

```bash
# Turn off VPN (direct connection)
./stop-vpn.sh

# Do your updates/installs (much faster without VPN!)
docker exec fedora-vnc /root/scripts/install-opencode.sh

# Turn VPN back on
./start-vpn.sh

# Or toggle between on/off
./toggle-vpn.sh
```

These scripts use the HTTP Control Server API:
- Stop: `curl -X PUT -d '{"status":"stopped"}' http://localhost:8000/v1/vpn/status`
- Start: `curl -X PUT -d '{"status":"running"}' http://localhost:8000/v1/vpn/status`

### Exposed Ports

When running with VPN, the following ports are exposed on the gluetun container:

- `5901` - VNC desktop access
- `8000` - HTTP Control Server API:
  - `GET /v1/vpn/status` - Get VPN status
  - `PUT /v1/vpn/status` - Start/stop VPN
  - `GET /v1/publicip/ip` - Get current VPN IP
  - See [Gluetun Control Server Docs](https://github.com/qdm12/gluetun-wiki/blob/main/setup/advanced/control-server.md) for more endpoints
- `8894` - HTTP Proxy (maps to container port 8888)

## Installation Scripts

The container includes scripts in `/root/scripts/`:

- `install-ghostty.sh` - Install Ghostty terminal emulator
- `install-chromium.sh` - Install Ungoogled Chromium browser
- `install-opencode.sh` - Install opencode-ai CLI tool

To run any script inside the container:
```bash
docker exec fedora-vnc /root/scripts/install-ghostty.sh
```
