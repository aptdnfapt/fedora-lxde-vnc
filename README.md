# Fedora LXDE VNC Docker

Docker container running Fedora with LXDE desktop and VNC server.

## Build

```bash
docker build -t fedora-lxde-vnc .
```

## Run

```bash
docker run -d -p 5901:5901 --name fedora-vnc fedora-lxde-vnc
```

## Connect

Connect via VNC client to `localhost:5901`

**Default password:** `vncpass`

## Environment Variables

- `RESOLUTION`: Screen resolution (default: 1280x720)
- `VNC_PORT`: VNC port (default: 5901)

Example:

```bash
docker run -d -p 5901:5901 -e RESOLUTION=1920x1080 --name fedora-vnc fedora-lxde-vnc
```
