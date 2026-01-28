#!/bin/bash
# Toggle VPN on/off using Gluetun HTTP control server

GLUETUN_HOST="http://localhost:8000"
CURRENT_STATUS=$(curl -s "$GLUETUN_HOST/v1/vpn/status" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

echo "Current VPN status: $CURRENT_STATUS"

if [ "$CURRENT_STATUS" = "running" ]; then
    echo "Stopping VPN..."
    curl -X PUT -H "Content-Type: application/json" -d '{"status":"stopped"}' "$GLUETUN_HOST/v1/vpn/status"
    echo "VPN stopped - using direct connection for faster downloads/updates"
elif [ "$CURRENT_STATUS" = "stopped" ]; then
    echo "Starting VPN..."
    curl -X PUT -H "Content-Type: application/json" -d '{"status":"running"}' "$GLUETUN_HOST/v1/vpn/status"
    echo "VPN started - using VPN connection"
else
    echo "Unknown status"
    exit 1
fi

# Wait a moment and show new status
sleep 2
NEW_STATUS=$(curl -s "$GLUETUN_HOST/v1/vpn/status" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
echo "New VPN status: $NEW_STATUS"
