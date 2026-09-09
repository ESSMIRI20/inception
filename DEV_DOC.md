# Developer documentation

- Prerequisites: Docker and Docker Compose installed on your VM.
- Build images: `make build`
- Launch: `make up`
- Stop and clean: `make clean`
- Data locations: The project uses named Docker volumes for persistent storage. The volumes are configured so their data ends up in `/home/<your_login>/data/wp_db` and `/home/<your_login>/data/wp_files` on the host (replace `<your_login>` with your learner username). These must remain named volumes (bind mounts are not allowed for the required persistent storages).
- Environment and secrets:
	- Use `srcs/.env` for non-sensitive environment variables required by `docker-compose`.
	- Place any credentials and sensitive files in the `secrets/` directory and keep them out of version control. For advanced handling, use Docker secrets where appropriate.

Setup from scratch
	- Ensure Docker and Docker Compose are installed on the VM.
	- Populate `secrets/` (e.g., `db_password.txt`, `db_root_password.txt`) with passwords and ensure they are readable by the build/user as needed.
	- Edit `srcs/.env` to set `DOMAIN_NAME` to `yourlogin.42.fr` and other variables before building.

Build and launch
	- `make build` — builds all Docker images using `docker-compose.yml` and the Dockerfiles in `srcs/requirements/*`.
	- `make up` — starts the stack (containers, network, volumes). NGINX will be the only public entrypoint (port 443).

Useful developer commands
	- `docker-compose -f srcs/docker-compose.yml ps`
	- `docker-compose -f srcs/docker-compose.yml logs --follow`
	- `docker volume ls` and `docker volume inspect <volume>` to inspect named volumes and host paths.
