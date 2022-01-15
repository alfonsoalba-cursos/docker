# `Dockerfile` para craer proyectos de Rails

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Queremos disponer de una manera de generar esqueletos para proyectos en rails, como hicimos
en el taller anterior. Con una diferencia: no queremos que el código de la nueva aplicación
quede dentro del contenedor, porque eso no resulta especialmente útil.

Queremos generar el esqueleto de un proyecto en rails y que el código quede en nuestra máquina.

Para ello, utilizaremos varias funcionalides de `BuildKit`
* _Multi-stage builds_
* `--output`

## Los argumentos

¿Cuál es el formato del comando `rails`?

```shell
$ rails --help
Usage:
  rails new APP_PATH [options]

Options
...
```

Necesitamos pasarle dos argumentos: el nombre de la aplicación y las opciones.

Empezamos a construir nuestro `Dockerfile`:

```Dockerfile
# syntax=docker/dockerfile:1

FROM ruby:3.0
ARG RAILS_PARAMS
ARG RAILS_PROJECT_NAME
```

## Instalar rails dentro de la imagen

El siguiente paso será instalar la gema `rails` como hicimos en el taller anterior:

```Dockerfile
...
RUN gem install rails
```

## Crear el nuevo proyecto

Una vez tenemos rails instalado, podemos generar el proyecto, utilizando los 
valores que pasamos como argumento en las instrucciones anteriores:

```Dockerfile
...
RUN rails new $RAILS_PROJECT_NAME $RAILS_PARAMS
```

El fichero `Dockerfile` completo quedaría de la siguiente manera:

```Dockerfile
# syntax=docker/dockerfile:1

FROM ruby:3.0
ARG RAILS_PARAMS
ARG RAILS_PROJECT_NAME

RUN gem install rails
RUN rails new $RAILS_PROJECT_NAME $RAILS_PARAMS
```

## Extraer la aplicación en rails

Este fichero `Dockerfile` genera la aplicación en rails en la carpeta `/$RAILS_PROJECT_NAME` dentro del contenedor
por lo que una vez creada la imagen, tendremos que extraerlo:

* Generamos la imagen:
  ```shell
  $ docker buildx build --build-arg RAILS_PROJECT_NAME=blog -t dockerlabs/blog-tmp .
  ```

* Levantamos un contenedor que use esa imagen:
  ```shell
  $ docker container run --rm -ti --name blog-tmp -d dockerlabs/blog-tmp bash
  5aa65d607faa6f14e38e468de602b4bbfde86e01b7749cc91be8f725d373b9dd
  ```
* Extraemos la carpeta `/blog`
  ```shell
  $ docker container cp dockerlabs/blog-tmp:/blog .
  ```
* Paramos el contenedor (y se borra porque usamos la opción `--rm`)
  ```shell
  $ docker container stop blog-tmp
  ```

¿No habrá una forma más sencilla de hacerlo? 🤔

## _multi-stage builds_ y `--output`

Sí, si que existe. Podemos construir la imagen en dos pasos y utilizar la opción `--output` de BuildKit.

```Dockerfile
# syntax=docker/dockerfile:1

FROM ruby:3.0 AS build
ARG RAILS_PARAMS
ARG RAILS_PROJECT_NAME

RUN gem install rails
RUN rails new $RAILS_PROJECT_NAME $RAILS_PARAMS

FROM scratch
COPY --from=build /blog .
```

* En el primer paso (`FROM ruby:3.0 AS build`), ejecutamos todos los comandos de rails necesarios para crear el proyecto.
* En el siguiene paso (`FROM scratch`) construimos una única capa que solo contiene la carpeta `/blog`

Construimos la imagen y exportamos el contenido de esa capa a nuestro sistema de ficheros local:

```shell
$ docker buildx build \
-t dockerlabs/first-rails-generator \
--build-arg RAILS_PROJECT_NAME=blog \
--output dest=./blog,type=local \
.

[+] Building 61.7s (13/13) FINISHED                                                                                                                                                           
 => [internal] load build definition from Dockerfile                                                                              1.8s
 => => transferring dockerfile: 252B                                                                                              1.8s 
 => [internal] load .dockerignore                                                                                                 1.9s 
 => => transferring context: 2B                                                                                                   1.9s 
 => resolve image config for docker.io/docker/dockerfile:1                                                                        1.6s
 => [auth] docker/dockerfile:pull token for registry-1.docker.io                                                                  0.0s
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1357b3b2   0.0s
 => [internal] load build definition from Dockerfile                                                                              0.0s
 => [internal] load .dockerignore                                                                                                 0.0s 
 => [internal] load metadata for docker.io/library/ruby:3.0                                                                       0.0s 
 => CACHED [build 1/3] FROM docker.io/library/ruby:3.0                                                                            0.0s 
 => [build 2/3] RUN gem install rails                                                                                             9.5s 
 => [build 3/3] RUN rails new blog $RAILS_PARAMS                                                                                  15.3s
 => [stage-1 1/1] COPY --from=build /blog .                                                                                       0.1s
 => exporting to client                                                                                                           32.6s
 => => copying files 7.87MB                                                                                                       32.6s

```

En la carpeta local `./blog`, encontraremos nuestro proyecto en rails.

## `.dockerignore`

Para evitar que en sucesivas ejecuciones de estos comandos, se transfiera innecesariamente al contexto la carpeta `blog/`,
añadimos el fichero `.dockerignore`:

```text
blog/
```

## _One more thing_

Podemos reducir el tiempo que se tarda en crear un nuevo proyecto si creamos una imagen con rails ya instalado:

```Dockerfile
# syntax=docker/dockerfile:1

FROM ruby:3.0
RUN gem install rails
```

Construimos la imagen:

```shell
$ docker buildx build -t rails:7.0-ruby-3.0 -f Dockerfile_rails .
```

Cambiamos el fichero `Dockerfile`:

```Dockerfile
# syntax=docker/dockerfile:1

FROM rails:7.0-ruby-3.0 AS build
ARG RAILS_PARAMS
ARG RAILS_PROJECT_NAME

RUN rails new $RAILS_PROJECT_NAME $RAILS_PARAMS

FROM scratch
COPY --from=build /blog .
```

## Limpieza

---
⚠ si vas a continuar con el [siguiente taller](../dockerfile-for-our-rails-application/README_es.md), no borres
la carpeta `blog/`

---

Borramos la carpeta `blog` y las imágenes que hemos creado:
```shell
$ rm -rf blog
$ docker image rm dockerlabs/blog-tmp
% rails:7.0-ruby-3.0
```

Si no lo hicimos en el paso anterior, paramos y borramos el contenedor `blog-tmp`:
```shell
$ docker container stop blog-tmp
```

## Siguiente paso

En el [siguiente taller](../dockerfile-for-our-rails-application/README_es.md), empaquetaremos la aplicación
en una imagen.