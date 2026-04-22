# Developer Documentation — Inception

> This guide is intended for **developers** who want to set up, build, and manage the Inception infrastructure from scratch.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Configuration Files](#configuration-files)
- [Secrets Setup](#secrets-setup)
- [Building and Launching](#building-and-launching)
- [Makefile Reference](#makefile-reference)
- [Managing Containers and Volumes](#managing-containers-and-volumes)
- [Data Storage and Persistence](#data-storage-and-persistence)

---

## Prerequisites

Before setting up the project, make sure the following are installed and available on your Virtual Machine:

| Tool | Minimum Version | Check with |
|------|----------------|------------|
| Docker | 20.x+ | `docker --version` |
| Docker Compose | v2 (plugin) | `docker compose version` |
| make | any | `make --version` |
| sudo access | — | `sudo whoami` |

> This project **must** be run inside a Virtual Machine, as required by the 42 subject.

### Install Docker (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
```

---

## Environment Setup

### 1. Clone the repository

```bash
git clone https://github.com/mohameddahani/inception.git
cd inception
```

### 2. Configure your local domain

Add your domain to the system's hosts file so it resolves locally:

```bash
echo "127.0.0.1   mdahani.42.fr" | sudo tee -a /etc/hosts
```

### 3. Create data directories

The Makefile does this automatically on `make`, but you can also do it manually:

```bash
mkdir -p /home/mdahani/data/wordpress-data
mkdir -p /home/mdahani/data/mariadb-data
```

> These paths are defined in the Makefile via the `LOCAL_DIR` variable. If your login is different from `mdahani`, update the `LOCAL_DIR` in the Makefile accordingly.

---

## Configuration Files

### `.env` file

Create the environment file at `srcs/.env`:

```bash
touch srcs/.env
```

Fill it with the following (replace values as needed):

```env
# Domain
DOMAIN_NAME=your_domain_here

# MariaDB
DB_HOST=mariadb
DB_NAME=your_db_name
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# WordPress
WP_URL=https://your_domain_here
WP_TITLE=Your Website Title
WP_ADMIN_USER=your_admin_user
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=your_email@example.com

WP_USER=your_user
WP_USER_PASSWORD=your_user_password
WP_USER_EMAIL=user@example.com

# Redis (bonus)
WP_REDIS_HOST=redis
WP_REDIS_PORT=6379

# FTP (bonus)
FTP_USER=your_ftp_user
FTP_PASSWORD=your_ftp_password
```

> `.env` must be listed in your `.gitignore`. Never push credentials to a remote repository.

### `docker-compose.yml`

Located at `srcs/docker-compose.yml`. It defines:
- All services (nginx, wordpress, mariadb)
- The shared Docker network
- Named volumes and their mount points
- Environment variable injection from `.env`

The Makefile references it explicitly:

```makefile
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml
```

---

## Building and Launching

### Build images and start all services

```bash
make
```

This executes the following steps (from the Makefile):
1. Creates `/home/mdahani/data/wordpress-data` and `/home/mdahani/data/mariadb-data`
2. Runs `docker compose -f srcs/docker-compose.yml up`

Docker Compose will:
- Build each image from its respective `Dockerfile`
- Create the Docker network
- Mount the named volumes
- Start containers in dependency order (mariadb → wordpress → nginx)

### Build images without cache (force full rebuild)

```bash
make build
```

Runs `docker compose build --no-cache` — useful when Dockerfile changes aren't being picked up.

### Rebuild everything from scratch

```bash
make rebuild
```

Runs `clean` → `build` → `all` in sequence. Use this after major changes to ensure a clean state.

---

## Makefile Reference

```makefile
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml
LOCAL_DIR      = /home/mdahani/data/
```

| Target | Command | What it does |
|--------|---------|--------------|
| `make` or `make all` | `docker compose up` | Creates data dirs + starts all containers |
| `make build` | `docker compose build --no-cache` | Rebuilds all images without cache |
| `make stop` | `docker compose stop` | Stops containers, keeps data |
| `make clean` | `stop` + `docker compose down -v` | Stops + removes containers and volumes |
| `make fclean` | `clean` + prune + `rm -rf data/` | Full wipe: images, volumes, cache, local data |
| `make rebuild` | `clean` + `build` + `all` | Full clean rebuild from scratch |

> `fclean` also runs:
> - `docker system prune -af` — removes all unused images, containers, networks
> - `docker volume prune -f` — removes dangling volumes
> - `docker compose down --rmi all` — removes all images associated with the compose project
> - `sudo rm -rf /home/mdahani/data/` — removes host data directories

---

## Managing Containers and Volumes

### View running containers

```bash
docker ps
```

### View all containers (including stopped)

```bash
docker ps -a
```

### Follow live logs for a service

```bash
docker logs nginx_container
docker logs wordpress_container
docker logs mariadb_container
```

### Open a shell inside a running container

```bash
# Enter the WordPress container
docker exec -it wordpress_container bash

# Enter the MariaDB container
docker exec -it mariadb_container bash

# Enter the NGINX container
docker exec -it nginx_container sh
```

### Inspect a container (network, mounts, env vars)

```bash
docker inspect wordpress_container
docker inspect mariadb_container
docker inspect nginx_container
```

### List Docker volumes

```bash
docker volume ls
```

### Inspect a volume

```bash
docker volume inspect <name_of_volume>
```

### Remove a specific volume manually

```bash
docker volume rm <name_of_volume>
```

> Only do this when containers are stopped. Volume names are prefixed with the Compose project name (typically the parent directory name).

### List Docker networks

```bash
docker network ls
docker network inspect <name_of_network>
```

---

## Data Storage and Persistence

### Where data lives

All persistent data is stored on the **host machine** under:

```
/home/mdahani/data/
├── mariadb-data/     ← MariaDB database files
└── wordpress-data/   ← WordPress core files, themes, plugins, uploads
```

These directories are created by `make` and mounted into the containers via Docker named volumes defined in `docker-compose.yml`.

### How persistence works

```
Host filesystem                    Docker Volume              Container
────────────────────────────────────────────────────────────────────────
/home/mdahani/data/mariadb-data  ←── db_volume    ←── /var/lib/mysql
/home/mdahani/data/wordpress-data ←── wp_volume    ←── /var/www/html
```

- When a container is **stopped**, data remains in the volume
- When a container is **removed** (`make clean`), volumes and their data are **also removed**
- When `make fclean` is run, the host directories themselves are deleted with `sudo rm -rf`

### Verifying data persistence

After starting the project and creating a WordPress post, stop and restart:

```bash
make stop
make
```

Navigate to `https://mdahani.42.fr` — your content should still be there, confirming volumes are working correctly.

---

*For end-user instructions, refer to [USER_DOC.md](./USER_DOC.md)*