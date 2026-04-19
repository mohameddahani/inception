# User Documentation — Inception

> This guide is intended for **end users and administrators** who want to run, access, and manage the Inception web infrastructure. No deep technical knowledge.

---

## Table of Contents

- [What Services Are Provided?](#what-services-are-provided)
- [Starting the Project](#starting-the-project)
- [Stopping the Project](#stopping-the-project)
- [Accessing the Website](#accessing-the-website)
- [Accessing the Admin Panel](#accessing-the-admin-panel)
- [Managing Credentials](#managing-credentials)
- [Checking That Services Are Running](#checking-that-services-are-running)

---

## What Services Are Provided?

The Inception stack runs **three services**, each in its own isolated Docker container:

| Service | What it does | Accessible from |
|---------|-------------|-----------------|
| **NGINX** | Secure web server — the only entry point into the infrastructure via HTTPS (port 443) | Your browser at `https://mdahani.42.fr` |
| **WordPress** | The website application, powered by PHP-FPM | Through NGINX — not directly exposed |
| **MariaDB** | The database that stores all WordPress content | Internal only — not exposed outside the network |

> All three services communicate over a private Docker network. Only NGINX is reachable from the outside, on **port 443 (HTTPS)**.

---

## Starting the Project

### 1. Make sure Docker is running

```bash
docker info
```

If you see an error, start the Docker service:

```bash
sudo systemctl start docker
```

### 2. Start all services

From the **root of the project directory**:

```bash
make
```

This will:
- Create the required data directories on your host machine
- Build the Docker images (if not already built)
- Start all containers (NGINX, WordPress, MariaDB)

> The first run may take a few minutes while images are built.

---

## Stopping the Project

### Stop containers (keep data)

```bash
make stop
```

Containers are stopped but not removed. Your data (database, WordPress files) is preserved.

### Stop and remove containers + volumes

```bash
make clean
```

> This **removes all volumes** — your WordPress database and files will be deleted.

### Full reset (remove everything including images and cache)

```bash
make fclean
```

> This is a **complete wipe** — all containers, volumes, images, and local data under `/home/mdahani/data/` will be deleted.

---

## Accessing the Website

Once the project is running, open your browser and go to:

```
https://mdahani.42.fr
```

> Your browser may show a **security warning** about the certificate. This is expected because the project uses a self-signed TLS certificate. Click **"Advanced"** → **"Accept the Risk and Continue"** (or equivalent in your browser) to proceed.

You should see the WordPress homepage.

---

## Accessing the Admin Panel

The WordPress administration panel is available at:

```
https://mdahani.42.fr/wp-admin
```

Login with your admin credentials (see [Managing Credentials](#managing-credentials) below).

From the admin panel you can:
- Create, edit, and delete posts and pages
- Manage users
- Install themes and plugins
- Monitor site activity

---

## Managing Credentials

All credentials are defined in the `srcs/.env` file and stored in the `secrets/` directory at the root of the project.

### Admin account (WordPress)

| Field | Variable in `.env` |
|-------|--------------------|
| Username | `WP_ADMIN_USER` |
| Password | `WP_ADMIN_PASSWORD` |
| Email | `WP_ADMIN_EMAIL` |

### Regular user account (WordPress)

| Field | Variable in `.env` |
|-------|--------------------|
| Username | `WP_USER` |
| Password | `WP_USER_PASSWORD` |
| Email | `WP_USER_EMAIL` |

### Database credentials

| Field | Variable in `.env` |
|-------|--------------------|
| Database name | `DB_NAME` |
| DB username | `DB_USER` |
| DB password | `DB_PASSWORD` |

> **Never share or commit these files.** They are excluded from Git via `.gitignore`.

---

## Checking That Services Are Running

### List all running containers

```bash
docker ps
```

You should see three containers with status **Up**:

```
NAME                    STATUS
nginx_container         Up
wordpress_container     Up
mariadb_container       Up
```

### Check container logs

If something seems wrong, inspect the logs of a specific service:

```bash
# NGINX logs
docker logs nginx_container

# WordPress logs
docker logs wordpress_container

# MariaDB logs
docker logs mariadb_container
```

### Quick health check

| What to verify | How |
|----------------|-----|
| Website loads | Open `https://mdahani.42.fr` in browser |
| Admin panel works | Open `https://mdahani.42.fr/wp-admin` and log in |
| All containers up | `docker ps` |

### Check data directories exist

```bash
ls /home/mdahani/data/
```

You should see:

```
mariadb-data/   wordpress-data/
```

These directories contain your persistent data and should never be empty once the project has been started at least once.

---

*For developer setup and advanced configuration, refer to [DEV_DOC.md](./DEV_DOC.md)*