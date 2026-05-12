# Inception 
This project has been created as part of the 42 curriculum by pchatagn.

# Description

## Docker

Docker helps develop and run applications inside lightweight containers. Docker can be seen as a package containing everything necessary to run an application on any computer.

- The Dockerfile contains the instructions to build the image.
- The image is then used to create a container.

To run multiple containers as a single application, we use Docker Compose. Docker Compose uses a YAML file.

This project uses three separate services:
- Nginx
- WordPress
- MariaDB

### Why separate the services?

Each service runs inside its own container and handles a single responsibility.  
This makes the architecture cleaner, more modular, and easier to maintain.

---

# Nginx

Nginx is a web server. It receives requests from the browser and sends back the appropriate response. Nginx is known for its high performance, stability, and low resource consumption.

TLS (Transport Layer Security) is a security protocol used to establish secure communication between two parties over the Internet. It works using public key encryption.

OpenSSL is an open-source implementation of TLS. It is used to create and manage TLS certificates and private keys.

An SSL certificate can be seen as an identity card for the server that allows encrypted HTTPS communication.

For this project, TLSv1.3 is used because it is the fastest and most secure version.

**Listen on:** port 443

---

# WordPress

WordPress is a tool used to build websites without needing extensive coding knowledge. WordPress mainly uses PHP as its programming language.

FastCGI is a protocol that allows web servers to communicate with web applications such as PHP scripts.

PHP-FPM (PHP FastCGI Process Manager) is an implementation of the FastCGI protocol specifically designed for PHP.

### General workflow

- PHP-FPM runs as a separate daemon process on the server.
- Nginx forwards PHP requests to PHP-FPM.
- PHP-FPM executes the PHP application and sends the response back to Nginx.

**Listen on:** port 9000

---

# MariaDB

MariaDB is a relational database management system. It stores data in organized tables so applications can save, search, and retrieve information efficiently.

MariaDB can communicate either through:
- a network port (3306)
- a socket file (a special local communication file)

**Listen on:** port 3306

---

# Inception Workflow

1. The browser sends a request.
2. Nginx receives the request on port 443.
3. Nginx detects a PHP request and forwards it to PHP-FPM on port 9000.
4. PHP-FPM executes the WordPress PHP code.
5. WordPress asks MariaDB for the required content.
6. MariaDB returns the data.
7. WordPress builds the HTML page.
8. PHP-FPM sends the HTML back to Nginx.
9. Nginx sends the final HTML page back to the browser.
10. The user can see the WordPress website.

Nginx is the “door” of the project, WordPress is the “brain”, and MariaDB is the “memory”.

---

# Alpine Linux vs Debian

Docker images often use lightweight Linux distributions as a base to run applications.

## Alpine Linux

Alpine Linux is a lightweight Linux distribution designed to be fast, minimal, and secure.

### Advantages
- Much smaller Docker images
- Faster container startup
- Reduced disk space usage
- Smaller attack surface
- Well suited for microservices and containerized applications

### Disadvantages
- Some libraries or programs may be incompatible
- Debugging can be more difficult
- Fewer preinstalled tools
- Some software may require additional configuration

## Debian

Debian is a stable and complete Linux distribution widely used on servers and development environments.

### Advantages
- Very stable
- Compatible with most Linux software
- Easier dependency management
- Extensive documentation and community support

### Disadvantages
- Larger Docker images
- Longer download times
- Uses more system resources

---

# Virtual Machines vs Docker

A Virtual Machine (VM) allows multiple applications to run on a single server by simulating hardware and an entire operating system. A VM can be seen as a complete virtual computer.

Docker only virtualizes the application layer instead of the whole operating system.

Because of this, Docker containers:
- are lightweight
- start much faster
- consume less RAM and CPU resources

### Disadvantages of Docker

- Containers must use the same kernel as the host operating system
- If the host OS crashes, the containers will also stop

---

# Secrets vs Environment Variables

Two different methods can be used to provide information to containers.

## Environment Variables

Environment variables allow configuration values to be passed to a container at startup. They are generally stored inside a `.env` file.

### Advantages
- Easy to configure
- Easy to modify
- Commonly used in Docker projects

### Disadvantages
- Sensitive values may remain visible
- Passwords are stored in plain text
- Values may appear in:
  - `docker inspect`
  - logs
  - container processes

## Docker Secrets

Docker secrets allow sensitive information to be stored inside temporary files mounted into the container.

### Advantages
- More secure
- Passwords do not appear in `docker inspect`
- Limited access to authorized containers only
- Good practice for sensitive data

### Disadvantages
- More complex configuration
- Mainly designed for Docker Swarm
- Less commonly used in simple projects

In this project, environment variables are used for general service configuration, while Docker secrets are used to protect sensitive data such as passwords.

