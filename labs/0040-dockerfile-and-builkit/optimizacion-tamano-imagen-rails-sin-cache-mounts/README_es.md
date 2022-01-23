# Optimización del tamaño de la imagen de Rails sin _cache mounts_

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Ilustrar cómo podemos reducir el tamaño de nuestras imágenes.

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el [taller anterior](../dockerfile-to-create-rails-projects/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta de este taller:

```shell
$ cp -r ../dockerfile-to-create-rails-projects/blog
```

## Actualización de paquetes

Una práctica habitual cuando utilizamos una imagen de terceros es actualizar los paquetes que se hayan instalado.

Entre el momento en el que se creó la imagen y el momento en el que nosotros generamos la nuestra, los paquetes
pueden haberse actualizado.

Incluiremos esta actualización en el fichero [`Dockerfile-sin-optimizar`](./Dockerfile-sin-optimizar) mediante la ejecución del siguiente comando:

```Dockerfile
...
RUN apt update && apt upgrade -y
...

```
## Añadir paquetes

También se dará el caso, muy habitual, de necesitar instalar paquetes adicionales dentro de la imagen. Por ejemplo,
si vamos a untilizar un cliente de postgres (cosa que haremos en el taller 
[Red _bridge_ para rails y postgres](../../0060-networking/red-bridge-para-rails-y-postgres/README_es.md))
Necesitaremos instalar el paquete en nuestra imagen.

En el caso que nos ocupa, vamos a instalar el paquete `vim` para poder editar ficheros dentro del contenedor.

Para hacerlo, añadimos la siguiente instrucción al fichero [`Dockerfile-sin-optimizar`](./Dockerfile-sin-optimizar):

```Dockerfile
RUN apt update && apt upgrade -y && \
    apt install -y vim
```

## Construimos la imagen

Construimos la imagen:

```shell
$ docker buildx build -t dockerlabs/0040-blog:no-optimizado -f Dockerfile-sin-optimizar .
```

Y vemos qué tamaño tiene: 

```shell
$ docker image inspect dockerlabs/0040-blog:no-optimizado --format '{{.Size}}'
1047629843
```

## Eliminando la caché de `apt`

Como consecuencia de ejecutar los comandos `apt` anteriores, en una de las capas de nuestra imagen,
estamos almacenando los paquetes `.deb` que nos hemos descargado, la lista de paquetes instalables, etc.
Esta información no hace falta en nuestra imagen, por lo que podemos eliminarla.

Creamos el fichero [`Dockerfile-optimizado`](./Dockerfile-optimizado) y añadimos las siguientes líneas:

```Dockerfile
...
RUN apt update && apt upgrade -y && \
    apt install -y vim && \
    apt clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log
...
```

Construimos la imagen:

```shell
$ docker buildx build -t dockerlabs/0040-blog:optimizado -f Dockerfile-optimizado .
```

Y vemos qué tamaño tiene: 

```shell
$ docker image inspect dockerlabs/0040-blog:optimizado --format '{{.Size}}'
1029721812
```
Hemos reducido la imagen en 17MB.


## _BuildKit cache mounts_

Como se describe en el taller [_BuildKit cache mounts_]() esta forma de optimizar las imágenes
se puede sustituir por el uso de volúmenes. Sin embargo, si no es posible utilizar BuildKit
y necesitamos usar el antiguo constructor de imágenes de docker, esta técnica para optimizar el tamaño
de las imágenes resutará útil.