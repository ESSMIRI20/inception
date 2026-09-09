# User documentation

- Start the project: `make up`
- Stop the project: `make down`
- Access the site: https://oessmiri.42.fr (make sure the domain points to your VM IP)
- Admin panel: https://oessmiri.42.fr/wp-admin
- Credentials: secrets/ contains password files. Keep them local and out of git.
- Check services: `docker ps` shows running containers; use `docker logs <container>` to inspect.

Details for users and administrators
- Services provided: NGINX (TLS reverse proxy), WordPress (php-fpm), MariaDB. NGINX is the only public-facing entrypoint on port 443.
- Domain configuration: set your DNS or `/etc/hosts` so that `yourlogin.42.fr` points to the VM IP (replace `yourlogin` with your learner login).
- Credentials and secrets: all secret files live in the `secrets/` folder and are ignored by git. The `.env` file in `srcs/` contains non-sensitive environment variables used by `docker-compose`.
- Verifying services:
	- `docker ps` — list running containers
	- `docker-compose -f srcs/docker-compose.yml logs --tail=200` — view recent logs
	- `docker exec -it <container> -- <command>` — run inspection commands inside a container
- Site and admin access:
	- Website: https://yourlogin.42.fr
	- Admin panel: https://yourlogin.42.fr/wp-admin
	- Replace `yourlogin` with your login used for the project (e.g., `oessmiri`).
