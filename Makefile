.PHONY: build up down clean fclean
up:
	mkdir -p /home/oessmiri/data/wp_db /home/oessmiri/data/wp_files
	cd srcs && docker compose up -d --build

down:
	cd srcs && docker compose down

clean:
	cd srcs && docker compose down -v --rmi all --remove-orphans

fclean:
	cd srcs && docker compose down -v --rmi all --remove-orphans
	rm -rf /home/oessmiri/data/wp_db /home/oessmiri/data/wp_files || true
	mkdir -p /home/oessmiri/data/wp_db /home/oessmiri/data/wp_files
