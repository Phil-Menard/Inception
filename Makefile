NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml
DOMAIN_NAME := pmenard.42.fr

.PHONY: all build up down clean fclean re

all: build up hosts

build:
	@echo "🔨 Building Docker images..."
	$(COMPOSE) build

up:
	@echo "🚀 Starting containers..."
	$(COMPOSE) up -d

hosts:
	@echo "Updating /etc/hosts for $(DOMAIN_NAME)..."
	@if ! grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
		echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts; \
	else \
		echo "$(DOMAIN_NAME) already in /etc/hosts"; \
	fi

down:
	@echo "🛑 Stopping containers..."
	$(COMPOSE) down

clean:
	@echo "🧹 Removing containers, networks, and volumes..."
	$(COMPOSE) down -v

fclean: clean
	@echo "🔥 Removing all images..."
	docker system prune -af

re: fclean all