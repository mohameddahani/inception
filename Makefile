DOCKER_COMPOSE_DIR = docker compose -f srcs/docker-compose.yml

LOCAL_DIR = /home/mdahani/data/

all:
	@mkdir -p $(LOCAL_DIR)wordpress-data
	@mkdir -p $(LOCAL_DIR)mariadb-data
	$(DOCKER_COMPOSE_DIR) up

build:
	$(DOCKER_COMPOSE_DIR) build --no-cache

stop:
	$(DOCKER_COMPOSE_DIR) stop

clean: stop
	$(DOCKER_COMPOSE_DIR) down -v

fclean: clean
# 	Remove all unused images not just dangling ones 
	docker system prune -af
# 	Remove unused local volumes
	docker volume prune
	$(DOCKER_COMPOSE_DIR) down --rmi all
	@sudo rm -rf $(LOCAL_DIR)

rebuild: clean build all

.PHONY: build stop clean rebuild
