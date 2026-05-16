#!/bin/sh

# Generar el certificado SSL usando la variable de entorno DOMAIN_NAME
echo "Generando certificado SSL para $DOMAIN_NAME..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=ES/ST=Barcelona/L=Barcelona/O=42/CN=$DOMAIN_NAME"

# Sustituir el nombre de dominio en el archivo de configuración de Nginx
# Usamos sed para cambiar 'server_name _;' por 'server_name $DOMAIN_NAME;'
sed -i "s/server_name anamedin.42.fr;/server_name $DOMAIN_NAME;/g" /etc/nginx/http.d/default.conf

echo "Iniciando Nginx..."
exec nginx -g "daemon off;"
