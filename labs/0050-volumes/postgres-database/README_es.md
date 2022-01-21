# Base de datos en postgres

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Ilustrar el uso de los volúmenes.

Para poder levantar una aplicación en Rails y seguir con el siguiente paso del tutorial,
necesitamos disponer de una base de datos. En este taller levantaremos una base de datos
con postgres dentro de un contenedor de docker

Otro de los objetivos de este taller es el ver un ejemplo de cómo se documentan las imágenes para 
su utilización. Por ello, antes de ver la solución que expongo en detalle más abajo,
intenta llevar a cabo las siguientes tareas;
* Levantar el servidor de base de datos
* Crear un usuario administrador llamado `postgres` con contraseña `postgres` (la seguridad lo primero)
* Levantar una base de datos llamada `blog-development`
* Crear un usuario `blog-development` para esta base de datos, utilizando la contraseña `12345678`
* Conectarse al servidor postgres y verificar que el usuario y la base de datos existe
* La base de datos debe ser persistente. Es decir, si borramos el contenedor y lo volvemos a levantar,
  debemos seguir teniendo la base de datos y los usuarios creados

## La aplicación

Para este taller, aunque relacionado con la aplicación `blog` que hemos empezado a desarrollar,
no necesitaremos el código fuente.

## La imagen

Postgres mantiene una [imagen oficial en Docker Hub](https://hub.docker.com/_/postgres). Para nuestra aplicación
utilizaremos la versión 14 de postgres.

## Levantar el servidor (sin volúmenes)

Leyendo la documentación que se facilita en la imagen, necesitamos utilizar las siguientes variables para cumplir
con la tarea que hemos descrito en la sección _Objetivos_:

* `POSTGRES_PASSWORD=postgres`
* `POSTGRES_USER=postgres`

```shell
$ docker run  --rm -d --name rails-tutorial-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres postgres:14
94d1678ebcd1b0e2196ee4c4e45e023d6d5ddda742aea7db572e1daf7be93ea5
```

Para conectarnos a la base de datos, abiremos una terminal en el contenedor y utilizaremos el cliente instalado
en el mismo contenedor que contiene la imagen:

```shell
docker exec -ti -u postgres rails-tutorial-db psql
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=#
```

Salimos de la based de datos ejecutando `\q`

## Crear el usuario y la base de datos

Nos volvemos a conectar a la base de datos para crear el usuario y la base de datos `blog-development`

```shell
docker exec -ti -u postgres rails-tutorial-db psql
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# create database "blog-development" ;
CREATE DATABASE

postgres=# CREATE ROLE "blog-development" with PASSWORD '12345678' LOGIN;
CREATE ROLE

postgres=# grant all privileges on database "blog-development" to "blog-development";
GRANT

postgres=# \du
 blog-development |                                                            | {}
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
```

Salimos de la base de datos ejecutando `\d`

## La consecuencia de no usar volúmenes

Dado que no hemos usado volúmenes para levantar el contenedor, todas las modificaciones que hemos realizado
están persistidas en la capa del contenedor. Paramos el contenedor:

```shell
$ docker stop rails-tutorial-db
rails-tutorial-db
```

Si levantamos de nuevo el contenedor:

```shell
$ docker run  --rm -d --name rails-tutorial-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres postgres:14
2b8e8397f5f715167d3b2e08779ba1c100212a9947aab369ecca6be55de54794
```

Y listamos los usuario o las bases de datos, veremos que no están las que hemos creado:

```shell
docker exec -ti -u postgres rails-tutorial-db psql 
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres=# \d
Did not find any relations.
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres=# \q
```

Paramos de nuevo el contenedor:

```shell
$ docker stop rails-tutorial-db
rails-tutorial-db
```

## Levantar el servidor usando un volumen

Según se nos indica en la documentación de la imagen, dentro del contenedor el servidor de base de datos guarda los
ficheros en la carpeta `/var/lib/postgresql/data`.

Creamos el volumen `rails-tutorial-data`:

```shell
$ docker volume create rails-tutorial-data
rails-tutorial-data
```

Creamos de nuevo el contenedor con la opción `--mount` para montar el volumen:

```docker
$ docker run  --rm -d --name rails-tutorial-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres --mount type=volume,src=raisl-tutorial-data,dst=/var/lib/postgresql/data postgres:14
927f86222d5bd6aa3369eecb7f9bfbf87708fe18a5e3a7b3ea83f3c32cb68efd
```

Abrimos de nuevo un cliente utilizando `docker exec` y volvemos a crear el usuario y la base de datos usando los mismos 
comandos anteriores. Otra opción es usar el fichero [blog-development.psql](./blog-development.psql) para ejecutar los comandos:


```shell
$ docker exec -i -u postgres rails-tutorial-db psql < blog-development.psql 
CREATE DATABASE
CREATE ROLE
GRANT
```

⚠️ Para que este comando funcione es necesario utilizar la optión `-i`.

Paramos el contenedor (que al haberse ejecutado con la opción `--rm` se eliminará):

```shell
$ docker container stop rails-tutorial-db
rails-tutorial-db
```

Vemos que el volumen sigue disponible:

```shell
docker volume ls
DRIVER    VOLUME NAME
local     rails-tutorial-data
```

Podemos ver dónde está montado dentro del host utilizando el comando `docker volume inspect`:

```shell
$ docker volume inspect rails-tutorial-data[
    {
        "CreatedAt": "2022-01-20T18:22:04Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/rails-tutorial-data/_data",
        "Name": "rails-tutorial-data",
        "Options": {},
        "Scope": "local"
    }
]
```

Levantamos de nuevo el contenedor: 

```shel
docker run  --rm -d --name rails-tutorial-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres --mount type=volume,src=raisl-tutorial-data,dst=/var/lib/postgresql/data postgres:14
e55b25bfce7e43034400b6554d015b91a5b7752f27899a49a997e632eb759d53
```

En esta ocasión, no hemos perdido los datos, como podemos comprobar ejecutando de nuevo `\du` y `\l` a través del 
cliente de postgres:

```shell
$  docker exec -ti -u postgres rails-tutorial-db psqlpsql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# \l
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

postgres=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 blog-development |                                                            | {}
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres=# \q
```
## Limpieza

Borrar el contenedor `rails-tutorial-db` si no habéis usado la opción `--rm` y el volumen `rails-tutorial-data`

```shell
$ docker volume rm rails-tutorial-data
```