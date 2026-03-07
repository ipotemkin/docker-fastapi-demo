.PHONY: help up down build restart logs ps clean push shell-backend shell-frontend

COMPOSE = docker compose
REGISTRY = 194.87.130.247:5000
IMAGE_TAG ?= latest
BACKEND_IMAGE = docker-fastapi-demo-backend
FRONTEND_IMAGE = docker-fastapi-demo-frontend

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help           Show this help (default)"
	@echo "  up             Start all services (detached)"
	@echo "  down           Stop and remove containers"
	@echo "  build          Build images (no cache)"
	@echo "  push           Build images and push to $(REGISTRY)"
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

push:
	DOCKER_DEFAULT_PLATFORM=linux/amd64 $(COMPOSE) build
	docker tag $(BACKEND_IMAGE):$(IMAGE_TAG) $(REGISTRY)/$(BACKEND_IMAGE):$(IMAGE_TAG)
	docker tag $(FRONTEND_IMAGE):$(IMAGE_TAG) $(REGISTRY)/$(FRONTEND_IMAGE):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(BACKEND_IMAGE):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(FRONTEND_IMAGE):$(IMAGE_TAG)

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
