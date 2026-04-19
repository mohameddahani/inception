# 🐳 Inception

*This project has been created as part of the 42 curriculum by mdahani*

---

## 📌 Table of Contents

- [Description](#description)
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Instructions](#instructions)
- [Usage](#usage)
- [Key Concepts](#key-concepts)
- [Design Choices](#design-choices)
- [Docker Command Reference](#docker-command-reference)
- [Resources](#resources)

---

## 📖 Description

**Inception** is a system administration project from the 42 curriculum that focuses on containerizing a complete web infrastructure using **Docker** and **Docker Compose**.

The goal is to build and orchestrate three interdependent services — each running in its own dedicated container — forming a secure, production-inspired environment:

| Service | Role |
|---------|------|
| **NGINX** | Reverse proxy & sole HTTPS entry point (TLSv1.2/1.3) |
| **WordPress + PHP-FPM** | Application layer (no web server inside) |
| **MariaDB** | Relational database for WordPress |

Key guarantees of the infrastructure:
- 🔒 **Encrypted communication** via TLS certificates
- 📦 **Service isolation** — one process per container
- 💾 **Data persistence** through named Docker volumes
- 🔁 **Auto-restart** on container crash
- 🔐 **Secret management** using environment variables and `.env` files

---

## 🏗️ Architecture Overview

```
                        [ Browser ]
                            |
                         port 443 (HTTPS / TLS)
                            |
                     ┌──────────────┐
                     │    NGINX     │  ← Only entry point
                     └──────┬───────┘
                            │ FastCGI (port 9000)
                     ┌──────▼───────┐
                     │  WordPress   │
                     │  (PHP-FPM)   │
                     └──────┬───────┘
                            │ MySQL protocol (port 3306)
                     ┌──────▼───────┐
                     │   MariaDB    │
                     └──────────────┘

        All containers communicate via: docker-network (bridge)

        Volumes:
        ├── db_volume    → /home/mdahani/data/mariadb-data
        └── wp_volume    → /home/mdahani/data/wordpress-data
```

---

## 📂 Project Structure

```
inception/
├── Makefile
├── README.md
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── bonus/
        │   ├── adminer/
        │   │   ├── Dockerfile
        │   │   └── tools/
        │   │       └── script.sh
        │   ├── cadvisor/
        │   │   └── Dockerfile
        │   ├── FTP/
        │   │   ├── Dockerfile
        │   │   ├── conf/
        │   │   │   └── vsftpd.conf
        │   │   └── tools/
        │   │       └── script.sh
        │   ├── redis/
        │   │   ├── Dockerfile
        │   │   └── tools/
        │   │       └── script.sh
        │   └── static-website/
        │       ├── Dockerfile
        │       └── tools/
        │           └── script.sh
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/
        │       └── script.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── wordpress.conf
        │   └── tools/
        │       └── script.sh
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── script.sh
```

---

## ⚙️ Instructions

### Prerequisites

- A Virtual Machine (required by the subject)
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- `make` utility

---

### 1. Clone the repository

```bash
git clone https://github.com/mohameddahani/inception.git
cd inception
```

---

### 2. Configure environment variables

Create a `.env` file inside the `srcs/` directory:

```bash
touch srcs/.env
```

Populate it with the following variables:

```env
# Domain
DOMAIN_NAME=mdahani.42.fr

# MariaDB
DB_HOST=mariadb
DB_NAME=my_wordpress_db
DB_USER=my_wordpress_usr
DB_PASSWORD=your_db_password

# WordPress
WP_URL=https://mdahani.42.fr
WP_TITLE=My Website
WP_ADMIN_USER=mdahani
WP_ADMIN_PASSWORD=your_admin_password
WP_ADMIN_EMAIL=mdahani@student.1337.ma
WP_USER=bounati
WP_USER_PASSWORD=your_user_password
WP_USER_EMAIL=bounati@student.1337.ma

# Redis (bonus)
WP_REDIS_HOST=redis
WP_REDIS_PORT=6379

# FTP (bonus)
FTP_USER=ftp_mdahani
FTP_PASSWORD=your_ftp_password
```

> ⚠️ **Security Note:** Never commit `.env` or any secrets file to your Git repository. These are listed in `.gitignore`.

---

### 3. Configure your local domain

Add the following line to your `/etc/hosts` file on the host machine:

```
127.0.0.1   mdahani.42.fr
```

---

### 4. Build and run the project

```bash
make
```

This will:
1. Build all Docker images from their respective `Dockerfile`s
2. Create Docker volumes and network
3. Start all containers via `docker-compose`

---

### Makefile Targets

| Command | Description |
|---------|-------------|
| `make` | Build images and start all containers |
| `make stop` | Stop all running containers |
| `make clean` | Stop and remove containers + volumes |
| `make build` | Rebuild all images without cache |
| `make fclean` | Full clean: containers, volumes, and build cache |
| `make rebuild` | Full clean + rebuild from scratch |

---

## 🌐 Usage

Once the project is running, open your browser and navigate to:

```
https://mdahani.42.fr
```

You should see the WordPress website. To access the admin dashboard:

```
https://mdahani.42.fr/wp-admin
```

Login with the `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD` from your `.env` file.

> 🔐 The browser may warn about a self-signed certificate — this is expected. Accept the exception to continue.

---

## 💡 Key Concepts

### What is Docker?

Docker is an open platform for developing, shipping, and running applications inside isolated environments called **containers**. It allows you to separate your application from the infrastructure, enabling faster delivery cycles.

### What is a Container?

A container is a lightweight, standalone executable package that includes everything needed to run a piece of software: code, runtime, libraries, and system tools — but **without its own OS**. It shares the host's kernel, making it far more efficient than a Virtual Machine.

### What is a Docker Image?

A Docker Image is a read-only template used to create containers. It is built from a `Dockerfile` and contains the application code and all its dependencies.

### What is a Dockerfile?

A `Dockerfile` is a text file with a set of instructions that Docker uses to build an image automatically. Each instruction creates a new layer in the image.

### What is Docker Compose?

Docker Compose is a tool for defining and running **multi-container** Docker applications. You describe your services, networks, and volumes in a single `docker-compose.yml` file and manage them with one command.

### What is a Docker Volume?

A Docker Volume is a persistent storage mechanism managed by Docker. Data stored in a volume **survives** container restarts and deletions — essential for databases and application files.

### What is Docker Network?

Docker Networks allow containers to communicate with each other in an isolated environment. A custom bridge network is used in this project so services can reach each other by name (e.g., `mariadb`, `wordpress`).

---

## 🔍 Design Choices

### Virtual Machines vs Docker

| | Virtual Machines | Docker |
|---|---|---|
| **OS** | Full OS per VM | Shares host kernel |
| **Weight** | Heavy (GBs) | Lightweight (MBs) |
| **Startup** | Minutes | Seconds |
| **Isolation** | Strong (hardware-level) | Process-level |
| **Use case** | Full OS emulation | Microservices / apps |

**Conclusion:** Docker is more suited for this project's microservice-style architecture where each service is isolated but lightweight.

---

### Secrets vs Environment Variables

| | Environment Variables | Docker Secrets |
|---|---|---|
| **Storage** | Plain text in `.env` | Encrypted at rest |
| **Visibility** | Accessible in shell | Only exposed to specific services |
| **Use case** | Config / non-sensitive data | Passwords, API keys |
| **Ease of use** | Simple | Slightly more complex setup |

**In this project:** `.env` is used for general configuration. Sensitive values like passwords are stored in the `secrets/` directory and excluded from version control.

---

### Docker Network vs Host Network

| | Docker Network (bridge) | Host Network |
|---|---|---|
| **Isolation** | Full isolation between containers | Shares host network stack |
| **Security** | More secure | Less secure |
| **DNS** | Container name resolution | Not available |
| **Allowed?** | ✅ Yes | ❌ Forbidden by subject |

**Conclusion:** A custom Docker bridge network is used so containers communicate securely by service name, without exposing anything to the host network directly.

---

### Docker Volumes vs Bind Mounts

| | Docker Volumes | Bind Mounts |
|---|---|---|
| **Managed by** | Docker daemon | Host filesystem |
| **Portability** | High | Low (path-dependent) |
| **Persistence** | Yes | Yes |
| **Allowed?** | ✅ Required | ❌ Forbidden for required volumes |

**Conclusion:** Named Docker volumes are used for both the MariaDB database and the WordPress files to ensure portability and proper Docker-managed persistence.

---

## 🛠️ Docker Command Reference

```bash
# Container management
docker container ls -a          # List all containers (running + stopped)
docker run --name <name> <img>  # Create and run a named container
docker start / stop / restart   # Manage container lifecycle
docker rm <name>                # Remove a container
docker rm $(docker ps -aq) -f   # Remove all containers

# Image management
docker image ls                 # List all images
docker rmi <image>              # Remove an image
docker rmi $(docker images -q) -f  # Remove all images
docker build -t <name>:<tag> .  # Build image from Dockerfile

# Networking
docker network ls               # List networks
docker network create <name>    # Create a custom network
docker network inspect <name>   # Inspect a network

# Volumes
docker volume ls                # List volumes
docker volume prune -f          # Remove unused volumes

# Compose
docker compose up               # Start services
docker compose down             # Stop and remove containers
docker compose down -v          # Also remove volumes
docker compose build --no-cache # Rebuild without cache

# System
docker system prune -af         # Remove all unused Docker data
```

---

## 📚 Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)
- [WordPress Developer Resources](https://developer.wordpress.org/)

### Books
- `Docker Deep Dive: Zero to Docker in a single book` by Nigel Poulton
Comprehensive guide covering Docker fundamentals, networking, volumes, and orchestration

### Guides & Tutorials
- [WordPress + PHP-FPM + NGINX + MariaDB on Ubuntu VPS](https://forumweb.hosting/blog/deploying-a-wordpress-site-on-an-ubuntu-vps-with-nginx-php-fpm-and-mariadb/)
- [Enable SSL in NGINX (HTTPS on port 443)](https://medium.com/@charanv369/enable-ssl-in-nginx-server-to-access-the-application-on-https-port-443-1bcd52667b08)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

### AI Usage
AI tools (Claude & ChatGPT) were used in this project strictly for deep conceptual understanding of Docker internals and architecture, including:

- Understanding Docker architecture (Docker Client, Docker Daemon, containerd, shim, runc)
- Exploring how components communicate (HTTP/REST API, Unix socket, gRPC)
- Learning container lifecycle internals (creation, execution, isolation)

Advanced topics explored with AI:

- Docker API interaction via Unix socket (/var/run/docker.sock)
- Image layers, OverlayFS, and caching mechanisms

All AI-generated explanations were carefully reviewed and validated.
No AI-generated code was used, and no project tasks were solved using AI.

---

## 📝 Notes

- `CMD` can be **overridden** at runtime (`docker run <image> <new_cmd>`)
- `ENTRYPOINT` **cannot be overridden** without the `--entrypoint` flag — it defines the container's main process
- Avoid `tail -f`, `sleep infinity`, or `while true` as entrypoints — use proper daemon processes instead
- Always follow PID 1 best practices to ensure correct signal handling inside containers

---

*Built with 🐳 Docker | 42 School — System Administration Project*