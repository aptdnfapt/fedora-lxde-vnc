FROM fedora:latest

# Set environment variables
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV RESOLUTION=1280x720
ENV VNC_PASSWORD=vncpass

# Install LXDE desktop, VNC server, X11 utilities, and npm
RUN dnf -y install --setopt=install_weak_deps=False \
    @lxde-desktop \
    tigervnc-server \
    xorg-x11-fonts-* \
    npm \
    && dnf clean all

# Copy installation scripts into container
COPY scripts /root/scripts
RUN chmod +x /root/scripts/*.sh

# Create VNC directory
RUN mkdir -p /root/.vnc

# Create xstartup for VNC
RUN printf '#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\n/usr/bin/lxsession -s LXDE -e LXDE &\n' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Create startup script
RUN printf '#!/bin/bash\necho "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd\nvncserver $DISPLAY -geometry $RESOLUTION -depth 24 -localhost no\ntail -f /root/.vnc/*.log\n' > /root/start-vnc.sh && \
    chmod +x /root/start-vnc.sh

EXPOSE 5901

CMD ["/root/start-vnc.sh"]
