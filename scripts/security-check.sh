#!/bin/bash

echo "Security Check for KymaCloud WordPress"
echo "=========================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "[FAIL] .env file not found! Run ./setup.sh first"
    exit 1
fi

# Check .env permissions
ENV_PERMS=$(stat -f "%A" .env 2>/dev/null || stat -c "%a" .env 2>/dev/null)
if [ "$ENV_PERMS" != "600" ]; then
    echo "[WARN] .env has insecure permissions ($ENV_PERMS)"
    echo "       Fixing: chmod 600 .env"
    chmod 600 .env
    echo "[PASS] Fixed"
else
    echo "[PASS] .env permissions are secure (600)"
fi

# Check if .env is tracked by git
if git ls-files --error-unmatch .env > /dev/null 2>&1; then
    echo "[FAIL] CRITICAL: .env is tracked by git!"
    echo "       Fix: git rm --cached .env"
    echo "       Then commit: git commit -m 'Remove .env from tracking'"
else
    echo "[PASS] .env is not tracked by git"
fi

# Check if .passwords exists
if [ -f .passwords ]; then
    echo "[WARN] .passwords file still exists!"
    echo "       Save passwords securely, then delete: rm .passwords"
else
    echo "[PASS] .passwords file removed"
fi

# Check for default passwords
if grep -q "CHANGE_THIS" .env 2>/dev/null; then
    echo "[FAIL] Default passwords detected in .env!"
    echo "       Run ./setup.sh to generate secure passwords"
else
    echo "[PASS] No default passwords found"
fi

# Check SSH key permissions
echo ""
echo "Checking SSH key permissions..."
for key in sftp/*/ssh_host_*; do
    if [ -f "$key" ]; then
        KEY_PERMS=$(stat -f "%A" "$key" 2>/dev/null || stat -c "%a" "$key" 2>/dev/null)
        if [ "$KEY_PERMS" != "600" ]; then
            echo "[WARN] $key has insecure permissions ($KEY_PERMS)"
            chmod 600 "$key"
            echo "       Fixed: chmod 600 $key"
        fi
    fi
done
echo "[PASS] SSH key permissions checked"

echo ""
echo "=========================================="
echo "Security check complete!"
echo "=========================================="
