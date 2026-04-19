DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

LOCAL_DIR = /home/mdahani/data/

all:
	@mkdir -p $(LOCAL_DIR)wordpress-data
	@mkdir -p $(LOCAL_DIR)mariadb-data
	$(DOCKER_COMPOSE) up

build:
	$(DOCKER_COMPOSE) build --no-cache

stop:
	$(DOCKER_COMPOSE) stop

clean: stop
	$(DOCKER_COMPOSE) down -v

fclean: clean
# 	Remove all unused images
	docker system prune -af
# 	Remove unused local volumes
	docker volume prune -f
	$(DOCKER_COMPOSE) down --rmi all
	@sudo rm -rf $(LOCAL_DIR)

rebuild: clean build all

.PHONY: build stop clean rebuild
