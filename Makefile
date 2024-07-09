.PHONY: all build up down re restart logs ps clean fclean

name	= nginx

all: build up

build:
	@echo "Launching and building configuration ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

up:
	@echo "Stopping configuration ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@echo "Stopping configuration ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml down

re: down build
	@echo "Rebuilding configuration ${name}..."

restart: down up
	@echo "Restarting configuration ${name}..."

logs:
	@echo "Fetching logs for ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml logs

ps:
	@echo "Listing containers for ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml ps

clean: down
	@echo "Cleaning configuration ${name}..."
	@docker system prune -a --volumes -f

fclean: clean
	@echi "Deep cleaning configuration ${name}..."
	@docker stop $$(docker ps -qa)
	@docker network prune -f
	@docker volume prune -f
