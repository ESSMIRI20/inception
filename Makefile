.PHONY: build up down clean fclean
build:
	cd srcs && docker compose build

up:
	cd srcs && docker compose up -d --build

down:
	cd srcs && docker compose down

clean:
	cd srcs && docker compose down -v --rmi all --remove-orphans

fclean:
	cd srcs && docker compose down -v --rmi all --remove-orphans
	-docker volume rm srcs_wp_db srcs_wp_files || true
	rm -rf /home/ossama/data/wp_db /home/ossama/data/wp_files || true

test:
	chmod +x scripts/test.sh || true
	./scripts/test.sh
