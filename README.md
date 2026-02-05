# KymaCloud WordPress Multi-Site Environment

Production-ready Docker Compose setup for hosting multiple WordPress sites with different PHP versions, isolated databases, and comprehensive security.

## Architecture Overview
```
┌─────────────────────────────────────────────────────────────┐
│                    NGINX (Reverse Proxy)                     │
│                    Port 80/443 (Public)                      │
└──────────────┬──────────────────────┬────────────────────────┘
               │                      │
   ┌───────────▼──────────┐  ┌───────▼──────────────┐
   │ WordPress 1 (PHP 8.1)│  │ WordPress 2 (PHP 8.4)│
   │ + SFTP (Port 2221)   │  │ + SFTP (Port 2222)   │
   └───────────┬──────────┘  └───────┬──────────────┘
               │                      │
   ┌───────────▼──────────┐  ┌───────▼──────────────┐
   │ MySQL 8.0            │  │ MariaDB 11           │
   │ + PHPMyAdmin         │  │ + PHPMyAdmin         │
   └──────────────────────┘  └──────────────────────┘
```

## Summary

This Docker Compose setup provides a complete multi-site WordPress hosting environment with:

**Infrastructure:**
- NGINX reverse proxy with custom configurations for two sites
- Two WordPress installations running different PHP versions (8.1 and 8.4)
- Separate databases: MySQL 8.0 for WordPress 1, MariaDB 11 for WordPress 2
- PHPMyAdmin interface for each database
- SFTP access for file management on each site

**Architecture Highlights:**
- Three isolated networks (frontend + two backend networks)
- Horizontal scaling capability via PHP-FPM architecture
- Production-ready configurations for NGINX, PHP, MySQL, and MariaDB
- Complete stack isolation - compromising one site doesn't affect the other
- Resource limits and health checks for stability
- Security features including rate limiting, internal networks, and restricted PHP functions

**Evaluation Criteria Addressed:**
- Networks: 3 isolated networks with internal-only database access
- Scaling: Stateless design enables horizontal scaling with single command
- Settings: Optimized configurations for all components
- Isolation: Separate networks, databases, volumes, and users per stack
- Stability: Health checks, restart policies, resource limits, binary logs
- Security: Multiple layers including network isolation, rate limiting, security headers
- Cost-effectiveness: Alpine images, shared NGINX, efficient resource allocation

## Quick Start
```bash
# 1. Edit passwords
nano .env

# 2. Run setup
chmod +x setup.sh && ./setup.sh

# 3. Start services
docker-compose up -d

# 4. Add to /etc/hosts
echo "127.0.0.1 site1.local site2.local pma1.local pma2.local" | sudo tee -a /etc/hosts
```

## Access Points

- Site 1: http://site1.local
- Site 2: http://site2.local  
- PHPMyAdmin MySQL: http://pma1.local
- PHPMyAdmin MariaDB: http://pma2.local
- SFTP Site 1: port 2221
- SFTP Site 2: port 2222

## Management
```bash
docker-compose ps              # Check status
docker-compose logs -f         # View logs
docker-compose restart         # Restart all
docker-compose up -d --scale wordpress1=3  # Scale horizontally
docker stats                   # Resource usage
```

## Project Structure

- docker-compose.yml - Main orchestration
- .env - Environment variables and passwords
- nginx/ - NGINX configurations (main config + site1/site2/phpmyadmin)
- php/ - PHP configurations (8.1 and 8.4)
- mysql/ - MySQL configuration
- mariadb/ - MariaDB configuration
- sftp/ - SFTP SSH keys
- backups/ - Backup storage

---

**Version**: 1.0.0  
**Created for**: KymaCloud Technical Interview# kymacloud
