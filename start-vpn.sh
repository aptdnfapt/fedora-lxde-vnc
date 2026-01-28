#!/bin/bash
# Turn ON VPN

echo "Starting VPN..."
curl -X PUT -H "Content-Type: application/json" -d '{"status":"running"}' http://localhost:8000/v1/vpn/status
echo ""

# Wait for VPN to connect
echo "Waiting for VPN to connect..."
for i in {1..10}; do
    STATUS=$(curl -s http://localhost:8000/v1/vpn/status | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    if [ "$STATUS" = "running" ]; then
        IP=$(curl -s http://localhost:8000/v1/publicip/ip)
        echo "VPN ON - Connected to: $(echo $IP | grep -o '"country":"[^"]*"' | cut -d'"' -f4)"
        exit 0
    fi
    sleep 2
done

echo "VPN starting... (check logs with 'docker logs gluetun-surfshark')"
