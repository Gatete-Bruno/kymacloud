# KymaCloud WordPress Multi-Site Environment

**[ Read Full Technical Documentation](https://gatete.hashnode.dev/kymacloud-wordpress-multi-site-environment-technical-documentation)**


Production-ready Docker Compose setup for hosting multiple WordPress sites with different PHP versions, isolated databases, and comprehensive security.

## Project Structure
```
.
├── docker-compose.yml          # Main orchestration file
├── .env.example                # Environment variables template
├── .gitignore                  # Git exclusions
├── setup.sh                    # Initial setup and password generation
├── Makefile                    # Management commands
├── README.md                   
├── QUICKSTART.md               # Quick setup guide
├── nginx/
│   ├── nginx.conf             # Main NGINX configuration
│   └── conf.d/
│       ├── site1.conf         # WordPress 1 virtual host
│       ├── site2.conf         # WordPress 2 virtual host
│       └── phpmyadmin.conf    # PHPMyAdmin proxy configuration
├── php/
│   ├── php8.1.ini             # PHP 8.1 settings (OPcache, limits)
│   └── php8.4.ini             # PHP 8.4 settings (OPcache + JIT)
├── mysql/
│   └── my.cnf                 # MySQL 8.0 configuration
├── mariadb/
│   └── my.cnf                 # MariaDB 11 configuration
├── sftp/
│   ├── wp1/
│   │   ├── ssh_host_ed25519_key
│   │   ├── ssh_host_ed25519_key.pub
│   │   ├── ssh_host_rsa_key
│   │   └── ssh_host_rsa_key.pub
│   └── wp2/
│       ├── ssh_host_ed25519_key
│       ├── ssh_host_ed25519_key.pub
│       ├── ssh_host_rsa_key
│       └── ssh_host_rsa_key.pub
├── scripts/
│   └── security-check.sh      # Security validation script
├── backups/                   # Backup storage (gitignored)
│   ├── mysql/
│   ├── mariadb/
│   ├── wordpress1/
│   └── wordpress2/
└── certbot/                   # SSL certificates (gitignored)
    ├── conf/
    └── www/
```


## System Design
```mermaid
graph TB
    subgraph Internet["Internet"]
        Users["Users<br/>HTTP/HTTPS & SFTP"]
    end
    
    subgraph Docker["KymaCloud WordPress Multi-Site Environment"]
        subgraph Frontend["Frontend Network (172.20.0.0/24) - PUBLIC"]
            NGINX["NGINX Reverse Proxy<br/>nginx:alpine<br/>Port 80/443<br/>Load Balancer"]
            PMA1["PHPMyAdmin<br/>pma1.local<br/>MySQL Admin"]
            PMA2["PHPMyAdmin<br/>pma2.local<br/>MariaDB Admin"]
        end
        
        subgraph Backend1["Backend Network WP1 (172.21.0.0/24) - INTERNAL ONLY"]
            WP1["WordPress 1<br/>site1.local<br/>PHP 8.1 FPM"]
            MySQL["MySQL 8.0<br/>Port 3306"]
            SFTP1["SFTP Server<br/>Port 2221"]
            Vol1["wordpress1_data<br/>mysql_data"]
        end
        
        subgraph Features["Key Features & Architecture"]
            Scale["Horizontal Scaling<br/>FPM Stateless<br/>--scale wordpressN=5"]
            Sec["Security<br/>3 Isolated Networks<br/>Internal-Only DBs"]
            Monitor["Monitoring<br/>Health Checks<br/>Auto-Restart"]
        end
        
        subgraph Backend2["Backend Network WP2 (172.22.0.0/24) - INTERNAL ONLY"]
            WP2["WordPress 2<br/>site2.local<br/>PHP 8.4 FPM"]
            MariaDB["MariaDB 11<br/>Port 3306"]
            SFTP2["SFTP Server<br/>Port 2222"]
            Vol2["wordpress2_data<br/>mariadb_data"]
        end
    end
    
    Users -->|HTTP :80/443| NGINX
    Users -->|SFTP :2221| SFTP1
    Users -->|SFTP :2222| SFTP2
    
    NGINX -->|FastCGI :9000| WP1
    NGINX -->|FastCGI :9000| WP2
    NGINX -->|Proxy| PMA1
    NGINX -->|Proxy| PMA2
    
    WP1 -->|SQL :3306| MySQL
    WP2 -->|SQL :3306| MariaDB
    
    PMA1 -.->|Manage| MySQL
    PMA2 -.->|Manage| MariaDB
    
    SFTP1 -.->|Files| Vol1
    SFTP2 -.->|Files| Vol2
    
    WP1 -->|Store| Vol1
    WP2 -->|Store| Vol2
    MySQL -->|Persist| Vol1
    MariaDB -->|Persist| Vol2
    
    WP1 -.->|Metrics| Scale
    WP2 -.->|Metrics| Scale
    
    WP1 -.->|Monitor| Monitor
    WP2 -.->|Monitor| Monitor
    
    NGINX -.->|Apply| Sec
    
    style Internet fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:2px
    style Users fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    
    style Docker fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:3px
    
    style Frontend fill:#2d7a8a,color:#fff,stroke:#1a3a52,stroke-width:2px
    style NGINX fill:#2d7a8a,color:#fff,stroke:#1a3a52,stroke-width:2px
    style PMA1 fill:#2d7a8a,color:#fff,stroke:#1a3a52,stroke-width:2px
    style PMA2 fill:#2d7a8a,color:#fff,stroke:#1a3a52,stroke-width:2px
    
    style Backend1 fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:2px
    style Backend2 fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:2px
    
    style WP1 fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    style WP2 fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    style MySQL fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    style MariaDB fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    style SFTP1 fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    style SFTP2 fill:#1a3a52,color:#fff,stroke:#0d1f2d,stroke-width:2px
    
    style Vol1 fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:2px
    style Vol2 fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:2px
    
    style Features fill:#e8f1f5,color:#1a3a52,stroke:#2d7a8a,stroke-width:2px
    style Scale fill:#3d5a80,color:#fff,stroke:#1a3a52,stroke-width:2px
    style Sec fill:#3d5a80,color:#fff,stroke:#1a3a52,stroke-width:2px
    style Monitor fill:#3d5a80,color:#fff,stroke:#1a3a52,stroke-width:2px
    
    linkStyle default stroke:#1a3a52,stroke-width:2px
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
# 1. Run setup to generate secure passwords
chmod +x setup.sh && ./setup.sh

# 2. Start services
docker-compose up -d

# 3. Add to /etc/hosts for local testing
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

## Security Notes

- Passwords are auto-generated by `setup.sh` and stored securely
- All sensitive files (passwords, SSH keys, backups) are excluded from git
- `.env.example` provides a template for new environments
- File permissions automatically set to 600 for secrets
- Run `./scripts/security-check.sh` to verify security configuration

## Troubleshooting

### Regenerating Passwords

If you need to regenerate passwords after containers are already running:
```bash
# 1. Remove old SSH keys
rm -f sftp/wp1/ssh_host_* sftp/wp2/ssh_host_*

# 2. Run setup to generate new passwords
./setup.sh

# 3. Stop all containers
docker-compose down

# 4. Remove WordPress volumes (contains old passwords)
docker volume rm kymacloud_mysql_data kymacloud_mariadb_data kymacloud_wordpress1_data kymacloud_wordpress2_data

# 5. Start fresh with new passwords
docker-compose up -d

# 6. Wait for containers to be healthy
docker-compose ps
```

### Common Issues

**Database connection errors:**
- WordPress volumes may contain old passwords
- Solution: Remove volumes and restart (see above)

**SSH key generation hangs:**
- Keys already exist and prompting to overwrite
- Solution: Remove existing keys first: `rm -f sftp/*/ssh_host_*`

**Containers showing unhealthy:**
- Wait 1-2 minutes for databases to initialize
- Check logs: `docker-compose logs [service-name]`

---

