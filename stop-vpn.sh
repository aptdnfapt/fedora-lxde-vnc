#!/bin/bash
# Turn OFF VPN temporarily (for fast downloads/updates)

echo "Stopping VPN..."
curl -X PUT -H "Content-Type: application/json" -d '{"status":"stopped"}' http://localhost:8000/v1/vpn/status
echo ""
echo "VPN OFF - Using direct connection for faster downloads"
echo "Run './start-vpn.sh' to re-enable VPN"
