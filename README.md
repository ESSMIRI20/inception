 # Inception

This project was created as part of the 42 curriculum by oessmiri.

Description
- Docker-based small infrastructure: NGINX (TLS), WordPress + php-fpm, MariaDB.

Instructions
- See `srcs/` and `USER_DOC.md` for usage and validation steps.

Resources
- https://docs.docker.com/compose/
- https://www.nginx.com/resources/wiki/start/topics/tutorials/

Project description
- This project demonstrates a small Docker-based infrastructure composed of an NGINX reverse proxy (TLS), a WordPress + php-fpm service, and a MariaDB database. All service images are built from Dockerfiles in `srcs/` and orchestrated with `docker-compose` and the provided `Makefile`.

Design choices and comparisons
- Virtual Machines vs Docker: Docker provides lightweight isolation and faster startup compared to full virtual machines; the project uses Docker for service isolation and portability while running inside a developer VM for the evaluation environment.
- Secrets vs Environment Variables: Environment variables (in `.env`) are used for non-sensitive runtime configuration. Sensitive data (passwords, credentials) must be stored outside the repository under the `secrets/` folder and referenced securely (e.g., Docker secrets) when possible.
- Docker Network vs Host Network: This project uses a user-defined Docker bridge network to isolate and connect containers; using host networking is forbidden because it exposes host interfaces and breaks container isolation.
- Docker Volumes vs Bind Mounts: Named Docker volumes are used for persistent data so Docker manages ownership and portability. Bind mounts are not allowed for the persistent WordPress data per the subject requirements.
