#!/bin/sh

chown -R mysql:mysql /var/lib/mysql

# 1. Leer secretos si existen (Docker Secrets)
if [ -f "/run/secrets/db_password" ]; then
    SQL_PASSWORD=$(cat /run/secrets/db_password | tr -d '\n' | tr -d ' ')
fi
if [ -f "/run/secrets/db_root_password" ]; then
    SQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password | tr -d '\n' | tr -d ' ')
fi

# 2. Instala las tablas básicas si no existen
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# 3. Crea el archivo temporal SQL con tus variables
cat << EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;

-- Configuramos root para acceso local y remoto (Adminer)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Configuramos la base de datos y el usuario de la App
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';


FLUSH PRIVILEGES;
EOF

# 4. Ejecuta la configuración y lanza MariaDB (bootstrap)
mysqld --user=mysql --bootstrap < /tmp/init.sql
rm -f /tmp/init.sql

# 5. Iniciamos MariaDB de forma normal (PID 1)
echo "Iniciando MariaDB con Secrets como PID 1..."
exec mysqld --user=mysql --console