---

# Docker Network vs Host Network

Docker containers communicate through virtual networks.

## Docker Network (Bridge)

This is Docker’s standard networking mode.

Each container:
- has its own IP address
- has its own isolated network space
- communicates with other containers in a controlled way

### Advantages
- Container isolation
- More secure
- Simple communication between services
- No port conflicts

### Disadvantages
- Small network virtualization overhead
- Configuration can sometimes be more complex

## Host Network

Host Network mode directly uses the host machine’s network.

The container:
- does not have its own isolated network
- shares the host’s ports and network interfaces

### Advantages
- Better performance
- No port translation (`-p`)
- Direct access to the host network

### Disadvantages
- Less secure
- No network isolation
- Possible port conflicts
- Harder to isolate containers

In this project, the Docker bridge network is used because it is secure, simple to configure, and allows services to communicate while remaining isolated.

---

# Docker Volumes vs Bind Mounts

Docker can store data outside containers using different persistent storage systems.

## Docker Volumes

Docker Volumes are storage spaces managed directly by Docker. The data remains available even if the container is deleted.

### Advantages
- Managed directly by Docker
- Secure and isolated
- Easy to back up and move
- Recommended for persistent data
- Compatible with Docker Compose and Docker Swarm

### Disadvantages
- Files are less accessible from the host
- Docker-managed locations are less practical during development

## Bind Mounts

Bind Mounts directly link a directory from the host machine to a directory inside the container.

### Advantages
- Very useful during development
- File modifications are instantly visible
- Easy access to files from the host

### Disadvantages
- Less isolated
- Can create permission issues
- Less portable across different machines

In this project, Docker Volumes are used to store persistent data such as MariaDB data.

# Instructions

## Requirements

Before starting the project, make sure you have the following installed:

- Docker
- Docker Compose
- Make

---

## Installation

Clone the repository:

```bash
git clone <repository_url>
cd inception
```

---

## Project Structure

```bash
.
├── Makefile
├── secrets/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│       ├── nginx/
│       └── wordpress/
```

---

## Build and Start the Containers

To build and start all services:

```bash
make
```

or:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

---

## Stop the Containers

To stop the services:

```bash
make down
```

or:

```bash
docker compose -f srcs/docker-compose.yml down
```

---

## Remove Containers, Images and Volumes

To completely clean the project:

```bash
make fclean
```

This command removes:
- containers
- images
- networks
- volumes

---

## Access the Website

Once the containers are running, open your browser and go to:

```bash
https://localhost
```

or:

```bash
https://<your_login>.42.fr
```

depending on your configuration.

---

## Services

| Service | Port | Description |
|---|---|---|
| Nginx | 443 | HTTPS web server |
| WordPress | 9000 | PHP-FPM application |
| MariaDB | 3306 | Database server |

---

## Environment Variables

The project configuration is stored inside the `.env` file.

Example:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=user42
MYSQL_PASSWORD=password42
MYSQL_ROOT_PASSWORD=root42
DOMAIN_NAME=pchatagn.42.fr
```

---

## Useful Commands

### View running containers

```bash
docker ps
```

### View logs

```bash
docker logs <container_name>
```

### Enter a container

```bash
docker exec -it <container_name> sh
```

### List Docker volumes

```bash
docker volume ls
```

### List Docker networks

```bash
docker network ls
```

---

## Security

- HTTPS is enabled using TLSv1.3
- Passwords are stored using environment variables and Docker secrets
- Services are isolated using Docker networks

---


# Resources

## Docker
- Docker official docs: https://docs.docker.com/
- Docker Compose docs: https://docs.docker.com/compose/
- Dockerfile best practices: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
- The series on Docker on Youtube from the NewBoston.

## MariaDB
- MariaDB official docs: https://mariadb.com/kb/en/documentation/
- MariaDB on Alpine: https://wiki.alpinelinux.org/wiki/MariaDB

## WordPress
- WordPress official docs: https://developer.wordpress.org/
- WP-CLI docs: https://wp-cli.org/
- WP-CLI commands: https://developer.wordpress.org/cli/commands/

## Nginx
- Nginx official docs: https://nginx.org/en/docs/
- Nginx beginner's guide: https://nginx.org/en/docs/beginners_guide.html
- Nginx SSL config: https://nginx.org/en/docs/http/configuring_https_servers.html

## SSL/TLS
- OpenSSL docs: https://www.openssl.org/docs/
- TLS explained: https://www.cloudflare.com/learning/ssl/what-is-tls/

## Linux/Alpine
- Alpine Linux docs: https://wiki.alpinelinux.org/
- PID 1 in Docker: https://cloud.google.com/architecture/best-practices-for-building-containers#signal-handling

## AI
- Claude AI from anthropic was used to understand concepts and specific terms.
