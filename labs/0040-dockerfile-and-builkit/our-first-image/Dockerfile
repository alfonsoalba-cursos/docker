# syntax=docker/dockerfile:1
# Version: 0.0.1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
