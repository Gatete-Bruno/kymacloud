#!/bin/bash

echo "=========================================="
echo "KymaCloud WordPress Environment Setup"
echo "=========================================="

# Create directory structure (if not exists)
echo "Creating directory structure..."
mkdir -p nginx/conf.d
mkdir -p php
mkdir -p mysql
mkdir -p mariadb
mkdir -p sftp/wp1
mkdir -p sftp/wp2
mkdir -p backups/mysql
mkdir -p backups/mariadb
mkdir -p certbot/conf
mkdir -p certbot/www

# Generate SSH keys for SFTP
echo "Generating SSH keys for SFTP servers..."
if [ ! -f sftp/wp1/ssh_host_ed25519_key ]; then
    ssh-keygen -t ed25519 -f sftp/wp1/ssh_host_ed25519_key -N "" -C "SFTP WP1"
    ssh-keygen -t rsa -b 4096 -f sftp/wp1/ssh_host_rsa_key -N "" -C "SFTP WP1"
fi

if [ ! -f sftp/wp2/ssh_host_ed25519_key ]; then
    ssh-keygen -t ed25519 -f sftp/wp2/ssh_host_ed25519_key -N "" -C "SFTP WP2"
    ssh-keygen -t rsa -b 4096 -f sftp/wp2/ssh_host_rsa_key -N "" -C "SFTP WP2"
fi

# Set correct permissions
echo "Setting permissions..."
chmod 600 sftp/wp1/ssh_host_* 2>/dev/null || true
chmod 600 sftp/wp2/ssh_host_* 2>/dev/null || true

# Check if .env exists
if [ ! -f .env ]; then
    echo "ERROR: .env file not found!"
    echo "Please create a .env file with your configuration."
    exit 1
fi

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review and update the .env file with strong passwords"
echo "2. Update domain names in nginx/conf.d/*.conf files"
echo "3. Run: docker-compose up -d"
echo "4. Access your sites:"
echo "   - Site 1: http://site1.local"
echo "   - Site 2: http://site2.local"
echo "   - PHPMyAdmin 1: http://pma1.local"
echo "   - PHPMyAdmin 2: http://pma2.local"
echo "5. SFTP Access:"
echo "   - Site 1: sftp://localhost:2221"
echo "   - Site 2: sftp://localhost:2222"
echo ""
echo "=========================================="
