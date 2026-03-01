.PHONY: help up down build restart logs ps clean shell-backend shell-frontend

COMPOSE = docker compose

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help           Show this help (default)"
	@echo "  up             Start all services (detached)"
	@echo "  down           Stop and remove containers"
	@echo "  build          Build images (no cache)"
	@echo "  restart        Restart all services"
	@echo "  logs           Follow logs of all services"
	@echo "  ps             List running containers"
	@echo "  clean          Stop containers and remove project images"
	@echo "  shell-backend  Open shell in backend container"
	@echo "  shell-frontend Open shell in frontend container"

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build --no-cache

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean: down
	$(COMPOSE) down --rmi local -v

shell-backend:
	$(COMPOSE) exec backend sh

shell-frontend:
	$(COMPOSE) exec frontend sh
