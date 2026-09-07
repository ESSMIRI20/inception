# Developer documentation

- Prerequisites: Docker and Docker Compose installed on your VM.
- Build images: `make build`
- Launch: `make up`
- Stop and clean: `make clean`
- Data locations: named Docker volumes are configured to persist to `/home/oessmiri/data/wp_db` and `/home/oessmiri/data/wp_files` on the host.
- Secrets: put real secrets into `secrets/*` (they are gitignored).
