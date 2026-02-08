#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./verify.sh <JWT_TOKEN>"
    exit 1
fi

TOKEN="$1"
CRACK_TIMEOUT="${CRACK_TIMEOUT:-30}"

echo "=== JWT Security Verification Pipeline ==="
echo ""

if [ -d "jwt_tool" ]; then
    echo "[1/3] Running jwt_tool..."
    echo "----------------------------------------"
    python3 jwt_tool/jwt_tool.py "$TOKEN"
    echo ""
else
    echo "[1/3] jwt_tool not found - skipping"
    echo ""
fi

if command -v jwt-hack &> /dev/null; then
    echo "[2/3] Running jwt-hack (decode)..."
    jwt-hack decode "$TOKEN"
    echo ""
else
    echo "[2/3] jwt-hack not found - skipping"
    echo ""
fi

if command -v jwt-hack &> /dev/null; then
    echo "[3/3] jwt-hack (crack with wordlist)..."
    echo "------------------------------------------"
    timeout ${CRACK_TIMEOUT}s jwt-hack crack -w secrets.txt "$TOKEN" 
    echo ""
else
    echo "[3/3] jwt-hack not found - skipping"
    echo ""
fi

echo "=== Verification Complete ==="
