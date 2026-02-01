# AGENTS.md - Fedora LXDE VNC Container

## Project Overview

Docker container providing Fedora Linux with LXDE desktop environment accessible via VNC.
Stack: Docker, Fedora, LXDE, TigerVNC, Bash scripts.

---

## Build & Run Commands

### Docker Build
```bash
# Build image
docker build -t fedora-lxde-vnc .

# Build with no cache (clean rebuild)
docker build --no-cache -t fedora-lxde-vnc .
```

### Docker Compose
```bash
# Build and start
docker compose up -d --build

# Start existing
docker compose up -d

# Stop
docker compose down

# View logs
docker compose logs -f
```

### Run Container Directly
```bash
# Basic run
docker run -d -p 5901:5901 --name fedora-vnc fedora-lxde-vnc

# Custom resolution
docker run -d -p 5901:5901 -e RESOLUTION=1920x1080 --name fedora-vnc fedora-lxde-vnc

# Interactive shell
docker exec -it fedora-vnc bash
```

### Execute Installation Scripts
```bash
docker exec fedora-vnc /root/scripts/install-ghostty.sh
docker exec fedora-vnc /root/scripts/install-chromium.sh
docker exec fedora-vnc /root/scripts/install-opencode.sh
```

---

## Testing

No automated test suite. Manual testing:
1. Build image --> `docker build -t fedora-lxde-vnc .`
2. Run container --> `docker run -d -p 5901:5901 --name test-vnc fedora-lxde-vnc`
3. Connect VNC client to `localhost:5901` (password: `vncpass`)
4. Verify LXDE desktop loads
5. Cleanup --> `docker rm -f test-vnc`

---

## Code Style Guidelines

### Shell Scripts (`scripts/*.sh`)

**Shebang & Structure:**
```bash
#!/bin/bash
# Brief description of what script does

# Commands here
```

**Conventions:**
- Always start with `#!/bin/bash`
- Use `dnf` for package management (Fedora)
- Use `-y` flag for non-interactive installs
- Keep scripts minimal - single purpose
- No error handling needed for simple install scripts
- Executable permissions: `chmod +x script.sh`

**COPR Repos Pattern:**
```bash
dnf copr enable <user>/<repo>
dnf install -y <package>
```

### Dockerfile

**Best Practices:**
- Base: `FROM fedora:latest`
- ENV vars at top for configuration
- Combine RUN commands with `&&` to reduce layers
- Use `--setopt=install_weak_deps=False` for smaller images
- Always `dnf clean all` after installs
- COPY scripts before RUN to leverage cache
- Set proper permissions with `chmod`
- Use `printf` for inline file creation (not echo with escapes)

**Layer Optimization:**
```dockerfile
# Good - single layer
RUN dnf -y install pkg1 pkg2 && dnf clean all

# Bad - multiple layers
RUN dnf -y install pkg1
RUN dnf -y install pkg2
```

**Environment Variables:**
- `DISPLAY` - X11 display (`:1`)
- `VNC_PORT` - VNC server port (`5901`)
- `RESOLUTION` - Screen resolution (`1280x720`)

### docker-compose.yml

**Format:**
- Use YAML 2-space indentation
- Service name: descriptive, lowercase, hyphenated
- Always specify `restart: unless-stopped` for services
- Environment vars as list format (`- VAR=value`)

---

## File Structure

```
fedora-lxde-vnc/
├── Dockerfile           # Main container definition
├── docker-compose.yml   # Orchestration config
├── README.md            # User documentation
├── .dockerignore        # Build exclusions
├── .gitignore           # Git exclusions
└── scripts/
    ├── install-chromium.sh   # Ungoogled Chromium installer
    ├── install-ghostty.sh    # Ghostty terminal installer
    └── install-opencode.sh   # OpenCode CLI installer
```

---

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Scripts | `install-<package>.sh` | `install-ghostty.sh` |
| ENV vars | UPPER_SNAKE_CASE | `VNC_PORT` |
| Services | lowercase-hyphenated | `fedora-vnc` |
| Image tags | lowercase-hyphenated | `fedora-lxde-vnc` |

---

## Error Handling

**Shell Scripts:**
- Keep simple - let commands fail naturally
- For critical scripts, add: `set -e` (exit on error)
- For debugging: `set -x` (print commands)

**Dockerfile:**
- Each RUN command must succeed or build fails
- Chain commands with `&&` so failure stops the chain

---

## Security Notes

- Default VNC password: `vncpass` (change in production)
- VNC runs as root inside container
- `-localhost no` allows external connections
- Never commit `.env` files with secrets

---

## Adding New Installation Scripts

1. Create `scripts/install-<name>.sh`
2. Start with `#!/bin/bash`
3. Use `dnf install -y` or appropriate installer
4. Make executable: `chmod +x scripts/install-<name>.sh`
5. Document in README.md

---

## Common Issues

**VNC won't connect:**
- Check port mapping: `-p 5901:5901`
- Verify container running: `docker ps`
- Check logs: `docker logs fedora-vnc`

**Black screen in VNC:**
- LXDE session may need time to start
- Check xstartup permissions: `chmod +x /root/.vnc/xstartup`

**Package not found:**
- Enable COPR repo first if third-party
- Run `dnf makecache` to refresh
