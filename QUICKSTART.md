# 🚀 QUICK START - 5 Minute Setup

## Step 1: Edit Passwords (2 minutes)

Open `.env` file and change these passwords:

```bash
MYSQL_ROOT_PASSWORD=YourStrongPassword123!
WP1_DB_PASSWORD=YourWP1Password456!
MARIADB_ROOT_PASSWORD=YourMariaPassword789!
WP2_DB_PASSWORD=YourWP2Password012!
SFTP1_PASSWORD=YourSFTP1Password345!
SFTP2_PASSWORD=YourSFTP2Password678!
```

**Use strong passwords with:** letters, numbers, and special characters

---

## Step 2: Run Setup (1 minute)

```bash
chmod +x setup.sh
./setup.sh
```

---

## Step 3: Start Everything (1 minute)

```bash
docker-compose up -d
```

Wait 30-60 seconds for all services to start.

---

## Step 4: Add to Hosts File (1 minute)

### Linux/Mac:
```bash
sudo nano /etc/hosts
```

### Windows:
Open `C:\Windows\System32\drivers\etc\hosts` as Administrator

Add these lines:
```
127.0.0.1 site1.local www.site1.local
127.0.0.1 site2.local www.site2.local
127.0.0.1 pma1.local pma2.local
```

Save and close.

---

## Step 5: Access Your Sites!

Open your browser:

- **WordPress Site 1**: http://site1.local
- **WordPress Site 2**: http://site2.local
- **PHPMyAdmin 1**: http://pma1.local
- **PHPMyAdmin 2**: http://pma2.local

---

## 🎉 Done!

Complete the WordPress installation wizard in your browser.

### Default Database Credentials:

**Site 1 (PHPMyAdmin 1):**
- Server: `mysql`
- Username: `root`
- Password: (your `MYSQL_ROOT_PASSWORD` from .env)

**Site 2 (PHPMyAdmin 2):**
- Server: `mariadb`
- Username: `root`
- Password: (your `MARIADB_ROOT_PASSWORD` from .env)

---

## 📋 Quick Commands

```bash
# View status
docker-compose ps

# View logs
docker-compose logs -f

# Stop everything
docker-compose down

# Restart
docker-compose restart
```

---

## 🆘 Problems?

### Services not starting?
```bash
docker-compose logs
```

### Port 80 already in use?
```bash
sudo systemctl stop apache2
```

### Can't access sites?
- Check `/etc/hosts` file
- Make sure all containers are running: `docker-compose ps`
- Wait 60 seconds after starting for databases to initialize

---

## 📞 Test SFTP

```bash
# WordPress 1
sftp -P 2221 wp1user@localhost
# Password: your SFTP1_PASSWORD

# WordPress 2  
sftp -P 2222 wp2user@localhost
# Password: your SFTP2_PASSWORD
```

---

**That's it! You're ready to demonstrate the solution.**
