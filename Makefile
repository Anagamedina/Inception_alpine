NAME = inception
#COMPOSE = docker compose --env-file srcs/.env -f srcs/docker-compose.yml 
COMPOSE = docker compose -f srcs/docker-compose.yml 
DATA_PATH = /home/${USER}/data
LOGIN = anamedin

# Regla principal: levanta todo
all: setup build
	@printf "Lanzando configuración de ${NAME}...\n"
	${COMPOSE} up -d

# Crea los directorios necesarios, el archivo .env y los secretos si no existen
setup:
	@printf "Configurando entorno para ${NAME}...\n"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/static
	@mkdir -p $(DATA_PATH)/netdata/config
	@mkdir -p $(DATA_PATH)/netdata/lib
	@mkdir -p $(DATA_PATH)/netdata/cache
	@mkdir -p srcs/secrets
	@if [ ! -f srcs/.env ]; then \
		echo "Creando archivo .env..."; \
		echo "SQL_DATABASE=inception" > srcs/.env; \
		echo "SQL_USER=user42" >> srcs/.env; \
		echo "WP_URL=$(LOGIN).42.fr" >> srcs/.env; \
		echo "WP_TITLE=Inception" >> srcs/.env; \
		echo "WP_ADMIN_USER=$(LOGIN)_boss" >> srcs/.env; \
		echo "WP_ADMIN_EMAIL=$(LOGIN)@student.42.fr" >> srcs/.env; \
		echo "WP_USER=$(LOGIN)_visitor" >> srcs/.env; \
		echo "WP_USER_EMAIL=user@example.com" >> srcs/.env; \
		echo "NGINX_PORT=443" >> srcs/.env; \
		echo "USER=${USER}" >> srcs/.env; \
	fi
	@if [ ! -f srcs/secrets/db_password.txt ]; then \
		echo "Creando secreto db_password..."; \
		openssl rand -base64 16 > srcs/secrets/db_password.txt; \
	fi
	@if [ ! -f srcs/secrets/db_root_password.txt ]; then \
		echo "Creando secreto db_root_password..."; \
		openssl rand -base64 16 > srcs/secrets/db_root_password.txt; \
	fi
	@if [ ! -f srcs/secrets/wp_admin_password.txt ]; then \
		echo "Creando secreto wp_admin_password..."; \
		openssl rand -base64 16 > srcs/secrets/wp_admin_password.txt; \
	fi
	@if [ ! -f srcs/secrets/wp_user_password.txt ]; then \
		echo "Creando secreto wp_user_password..."; \
		openssl rand -base64 16 > srcs/secrets/wp_user_password.txt; \
	fi
	@if [ ! -f srcs/secrets/ftp_password.txt ]; then \
		echo "Creando secreto ftp_password..."; \
		openssl rand -base64 16 > srcs/secrets/ftp_password.txt; \
	fi

# Construye las imágenes
build:
	@printf "Construyendo imágenes de ${NAME}...\n"
	${COMPOSE} build 

# Detiene los contenedores
down:
	@printf "Deteniendo contenedores de ${NAME}...\n"
	${COMPOSE} down

# Levantar servicios individuales
mariadb: setup
	${COMPOSE} up -d mariadb

wordpress: setup
	${COMPOSE} up -d wordpress

nginx: setup
	${COMPOSE} up -d nginx

logs:
	${COMPOSE} logs -f

# Limpieza profunda
clean: down
	@printf "Limpiando imágenes de ${NAME}...\n"
	${COMPOSE} down --rmi all

# Borrado total
fclean: clean
	@printf "Borrando TODO (datos, volúmenes, imágenes) de ${NAME}...\n"
	${COMPOSE} down -v --rmi all
	@sudo rm -rf $(DATA_PATH)
	@rm -f srcs/.env
	@rm -rf srcs/secrets
	@docker system prune -af

re: fclean all

.PHONY: all build down clean fclean re setup logs mariadb wordpress nginx
