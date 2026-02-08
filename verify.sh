#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./verify.sh <JWT_TOKEN>"
    exit 1
fi

TOKEN="$1"
CRACK_TIMEOUT="${CRACK_TIMEOUT:-10}"

echo "=== JWT Security Verification Pipeline ==="
echo ""

if [ -d "jwt_tool" ]; then
    echo "[1/3] Running jwt_tool..."
    echo "----------------------------------------"
    python3 jwt_tool/jwt_tool.py "$TOKEN" -M at 2>/dev/null | grep -v "No config file" | grep -v "Running config setup" | grep -v "Configuration file built" | grep -v "Make sure to set"
    echo ""
else
    echo "[1/3] jwt_tool not found - skipping"
    echo ""
fi

if command -v jwt-hack &> /dev/null; then
    echo "[2/3] Running jwt-hack..."
    jwt-hack -t "$TOKEN"
    echo ""
else
    echo "[2/3] jwt-hack not found - skipping"
    echo ""
fi

if [ -f "c-jwt-cracker/jwtcrack" ]; then
    echo "[3/3] jwt-cracker - Weak Secret Detection"
    echo "------------------------------------------"
    timeout ${CRACK_TIMEOUT}s ./c-jwt-cracker/jwtcrack "$TOKEN" || echo "No weak secret found (${CRACK_TIMEOUT}s timeout)"
    echo ""
else
    echo "[3/3] jwt-cracker not found - skipping"
    echo ""
fi

echo "=== Verification Complete ==="
