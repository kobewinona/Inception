.PHONY: all build up down re restart logs ps clean fclean

name	= inception

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
	@docker-compose -f ./srcs/docker-compose.yml down --volumes

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
	@echo "Deep cleaning configuration ${name}..."
	@docker ps -qa | xargs -r docker stop
	@docker network prune -f
	@docker volume prune -f
