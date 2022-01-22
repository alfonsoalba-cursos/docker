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

Ejecutamos un intérprete de comandos en el contenedor `rails-tutorial` y, una vez dentro, usamos el cliente
de postgres que instalamos para acceder a la base de datos

```shell
$ docker exec -ti rails-tutorial psql -U blog-development -h rails-tutorial
Password for user postgres: (recordatorio: 12345678)
psql (14.1 (Debian 14.1-1.pgdg110+1))
Type "help" for help.

postgres=# exit
```

## Instalando paquetes en el contenedor

Instalamos `vim` dentro del contendor:

```shell
root@210b0582271b:/blog$ apt install vim
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
E: Unable to locate package vim
```

Este error ocurre porque al generar la imagen borrarmos la caché de `apt` para hacer nuestra imagen más ligera.
Tenemos que actualizar la caché antes de instalar el paquete:

```shell
root@210b0582271b:/blog$ apt update && apt install -y vim
```

## Creando el blog

Para esta parte del taller, necesitaremos abrir un intérprete de comandos en el contenedor `rails-tutorial`
en el que ejecutaremos diversos comandos de Rails:

```shell
$ docker exec -ti rails-tutorial bash
root@210b0582271b:/blog$
```

### Configuración de la base de datos

Al estar utilizando un _bind volume_, podemos editar los ficheros directamente desde el host.

Editamos el fichero `blog/Gemfile` y añadimos la siguiente línea al principio del fichero:

```Gemfile
# Use sqlite3 as the database for Active Record
#gem "sqlite3", "~> 1.4"
gem "pg", "~> 1.2"
```

Dado que acabamos de modificar el código de nuestra aplicacion, **será necesario crear una nueva versión 
de la imagen que lo incluya**.


Guardar los cambios y ejecutar:

```shell
root@210b0582271b:/blog$ bundle install
...
...
Using actiontext 7.0.1
Using rails 7.0.1
Installing pg 0.18.4 with native extensions
Bundle complete! 17 Gemfile dependencies, 81 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

para instalar la dependencia. **Será necesario crear una nueva versión de la imagen que incluya
esta gema ya instalada. Si no lo hacemos, la próxima vez que alguien use nuestra imagen para levantar
la aplicación, esta no funcionará.**

Editamos el fichero `blog/config/database.yml` y sustituimos el contenido del fichero por
lo siguiente:

```yml

```

Probamos la conexión a la base de datos. Para hacerlo, ejecutaremos dos comandos de Rails: borraremos las bases de
datos que creamos en el [taller anterior](../../0050-volumes/postgres-database/README_es.md) y las
volveremos a crear:

```shell
root@210b0582271b:/blog# bin/rails db:drop
Dropped database 'blog-development'
Dropped database 'blog-test'

root@210b0582271b:/blog# bin/rails db:create
Created database 'blog-development'
Created database 'blog-test'
```

### Crear el blog

Dentro del contenedor ejecutamos el siguiente comando para crear un modelo, vistas y un controlador
que nos permitirán tener una aplicación básica en Rails:

```shell
root@210b0582271b:/blog# bin/rails g scaffold Article title:string body:text
      invoke  active_record
      create    db/migrate/20220122060833_create_articles.rb
      create    app/models/article.rb
      invoke    test_unit
      create      test/models/article_test.rb
      create      test/fixtures/articles.yml
      invoke  resource_route
       route    resources :articles
      invoke  scaffold_controller
      create    app/controllers/articles_controller.rb
      invoke    erb
      create      app/views/articles
      create      app/views/articles/index.html.erb
      create      app/views/articles/edit.html.erb
      create      app/views/articles/show.html.erb
      create      app/views/articles/new.html.erb
      create      app/views/articles/_form.html.erb
      create      app/views/articles/_article.html.erb
      invoke    resource_route
      invoke    test_unit
      create      test/controllers/articles_controller_test.rb
      create      test/system/articles_test.rb
      invoke    helper
      create      app/helpers/articles_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/articles/index.json.jbuilder
      create      app/views/articles/show.json.jbuilder
      create      app/views/articles/_article.json.jbuilder
```

Modificar el fichero `config/routes.rb` y descomentar la siguiente línea:

```ruby
Rails.application.routes.draw do
  resources :articles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index" <------------------ QUITAR COMENTARIO O AÑADIR
end
```

Añadimos la tabla a la base de datos:

```shell
root@210b0582271b:/blog# bin/rails db:migrate
== 20220122060833 CreateArticles: migrating ===================================
-- create_table(:articles)
   -> 0.0055s
== 20220122060833 CreateArticles: migrated (0.0056s) ==========================
```

Apuntamos el navegador a `http://localhost:3000` y obtendremos la página para crear, editar y borrar
artículos.

Nota: si esta página te da un error (por ejemplo que tienes una migración pendiente de la base de datos)
puede que necesitemos reiniciar el contenedor:

```shell
$ docker container restart rails-tutorial
```

## Modificaciones al Dockerfile


Llegados a este punto, necesitaremos crear una nueva imagen ya que:
* Hemos añadido un paquete (`vim`)
* Hemos modificado nuestro código
* Hemos añadido una dependencia a la aplicación (gema `pg`)

Modificamos el fichero `Dockerfile` ([verlo aquí](./Dockerfile_final_taller)) y generamos una nueva imagen
con el mismo tag:

```shell
$ docker buildx build -t dockerlabs/rails-tutorial:0060-bridge .
```

En un proyecto real, esta imagen tendría un tag distinto, indicándonos que hemos liberado una nueva versión de la
aplicación.
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

En el [siguiente taller](../../0070-docker-compose/aplicacion-rails-con-compose/README_es.md), 
pondremos todas las piezas juntas a trabajar usando `docker compose`.