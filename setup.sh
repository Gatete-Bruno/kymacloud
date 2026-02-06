#!/bin/bash

echo "=========================================="
echo "KymaCloud WordPress Environment Setup"
echo "=========================================="

# Check if .env already exists
if [ -f .env ]; then
    echo "WARNING: .env file already exists!"
    read -p "Do you want to regenerate passwords? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Keeping existing .env file."
        exit 0
    fi
    # Backup existing .env
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backed up existing .env file"
fi

# Function to generate strong password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

echo ""
echo "Generating secure random passwords..."
echo ""

# Generate passwords
MYSQL_ROOT_PASS=$(generate_password)
WP1_DB_PASS=$(generate_password)
MARIADB_ROOT_PASS=$(generate_password)
WP2_DB_PASS=$(generate_password)
SFTP1_PASS=$(generate_password)
SFTP2_PASS=$(generate_password)

# Create .env file
cat > .env << ENVFILE
# MySQL (WordPress 1)
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASS}
WP1_DB_NAME=wordpress1
WP1_DB_USER=wp1user
WP1_DB_PASSWORD=${WP1_DB_PASS}

# MariaDB (WordPress 2)
MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASS}
WP2_DB_NAME=wordpress2
WP2_DB_USER=wp2user
WP2_DB_PASSWORD=${WP2_DB_PASS}

# SFTP Access
SFTP1_PASSWORD=${SFTP1_PASS}
SFTP2_PASSWORD=${SFTP2_PASS}

# PHPMyAdmin URLs
PMA1_URL=http://localhost/pma1/
PMA2_URL=http://localhost/pma2/

# WordPress Table Prefixes
WP1_TABLE_PREFIX=wp1_
WP2_TABLE_PREFIX=wp2_
ENVFILE

chmod 600 .env
echo "Created .env file with secure permissions (600)"

# Create password reference file
cat > .passwords << PASSFILE
========================================
KymaCloud WordPress Credentials
Generated: $(date)
========================================

MySQL (WordPress 1):
- Root Password: ${MYSQL_ROOT_PASS}
- WP1 DB Password: ${WP1_DB_PASS}

MariaDB (WordPress 2):
- Root Password: ${MARIADB_ROOT_PASS}
- WP2 DB Password: ${WP2_DB_PASS}

SFTP Access:
- SFTP1 Password: ${SFTP1_PASS}
- SFTP2 Password: ${SFTP2_PASS}

========================================
IMPORTANT: Store this file securely!
Consider using a password manager.
Delete this file after saving passwords.
========================================
PASSFILE

chmod 600 .passwords
echo "Created .passwords file (KEEP THIS SECURE!)"

echo ""
echo "Creating directory structure..."
mkdir -p backups/{mysql,mariadb,wordpress1,wordpress2}
mkdir -p certbot/{conf,www}
mkdir -p sftp/{wp1,wp2}
mkdir -p nginx/auth
echo "Directory structure created"

echo ""
echo "Generating SSH keys for SFTP servers..."
ssh-keygen -t ed25519 -f sftp/wp1/ssh_host_ed25519_key -N "" -C "SFTP WP1" > /dev/null 2>&1
ssh-keygen -t rsa -b 4096 -f sftp/wp1/ssh_host_rsa_key -N "" -C "SFTP WP1" > /dev/null 2>&1
ssh-keygen -t ed25519 -f sftp/wp2/ssh_host_ed25519_key -N "" -C "SFTP WP2" > /dev/null 2>&1
ssh-keygen -t rsa -b 4096 -f sftp/wp2/ssh_host_rsa_key -N "" -C "SFTP WP2" > /dev/null 2>&1
echo "SSH keys generated"

echo ""
echo "Setting permissions..."
chmod 600 sftp/wp1/ssh_host_*
chmod 600 sftp/wp2/ssh_host_*
echo "Permissions set"

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review passwords in .passwords file"
echo "2. Save passwords to your password manager"
echo "3. Delete .passwords file: rm .passwords"
echo "4. Run: docker-compose up -d"
echo "5. Add to /etc/hosts:"
echo "   127.0.0.1 site1.local site2.local pma1.local pma2.local"
echo ""
echo "SECURITY REMINDERS:"
echo "- Never commit .env file to git"
echo "- Store passwords securely"
echo "- Delete .passwords file after saving credentials"
echo "- Consider implementing SSH key-based SFTP authentication"
echo ""
