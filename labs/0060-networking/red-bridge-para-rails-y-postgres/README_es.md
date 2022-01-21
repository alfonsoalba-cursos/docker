# Red _bridge_ para rails y postgres

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

* Dar el siguiente paso del tutorial de rails, que consiste en crear un modelo `Post`
y utilizar un generador CRUD para crear, modificar y borrar artículos del blog
* Ilustrar el uso de las redes de tipo _bridge_

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el [taller anterior](../dockerfile-to-create-rails-projects/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta a este taller:

```shell
$ cp -r ../../0040-dockerfile-and-buildkit/dockerfile-to-create-rails-projects/blog .
```

Por otro lado, utilizaremos el contenedor con la base de datos que creamos en el taller 
[Base de datos en postgres](../../0050-volumes/postgres-database/README_es.md)

## Los contenedores

Trabajaremos con dos contenedores:
* Uno contendrá nuestra aplicación en rails
* Otro contendrá la base de datos

Para conectarse entre sí, ambos contenedores utilizarán una red de tipo _bridge_.

## La red

Crearemos una red `_bridge_` que llamaremos `rails-tutorial`:

```shell
$ docker network create -d bridge rails-tutorial
56974db5a103398bef9f0a6e651520a5880f5aad6948c0fba0d945951c22e383
```

Podemos ver los detalles de la red usando:

```shell
docker network inspect rails-tutorial
[
    {
        "Name": "rails-tutorial",
        "Id": "56974db5a103398bef9f0a6e651520a5880f5aad6948c0fba0d945951c22e383",
        "Created": "2022-01-21T05:38:53.249882743Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```


## La aplicación rails

Usaremos el fichero [`Dockerfile`](./Dockerfile) facilitado en la carpeta de este taller para
construir la imagen de Rails. En esta imagen instalamos el cliente de postgres, que usaremos más
adelante para comprobar la conectividad con la base de datos

```shell
$ docker buildx build -t dockerlabs/rails-tutorial:0060-bridge .
```

Utilizaremos el tag `:0060-bridge` para diferenciar la imagen del resto de imágenes generadas en
otros talleres.

Una vez creada la imagen, creamos el contenedor:

```
$ docker run \
--detach \
-p 3000:3000 \
--rm -ti \
--name rails-tutorial \
--mount "type=bind,src=$(pwd)/blog,dst=/blog"  \
--network rails-tutorial \
dockerlabs/rails-tutorial:0060-bridge
```
Podemos comprobar que todo ha funcionado correctamente accediendo a `http://localhost:3000`.

## La base de datos

Utilizaremos un contenedor muy parecido al que usamos en el taller 
[# Base de datos en postgres](../../0050-volumes/postgres-database/README_es.md).
De hecho, usaremos el volumen `rails-tutorial-data` que generamos en ese taller para levantar
el contenedor.

Notar la opción `--network` que no utilizamos en el taller previo:

```shell
$ docker run --rm -d --name rails-tutorial-db --network rails-tutorial --mount type=volume,src=rails-tutorial-data,dst=/var/lib/postgresql/data postgres:14
```

Nota: no hemos utilizado las opciones `-e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres` ya que
el servidoe de base de datos está correctamente inicializado y estas variables no tienen ningún efecto.
Según se indica en la documentación, estas variables solo tienen efecto si la carpeta de datos
está vacía cuando se crea el contenedor (que no es el caso porque estamos usando el volumen del taller anterior).

Podemos verificar que el contenedor con la base de datos se ha levantado correctamente usando:

```shell
 docker exec -i -u postgres rails-tutorial-db psql -l
                                         List of databases
       Name       |  Owner   | Encoding |  Collate   |   Ctype    |        Access privileges
------------------+----------+----------+------------+------------+---------------------------------
 blog-development | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                   +
                  |          |          |            |            | postgres=CTc/postgres          +
                  |          |          |            |            | "blog-development"=CTc/postgres
 postgres         | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0        | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                    +
                  |          |          |            |            | postgres=CTc/postgres
 template1        | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                    +
                  |          |          |            |            | postgres=CTc/postgres
(4 rows)
```

## Accediendo a la base de datos desde el contenedor de Rails

```shell
$ docker exec -ti rails-tutorial psql -U postgres -h rails-tutorial-db
Password for user postgres: 
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# exit
```


## Limpieza

Tendremos que borrar:
* la imagen `dockerlabs/rails-tutorial:0060-bridge`
* el contenedor `rails-tutorial`
* el contenedor `rails-tutorial-db`
* el volumen `rails-tutorial-data`
* la red `rails-tutorial`


```shell
$ docker container stop rails-tutorial
$ docker image rm dockerlabs/rails-tutorial:2
$ docker container rm rails-tutorial
```

## Siguiente paso

Para poder trabajar con Rails, necesitaremos una base de datos. En el [siguiente taller](../labs\0050-volumes\rails-app-with-bind-volume/README_es.md) veremos cómo crearla y persistir los datos utilizando volúmenes.