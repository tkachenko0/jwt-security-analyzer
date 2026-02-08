#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./verify.sh <JWT_TOKEN>"
    exit 1
fi

TOKEN="$1"

echo "=== JWT Security Verification Pipeline ==="
echo ""

if [ -d "jwt_tool" ]; then
    echo "[1/3] Running jwt_tool..."
    python3 jwt_tool/jwt_tool.py "$TOKEN" -M at
    echo ""
else
    echo "[1/3] jwt_tool not found - skipping"
fi

if command -v jwt-hack &> /dev/null; then
    echo "[2/3] Running jwt-hack..."
    jwt-hack -t "$TOKEN"
    echo ""
else
    echo "[2/3] jwt-hack not found - skipping"
fi

if [ -f "c-jwt-cracker/jwtcrack" ]; then
    echo "[3/3] Running jwt-cracker (weak secret check)..."
    timeout 10s ./c-jwt-cracker/jwtcrack "$TOKEN" || echo "No weak secret found in 10s"
    echo ""
else
    echo "[3/3] jwt-cracker not found - skipping"
fi

echo "=== Verification Complete ==="
