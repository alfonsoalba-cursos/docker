# _Cache invalidation_

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.


## El fichero Dockerfile

Copiar el fichero `Dockerfile-bad` a `Dockerfile`:

```shell
$ cp Dockerfile-bad Dockerfile
```

El fichero `Dockerfile` contendrá las siguientes instrucciones:

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN mkdir -p /var/www/html/ && \
    echo '¡Hola! Soy el contenedor de Alfonso!!' \
    >/var/www/html/index.html
RUN apt-get update; apt-get install -y nginx
EXPOSE 80
```

Generamos la imagen ejecutando el siguiente comando:

 ```shell
$ docker buildx build -t dockerlabs/cache-invalidation .
 ```

 Esta imagen tarda entre 30 y 60 segundos en generarse.

 ## Modificar el código

 Editar el fichero `Dockerfile` y cambiar el contenido del fichero `index.html`:

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN mkdir -p /var/www/html/ && \
    echo '¡Hola! ¡Soy el contenedor de Alfonso!' \
    >/var/www/html/index.html
RUN apt-get update; apt-get install -y nginx
EXPOSE 80
```

Si volvemos a generar la imagen, esta vuelve a tardar entre 30 y 60 segundos:

 ```shell
$ docker buildx build -t dockerlabs/cache-invalidation .
 ```

 El motivo es que la haber modificado la primera instrucción `RUN`, se invalida
 la caché de esta instrucción y de todas las posteriores. Por eso es necesario
 volver a instalar los paquetes con `apt`.

## Utilizar la cache a nuestra favor

Copiar el fichero `Dockerfile-better` a `Dockerfile`:

```shell
$ cp -f Dockerfile-better Dockerfile
```

El fichero `Dockerfile` contendrá las siguientes instrucciones:

```Dockerfile
# syntax=docker/dockerfile:1# Version: 0.0.1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN mkdir -p /var/www/html/ && \
    echo '¡Hola! ¡Soy el contenedor de Alfonso!' \
    >/var/www/html/index.html
EXPOSE 80
```

Si os fijáis, las intrucciones `RUN` están en orden inverso. Volvemos a generar la imagen:

```shell
$ docker buildx build -t dockerlabs/cache-invalidation .
```

La imagen se ha generado en apenas unos segundos y está utilizando la cache para generar
la capa que ejecuta `apt`:

```shell
[+] Building 3.1s (10/10) FINISHED
 => [internal] load build definition from Dockerfile-better                                               0.4s
 => => transferring dockerfile: 334B                                                                      0.0s 
 => [internal] load .dockerignore                                                                         0.7s 
 => => transferring context: 2B                                                                           0.0s
 => resolve image config for docker.io/docker/dockerfile:1                                                1.3s
 => [auth] docker/dockerfile:pull token for registry-1.docker.io                                          0.0s
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed04  0.0s
 => => resolve docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf  0.0s 
 => [internal] load metadata for docker.io/library/ubuntu:latest                                          0.6s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                             0.0s
 => [1/3] FROM docker.io/library/ubuntu:latest@sha256:b5a61709a9a44284d88fb12e5c48db0409cfad5b69d4ff8224  0.0s
 => => resolve docker.io/library/ubuntu:latest@sha256:b5a61709a9a44284d88fb12e5c48db0409cfad5b69d4ff8224  0.0s 
 => CACHED [2/3] RUN apt-get update; apt-get install -y nginx                                             0.0s 
 => [3/3] RUN mkdir -p /var/www/html/ &&     echo '¡Hola! ¡Soy el contenedor de Alfonso!'     >/var/ww    0.1s 
```

Volvamos a modificar la instrucción `RUN` que genera el fichero `index.html`:

```Dockerfile
# syntax=docker/dockerfile:1# Version: 0.0.1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN mkdir -p /var/www/html/ && \
    echo '¡Hola! ¡Desde el contenedor de Alfonso!' \
    >/var/www/html/index.html
EXPOSE 80
```

Y generamos de nuevo la imagen:

```shell
$ docker buildx build -t dockerlabs/cache-invalidation .
```

Una vez más, se utiliza la caché para la capa que ejecuta `apt`. Hemos conseguido agilizar el proceso
de construcción de la imagen de forma sustancial, ya que no necesitamos ejecutar `apt` cada
vez que hagamos una modificación en el código.

## Limpieza

```shell
$ docker image rm dockerlabs/cache-invalidation
```
