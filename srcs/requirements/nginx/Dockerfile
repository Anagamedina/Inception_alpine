FROM alpine:3.22

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl /var/run/nginx

COPY requirements/nginx/conf/nginx.conf /etc/nginx/http.d/default.conf
COPY requirements/nginx/tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 443

ENTRYPOINT ["sh", "/usr/local/bin/setup.sh"]
