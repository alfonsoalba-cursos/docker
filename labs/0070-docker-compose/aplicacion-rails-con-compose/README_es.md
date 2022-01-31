# Aplicación Rails con `docker compose`

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

En el taller [Red _bridge_ para rails y postgres](../../0060-networking/red-bridge-para-rails-y-postgres/README_es.md) 
levantamos manualmente una aplicación multicontenedor. En este caso con dos contenedores: el frontend en rails y
la base de datos con postgres. El objetivo de este taller es aprender a hacer lo mismo utilizando `Compose V2`.

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el taller 
[Red _bridge_ para rails y postgres](../../0060-networking/red-bridge-para-rails-y-postgres/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta a este taller:

```shell
$ cp -r ../../0060-networking/red-bridge-para-rails-y-postgres/blog .
```

Después de copiar el código, asegúrate de que el fichero `blog/tmp/pids/server.pid` no existe. Si existe, bórralo.

## Servicios

Crearemos un fichero `compose.yaml` que contendrá dos servicios:
* `rails`: contenedor con el código de nuestra aplicación y que ejecutará el servidor de aplicaciones. 
  Escuchará en el puerto 3000.
* `db`: contenedor con la base de datos

## El servicio `db`

Creamos el fichero `compose.yaml` y añadimos las siguientes líneas:

```yaml
---

services:
  db:
    image: postgres:14
    environment:
    - POSTGRES_PASSWORD=postgres
    - POSTGRES_USER=postgres
```

* `image`: declaramos qué imagen queremos usar para este contenedor
* `environment`: declaramos las mismas variables de entorno que usamos en el taller 
  [Base de datos en postgres](../../labs/0050-volumes/postgres-database/README_es.md). Con estas
  variables creamos el usuario root de la base de datos (como hicimos en ese taller)

Levantamos el servicio:

```shell
$ docker compose up db
[+] Running 2/0
 ⠿ Network 0070-rails-con-commpose_default  Created                                                                       0.0s
 ⠿ Container 0070-rails-con-commpose-db-1   Created                                                                       0.0s 
Attaching to 0070-rails-con-commpose-db-1
0070-rails-con-commpose-db-1  | The files belonging to this database system will be owned by user "postgres".
0070-rails-con-commpose-db-1  | This user must also own the server process.
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | The database cluster will be initialized with locale "en_US.utf8".
0070-rails-con-commpose-db-1  | The default database encoding has accordingly been set to "UTF8".
0070-rails-con-commpose-db-1  | The default text search configuration will be set to "english".
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | Data page checksums are disabled.
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | fixing permissions on existing directory /var/lib/postgresql/data ... ok
0070-rails-con-commpose-db-1  | creating subdirectories ... ok
0070-rails-con-commpose-db-1  | selecting dynamic shared memory implementation ... posix
0070-rails-con-commpose-db-1  | selecting default max_connections ... 100
0070-rails-con-commpose-db-1  | selecting default shared_buffers ... 128MB
0070-rails-con-commpose-db-1  | selecting default time zone ... Etc/UTC
0070-rails-con-commpose-db-1  | creating configuration files ... ok
0070-rails-con-commpose-db-1  | running bootstrap script ... ok
0070-rails-con-commpose-db-1  | performing post-bootstrap initialization ... ok
0070-rails-con-commpose-db-1  | syncing data to disk ... initdb: warning: enabling "trust" authentication for local connections
0070-rails-con-commpose-db-1  | You can change this by editing pg_hba.conf or using the option -A, or
0070-rails-con-commpose-db-1  | --auth-local and --auth-host, the next time you run initdb.
0070-rails-con-commpose-db-1  | ok
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | Success. You can now start the database server using:
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  |     pg_ctl -D /var/lib/postgresql/data -l logfile start
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | waiting for server to start....2022-01-22 06:59:24.744 UTC [49] LOG:  starting PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.745 UTC [49] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.748 UTC [50] LOG:  database system was shut down at 2022-01-22 06:59:24 UTC
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.752 UTC [49] LOG:  database system is ready to accept connections
0070-rails-con-commpose-db-1  |  done
0070-rails-con-commpose-db-1  | server started
0070-rails-con-commpose-db-1  | 
0070-rails-con-commpose-db-1  | /usr/local/bin/docker-entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.888 UTC [49] LOG:  received fast shutdown request
0070-rails-con-commpose-db-1  | waiting for server to shut down....2022-01-22 06:59:24.891 UTC [49] LOG:  aborting any active transactions
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.893 UTC [49] LOG:  background worker "logical replication launcher" (PID 56) exited with exit code 1
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.894 UTC [51] LOG:  shutting down
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:24.901 UTC [49] LOG:  database system is shut down
0070-rails-con-commpose-db-1  |  done
0070-rails-con-commpose-db-1  | server stopped
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | PostgreSQL init process complete; ready for start up.
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:25.008 UTC [1] LOG:  starting PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:25.008 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:25.008 UTC [1] LOG:  listening on IPv6 address "::", port 5432
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:25.010 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:25.013 UTC [61] LOG:  database system was shut down at 2022-01-22 06:59:24 UTC
0070-rails-con-commpose-db-1  | 2022-01-22 06:59:25.016 UTC [1] LOG:  database system is ready to accept connections
```

Abrimos una segunda consola. Podemos ver los contenedores que se han levantado utilizando:

```shell
$ docker compose ps
NAME                                 COMMAND                  SERVICE             STATUS              PORTS
aplicacion-rails-con-commpose-db-1   "docker-entrypoint.s…"   db                  running             5432/tcp
```

Notar que se ha utilizado como sufijo el nombre de la carpeta en la que se encuentra el fichero `compose.yaml`.

Podemos conectarnos a la base de datos utilizando el siguiente comando:

```shell
$ docker compose exec db psql -U postgres
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# \q
```

Este contenedor adolece del mismo problema que vimos en el taller 
[Base de datos en postgres](../../labs/0050-volumes/postgres-database/README_es.md): al no usar volúmenes
los cambios que hagamos en la base de datos no son persistentes. Arreglemos este problema.

Paramos los servicios que se están ejecutando:

```shell
$ docker compose down
[+] Running 2/2
 ⠿ Container 0070-rails-con-commpose-db-1   Removed    0.2s
 ⠿ Network 0070-rails-con-commpose_default  Removed    0.1s
```

Modifiquemos el fichero `Dockerfile`:

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
volumes:  
  rails-tutorial-db:
```

Hemos hecho dos modificaciones:
* Añadido la sección `volumes` en la que declaramos el volumen `rails-tutorial-db`. Este volumen
  está utilizando los drivers y la configuración por defecto
* Configurado el servicio `db` para que use el volumen y lo monte en `/var/lib/postgresql/data`

Levantamos de nuevo el servicio, y veremos que la base de datos se vuelve a crear (no se persistió en la ejecución anterior):

```shell
$ docker compose up db
(misma salida que arriba)
```

Si paramos el servicio y lo volvemos a levantar (necesitarás usar la segunda consola para pararlo):

```shell
$ docker compose down 
[+] Running 2/2
 ⠿ Container 0070-rails-con-commpose-db-1   Removed    0.0s
 ⠿ Network 0070-rails-con-commpose_default  Removed    0.1s 


$ docker compose up
[+] Running 2/0
 ⠿ Network 0070-rails-con-commpose_default  Created                                                                       0.0s
 ⠿ Container 0070-rails-con-commpose-db-1   Created                                                                       0.0s 
Attaching to 0070-rails-con-commpose-db-1
0070-rails-con-commpose-db-1  | 
0070-rails-con-commpose-db-1  | PostgreSQL Database directory appears to contain a database; Skipping initialization
0070-rails-con-commpose-db-1  |
0070-rails-con-commpose-db-1  | 2022-01-22 07:20:57.928 UTC [1] LOG:  starting PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
0070-rails-con-commpose-db-1  | 2022-01-22 07:20:57.928 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
0070-rails-con-commpose-db-1  | 2022-01-22 07:20:57.928 UTC [1] LOG:  listening on IPv6 address "::", port 5432
0070-rails-con-commpose-db-1  | 2022-01-22 07:20:57.930 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
0070-rails-con-commpose-db-1  | 2022-01-22 07:20:57.933 UTC [27] LOG:  database system was shut down at 2022-01-22 07:20:13 UTC
0070-rails-con-commpose-db-1  | 2022-01-22 07:20:57.937 UTC [1] LOG:  database system is ready to accept connections
```

Vemos que en la segunda ejecución, el servidor de base de datos no hace ninguna configuración y se 
levanta directamente.

Antes de continuar, crearemos los usuarios con los permisos correspondientes (`blog-development` y `blog-test`).
Utilizaremos para eso el fichero [`grants.sql`](./grants.sql):

```shell
$ docker compose exec db psql -U postgres < grants.sql
```

Antes de empezar la configuración del servicio para nuestra aplicación, paramos la base de datos:

```shell
$ docker compose down
```

## El servicio `rails`

Creamos el [fichero Dockerfile](./Dockerfile) que contendrá la imagen de nuestra aplicación.

Después, añadiremos el servicio `rails` al fichero `compose.yml` (mantén la configuración ya existente del servicio `db`):

```yaml
services:
  rails:
    image: rails-tutorial:0070-compose
    build:
      dockerfile: Dockerfile
      context: .
```

Añadimos también el fichero [`.dockerignore`](./.dockerignore) para evitar subir al contexto de construcción
y a la imagen de Rails, ficheros que no necesitamos.

Estamos listos para construir nuestra imagen:

```shell
$ COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker compose build rails
[+] Building 18.3s (14/14) FINISHED
 => [internal] load build definition from Dockerfile                                                                      0.0s
 => => transferring dockerfile: 643B                                                                                      0.0s 
 => [internal] load .dockerignore                                                                                         0.0s 
 => => transferring context: 2B                                                                                           0.0s 
 => resolve image config for docker.io/docker/dockerfile:1                                                                1.2s 
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1  0.0s
 => [internal] load build definition from Dockerfile                                                                      0.0s
 => [internal] load .dockerignore                                                                                         0.0s 
 => [internal] load metadata for docker.io/library/ruby:3.0                                                               0.0s 
 => [internal] load build context                                                                                         0.7s 
 => => transferring context: 13.25MB                                                                                      0.7s 
 => [1/5] FROM docker.io/library/ruby:3.0                                                                                 0.0s 
 => CACHED [2/5] RUN apt update && apt upgrade -y &&     sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt bullse  0.0s
 => [3/5] COPY ./blog /blog                                                                                               0.3s 
 => [4/5] WORKDIR /blog                                                                                                   0.1s
 => [5/5] RUN bundle install                                                                                             14.6s
 => exporting to image                                                                                                    1.0s
 => => exporting layers                                                                                                   1.0s
 => => writing image sha256:03d965c8830e23f77851169eecfaeb468131618b1bdca9db780388071168ae3e                              0.0s
 => => naming to docker.io/library/rails-tutorial:0070-compose                                                            0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
```

El siguiente paso es configurar el servicio para que levante un servidor de aplicaciones de Rails, exporte el puerto 3000
y monte un _bind volume_ con nuestro código, de forma que podamos editarlo y ver los cambios 
sin necesidad de volver a crear la imagen:

```yaml
  rails:
    image: rails-tutorial:0070-compose
    build:
      dockerfile: Dockerfile
      context: .
    environment:
    - RAILS_ENV=development
    volumes:
    - ./blog:/blog
    ports:
    - "3000:3000"
```

Antes de levantar el servicio, necesitaremos ejecutar las migraciones y crear la tabla
`articles` en la base de datos. Empezamod con la base de datos de desarrollo:

```shell
$ docker compose run --rm rails bin/rails db:migrate
== 20220122060833 CreateArticles: migrating ===================================
-- create_table(:articles)
   -> 0.0100s
== 20220122060833 CreateArticles: migrated (0.0101s) ==========================
```

Para hacer lo mismo en la base de datos `blog-test` debemos redefinir la variable de entorno `RAILS_ENV`:

```shell
$ docker compose run --rm -e RAILS_ENV=test rails bin/rails db:migrate
== 20220122060833 CreateArticles: migrating ===================================
-- create_table(:articles)
   -> 0.0038s
== 20220122060833 CreateArticles: migrated (0.0039s) ==========================
```

Por último, es necesario cambiar el fichero de configuración que utiliza la aplicación para conectarse a la base
de datos: `blog/config/database.yml`. En concreto, debemos verificar que el host de la base de datos
es `db`, es decir, **el nombre del servicio definido en `compose.yml`**:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  host: db  # <----------- Nombre del servicio
  pool: 5
  database: blog-development
  username: blog-development
  password: 12345678

test:
  adapter: postgresql
  encoding: unicode
  host: db # <----------- Nombre del servicio
  pool: 5
  database: blog-test
  username: blog-test
  password: 12345678
```

Hecha esta modificación, levantamos los dos servicios (`db` y `rails`):

```shell
$ docker compose up  
[+] Running 3/0
 ⠿ Network 0070-rails-con-commpose_default    Created    0.0s
 ⠿ Container 0070-rails-con-commpose-rails-1  Created    0.0s 
 ⠿ Container 0070-rails-con-commpose-db-1     Created    0.0s 
Attaching to 0070-rails-con-commpose-db-1, 0070-rails-con-commpose-rails-1
0070-rails-con-commpose-db-1     | 
0070-rails-con-commpose-db-1     | PostgreSQL Database directory appears to contain a database; Skipping initialization
0070-rails-con-commpose-db-1     |
0070-rails-con-commpose-db-1     | 2022-01-22 07:45:21.622 UTC [1] LOG:  starting PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
0070-rails-con-commpose-db-1     | 2022-01-22 07:45:21.622 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
0070-rails-con-commpose-db-1     | 2022-01-22 07:45:21.623 UTC [1] LOG:  listening on IPv6 address "::", port 5432
0070-rails-con-commpose-db-1     | 2022-01-22 07:45:21.625 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
0070-rails-con-commpose-db-1     | 2022-01-22 07:45:21.628 UTC [26] LOG:  database system was shut down at 2022-01-22 07:44:05 UTC
0070-rails-con-commpose-db-1     | 2022-01-22 07:45:21.632 UTC [1] LOG:  database system is ready to accept connections
0070-rails-con-commpose-rails-1  | => Booting Puma
0070-rails-con-commpose-rails-1  | => Rails 7.0.1 application starting in development 
0070-rails-con-commpose-rails-1  | => Run `bin/rails server --help` for more startup options
0070-rails-con-commpose-rails-1  | Puma starting in single mode...
0070-rails-con-commpose-rails-1  | * Puma version: 5.5.2 (ruby 3.0.3-p157) ("Zawgyi")
0070-rails-con-commpose-rails-1  | *  Min threads: 5
0070-rails-con-commpose-rails-1  | *  Max threads: 5
0070-rails-con-commpose-rails-1  | *  Environment: development
0070-rails-con-commpose-rails-1  | *          PID: 1
0070-rails-con-commpose-rails-1  | * Listening on http://0.0.0.0:3000
0070-rails-con-commpose-rails-1  | Use Ctrl-C to stop
```

Si apuntas tu navegador a `http://localhost:3000`, verás la aplicación para crear artículos.

## Redes, volúmenes y contenedores

Cuando ejecutamos `docker compose up`, ocurren varias _cosas_ antes de que nuestra aplicación se levante:
* Se crean los volúmenes que se hayan declarado en el fichero `compose.yaml`
  ```shell
  $ docker volume ls

  DRIVER    VOLUME NAME
  local     aplicacion-rails-con-commpose_rails-tutorial-db
  ```
* Se crea una red brige a la que los contenedores se conectan:
  ```shell
  $ docker network ls
  NETWORK ID     NAME                                    DRIVER    SCOPE
  e561f357a8b0   aplicacion-rails-con-commpose_default   bridge    local
  ```
* Se crean los contenedores:
  ```shell
  $ docker container ls
  CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
  c2b300cd6e18   postgres:14                   "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   5432/tcp                                    aplicacion-rails-con-commpose-db-1
  ca6b98f8be25   rails-tutorial:0070-compose   "bin/rails s -b 0.0.…"   7 seconds ago   Up 6 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   aplicacion-rails-con-commpose-rails-1
  ```
  también podemos utilizar el comando `docker compose ps` para ver únicamente los contenedores relacionados en 
  este proyecto

El comando `docker compose down`, borra la red _bridge_ pero no borra los volúmenes, a no ser que lo 
ejecutemos con la opción `--volumes` 

## Cambiando el prefijo

Como hemos visto, la red, los contenedores y los volúmenes se crean con el prefiho `aplicacion-rails-con-compose-*`, 
que es el nombre de la carpeta que contiene el fichero `compose.yaml`.

Podemos cambiar este prefijo usando la opción `-p` de los diferentes comandos de `docker compose`.

En la situación en la que estamos en este momento, si ejecutamos `docker compose -p 0070 up`, 
**se creará un nuevo volumen `0070-_rails-tutorial-db`**. Es decir, se volveran a inicializar las bases de datos
y no veremos los datos que ya tenemos en nuestra base de datos. Si queremos volver a utilizar ese volumen,
tendremos que renombrarlo `aplicacion-rails-con-commpose_rails-tutorial-db` -> `0070_rails-tutorial-db`.

Levantamos la aplicación con la opción `-p`:

```shell
$ docker compose -p 0070 up
```

Si miramos de nuevo los contenedores, volúmenes y redes, veremos que se ha utilizado el prefijo `0070`.

Paramos los servicios ejecutando:

```shell
$ docker compose -p 0070 down
```

## Lanzando los contenedores en segundo plano

Cuando ejecutamos el comando `docker compose up`, el comando se ejecuta en primer plano y por la consola
vemos los logs de los contenedores en ejecución.

Una práctica que resulta útil es el modo `--detach`, en el que el comando `docker compose up` lanza los
contenedores y se cierra, liberando la consola:

```shell
$ docker compose -p 0070 up -d
[+] Running 3/3
 ⠿ Network 0070_default    Created    0.0s 
 ⠿ Container 0070-rails-1  Started    0.5s 
 ⠿ Container 0070-db-1     Started    0.4s 
$ _
```

Si necesitamos ver los logs, podemos utilizar el comando `docker compose -p 0070 logs rails`:

```shell
$ docker compose -p 0070 logs rails
0070-rails-1  | => Booting Puma
0070-rails-1  | => Rails 7.0.1 application starting in development
0070-rails-1  | => Run `bin/rails server --help` for more startup options
0070-rails-1  | Puma starting in single mode...
0070-rails-1  | * Puma version: 5.5.2 (ruby 3.0.3-p157) ("Zawgyi")
0070-rails-1  | *  Min threads: 5
0070-rails-1  | *  Max threads: 5
0070-rails-1  | *  Environment: development
0070-rails-1  | *          PID: 1
0070-rails-1  | * Listening on http://0.0.0.0:3000
0070-rails-1  | Use Ctrl-C to stop
```

Disponemos de la opción `-f` si queremos seguir los logs en la consola (las líneas nuevas
aparecerán automáticamente cuando se generen).

## Resolución de errores

### `A server is already running. Check /blog/tmp/pids/server.pid.`

Si al levantar la aplicación, obtienes este error:

```shell
$ docker compose up  
[+] Running 3/3
 ⠿ Network 0070-rails-con-commpose_default    Created                                                                                                                                                                                                                                                                                           0.0s
 ⠿ Container 0070-rails-con-commpose-db-1     Created                                                                                                                                                                                                                                                                                           0.2s 
 ⠿ Container 0070-rails-con-commpose-rails-1  Created                                                                                                                                                                                                                                                                                           0.0s 
Attaching to 0070-rails-con-commpose-db-1, 0070-rails-con-commpose-rails-1
0070-rails-con-commpose-db-1     | 
0070-rails-con-commpose-db-1     | PostgreSQL Database directory appears to contain a database; Skipping initialization
0070-rails-con-commpose-db-1     |
0070-rails-con-commpose-db-1     | 2022-01-22 07:40:37.300 UTC [1] LOG:  starting PostgreSQL 14.1 (Debian 14.1-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
0070-rails-con-commpose-db-1     | 2022-01-22 07:40:37.300 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
0070-rails-con-commpose-db-1     | 2022-01-22 07:40:37.301 UTC [1] LOG:  listening on IPv6 address "::", port 5432
0070-rails-con-commpose-db-1     | 2022-01-22 07:40:37.303 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
0070-rails-con-commpose-db-1     | 2022-01-22 07:40:37.306 UTC [27] LOG:  database system was shut down at 2022-01-22 07:40:31 UTC
0070-rails-con-commpose-db-1     | 2022-01-22 07:40:37.309 UTC [1] LOG:  database system is ready to accept connections
0070-rails-con-commpose-rails-1  | => Booting Puma
0070-rails-con-commpose-rails-1  | => Rails 7.0.1 application starting in development 
0070-rails-con-commpose-rails-1  | => Run `bin/rails server --help` for more startup options
0070-rails-con-commpose-rails-1  | Exiting
0070-rails-con-commpose-rails-1  | A server is already running. Check /blog/tmp/pids/server.pid.
0070-rails-con-commpose-rails-1 exited with code 1
```
Borra para la aplicación con `docker compose down`, borra el fichero `blog/tmp/pids/server.pid` y vuelve a levantarla.

## Limpieza

------
⚠️ No borres los volúmenes si vas a realizar el siguiete taller
------


Tendremos que borrar:
* Parar los servicios
* Eliminar los volúmenes


```shell
$ docker compose down --volumes
$ docker compose -p 0070 down --volumes
```


## Siguiente paso

En el [siguiente taller](../cache-con-volumenes/README_es.md) veremos cómo podemos utilizar
volúmenes para cachear las gemas de nuestra aplicación y no tener que construir una nueva imagen
cada vez que añadimos una nueva dependencia.