# Portainer

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Instalar Portainer

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el taller 
[Red _bridge_ para rails y postgres](../../0060-networking/red-bridge-para-rails-y-postgres/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta a este taller:

```shell
$ cp -r ../../0060-networking/red-bridge-para-rails-y-postgres/blog .
```

Después de copiar el código, asegúrate de que el fichero `blog/tmp/pids/server.pid` no existe. Si existe, bórralo.

## Instalación

Creamos un volumen para almacenar la base de datos que utiliza la aplicación:

```shell
$ docker volume create portainer_data
portainer_data
```

Levantamos el contenedor con Portainer:

```shell
docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:2.11.0
```

Apuntar el navegador a `https://localhost:9443` y terminar la instalación creando un usuario administrador.

Portainer utiliza por derfecto un certificado _self-signed_ aunque es posible utilizar `certbot` o 
un certificado ya existente 
(ver [Using your own SSL certificate with Portainer](https://docs.portainer.io/v/ce-2.11/advanced/ssl#docker-standalone))


## Crear la imagen

Utilizaremos este fichero `Dockerfile` para construir la imagen:

```shell
$ docker buildx build -t blog:portainer .
```


## Crear nuestro propio _stack_ de servicios

Ir a la sección _Stack_ en el menú de la izquierda, y hacer click sobre el botón `Add stack`.

Introducir un nombre para el stack: `portainer-rails-tutorial`.

Hacer click en `Web Editor` y copiar y pegar la siguiente definición de servicios:

```yaml
---

services:
  db:
    image: postgres:14
    environment:
    - POSTGRES_PASSWORD=postgres
    - POSTGRES_USER=postgres
    volumes:
    - rails-tutorial-db:/var/lib/postgresql/data
    restart: always
  rails:
    image: blog:portainer
    ports:
    - "3030:3000"
    restart: always
volumes:
  rails-tutorial-db:
```

En la sección _Access Control_ podemos dejar el valor por defecto: _Administrators_

Hacer click sobre `Deploy the stack`.

Una vez creado el stack, podemos utillizar Portainer para hacer tareas administrativas como para el stack completo 
o alguno de sus contenedores, abrir una consola dentro del contenedor (docker exec), ver los consumos de memoria y procesador


## Limpieza

```shell
$ docker stop portainer
$ docker volume rm portainer_data
$ docker image rm blog:portainer
```