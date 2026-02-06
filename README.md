# KymaCloud WordPress Multi-Site Environment

Production-ready Docker Compose setup for hosting multiple WordPress sites with different PHP versions, isolated databases, and comprehensive security.

## System Design


## Summary

## System Design

![Architecture Diagram](https://mermaid.ink/img/pako:eNqtV91y4jYUfhWNM9NpZ4BYMgTH0-4MJMuGaWDdkO32h05HwSJ4YixWFrthQ16gd_256k2nF-2D9Qn6CD2SbGMw2e1uDDMg-Zzz6eicTx_izprwgFmedS3oYoYuu-MYwStZXpkH_VgyETP5_djKhmPrB-OkXi8SJhIw_vvHz3-ZyedX4vDJ2eWlf6g-RugTNOpd-nkQiwMz2FnolE9umACkL1dzehLxZYBechH4giUJGiwjGdZHoWToafw6FDyes3g7kRyoB1YJqwBUNkRDJt9wcYM-xW3SIHYD3oek-RmqI_9F97x_soWkXsNn_eE3gKC_0QV7DRtjyBf8dqX3F1-H8a1Ho0UYM_3A50Ii1z5sNh09P-c0QF0a0XjCRAneH3QwoPtn_mDVCeZhrGMWc4obEZ_QSE8Hq9FX50ib9wGQvQCkCEBFSE-7eyDyJmwasVXDLoVmxIHKMR3mJXzp47SMuFDG_vDy6cWwc46eD8-_LWULMYC0aSfW6SXQzuJ-YTPIbWDU8wclBF0LwDA1cRv2puiOYx-V_BXl1JrqG42YgP5tIgghuBTxNY-w5vGvfyPYaLBQmeIfAyqpjtSG-Sp5FelnH1TOHqNyCXiK3WyVT-FodMRkBmWYqHl5E1AZBjH__P4nOuMifAtsppF-HMbXOiuoFRpJKlkE2eon9XqiwjZ7GH7RKiOzid7rb7-o4VKE0tDaQf2ERwCX99uAmqNPo_rzOFqh025SbhCPQ8mFqeBP2TRL84zRSM7QyYxNUsTOUvL6BUskFfJjqEn2UpOk1CQfQE2yRU2SU5OUqNncT01zyhQ50_OG8f9gJ3kHO8k-dpISO8kuO9X6wdU7-LkjvlqvUb3-ZK2kGnlGv9ZG_XZddLKeOjtrc7wedCDGgRSXMkKq3Ho0kSfP-sg7tm17rbThvR5k10ML8VrL6MOmrfWVbOkkQT481ZS10ZTMSkpW08wihloO1RvgN6AxvWZbEGrBHWMZQdfNePVCOLJrLTsbG9m17d8DnCxWDM3Tzw1pnJFLXRboUpjIYlRG111zeU29KyZFOIGstCoV1n3IuBtvFGGdScMuwl7zVnOVW2exiKC7IFpblwi5AsXL7idoGkaRd8DcKZ62ahMeceEdYOrQFqklUvAb5h2QoE1dmk7rb8JAzjyyuC3CGWIbrDQ6xZpOpzmQHeApCR4AKsKZ-83H5ubsg8yvNwY0jduT5NYC-3dralwBkD4k1eCQx-EU0bILTUXcyH6EHg1XBFVH5VF0y2BIFTBGOqoASmWmAigjnxUBkerOttLUipil9LdSVuWXzWry0wKfYjlBi7r2R55vkPAqYNKfi8dBmU-4VN-MNGjAphT-caL3BFs1-NccBpYnxZLVrDkTc6qm1p0CHFtyxuZwq_dgGFBxM7bG8T3ELGj8HefzLEzw5fXM8qY0SmC2XMDtjZ2GFG67GxfQGiZO-DKWloePmhrD8u6sW8sjTdxw2tg9co-aLee4dUxq1gq8Wm7Dsd2W07aP7XaL3Oest3pRu9F2MW4R7GDXJe32Mb7_D-Ol8gc?type=png)
```mermaid

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
