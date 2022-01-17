# _BuildKit cache mounts_

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Ilustrar el uso de `RUN --mount=type=cache`.

En el [laboratorio anterior](../dockerfile-for-our-rails-application/README_es.md), creamos un fichero `Dockerfile`
para ejecutar nuestra aplicación en Rails. En este laboratorio utilizaremos la opción `RUN --mount=type=cache`
para optimizar la construcción de nuestra imagen.

## El fichero `Dockerfile`

Utilizaremos el siguiente fichero [`Dockerfile`](./Dockerfile) para construir nuestra aplicación en Rails.

Las instrucciones relevantes son:

```dockerfile
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt update && apt upgrade && apt install -yq --no-install-recommends build-essential less curl openjdk-11-jre
```

El uso de `--mount=type=cache` creará dos volúmenes en tiempo de construcción que almacenarán los paquetes que se descarga
`apt`.

## Construir la imagen

Empezamos por purgar la caché, de forma que si ya hemos ejecutado el comando con anterioridad, los volúmenes de borrarán:

```shell
$ docker buildx prune
```

Construimos la imagen:

```shell
$ time docker buildx build -f Dockerfile -t dockerlabs/rails-tutorial --progress plain .
...
...
10 2.940 Need to get 76.7 MB of archives.
...
...

real    0m31.022s
user    0m0.437s
sys     0m0.238s
```

Vemos que al construir la imagen tiene que descargarse 76MB de paquetes.

Modificamos el Dockerfile y añadimos el paquete git. Si volvemos a crear la imagen:

```shell
$ time docker buildx build -f Dockerfile -t dockerlabs/rails-tutorial --progress plain .
...
...
10 1.987 Need to get 0 B/76.7 MB of archives.
...
...

real    0m21.374s
user    0m0.235s
sys     0m0.136s
```

Vemos que al ya tener los paquetes descargados, no se los vuelve a descargar. En este ejemplo
apenas son 76MB los que se tiene que descargar por lo que el ahorro de tiempo no es tan grande.
Esta misma técnica aplicada a la carpeta `node_modules` en un proyecto que utiliza nodeJs si que supone
un ahorro importante de tiempo.

## La aché no se transfiere a la imagen

Las carpetas que se cachean con esta opción no se transmiten a la imagen. Por este motivo, no podemos
utilizarla para hacer lo mismo con las gemas de ruby.

Modificar la instrucción del fichero `Dockerfile` y añadir una caché al paso que instala las gemas de ruby:

```dockerfile
RUN --mount=type=cache,target=/usr/local/bundle bundle install
```

Construimos la imagen:

```shell
$ time docker buildx build -f Dockerfile -t dockerlabs/rails-tutorial --progress plain .
```

Levantamos el contenedor:

```shell
$ docker run --rm -ti --name rails-tutorial dockerlabs/rails-tutorial
Could not find rails-7.0.1, sprockets-rails-3.4.2, sqlite3-1.4.2, puma-5.5.2, importmap-rails-1.0.2, turbo-rails-1.0.1, stimulus-rails-1.0.2, jbuilder-2.11.5, bootsnap-1.9.4, debug-1.4.0, web-console-4.2.0, capybara-3.36.0, selenium-webdriver-4.1.0, webdrivers-5.0.0, rspec-3.10.0, rspec-rails-5.0.2, actioncable-7.0.1, actionmailbox-7.0.1, actionmailer-7.0.1, actionpack-7.0.1, actiontext-7.0.1, actionview-7.0.1, activejob-7.0.1, activemodel-7.0.1, activerecord-7.0.1, activestorage-7.0.1, activesupport-7.0.1, railties-7.0.1, sprockets-4.0.2, nio4r-2.5.8, msgpack-1.4.2, irb-1.4.1, reline-0.3.1, bindex-0.8.1, addressable-2.8.0, matrix-0.4.2, mini_mime-1.1.2, nokogiri-1.13.1-x86_64-linux, rack-2.2.3, rack-test-1.1.0, regexp_parser-2.2.0, xpath-3.2.0, childprocess-4.1.0, rubyzip-2.3.2, rspec-core-3.10.1, rspec-expectations-3.10.2, rspec-mocks-3.10.2, rspec-support-3.10.3, websocket-driver-0.7.5, mail-2.7.1, net-imap-0.2.3, net-smtp-0.3.1, rails-dom-testing-2.0.3, rails-html-sanitizer-1.4.2, globalid-1.0.0, builder-3.2.4, erubi-1.10.0, marcel-1.0.2, concurrent-ruby-1.1.9, i18n-1.8.11, minitest-5.15.0, tzinfo-2.0.4, method_source-1.0.0, rake-13.0.6, thor-1.2.1, zeitwerk-2.5.3, io-console-0.5.11, public_suffix-4.0.6, racc-1.6.0, diff-lcs-1.5.0, websocket-extensions-0.1.5, digest-3.1.0, net-protocol-0.1.2, timeout-0.2.0, loofah-2.13.0, io-wait-0.2.1, crass-1.0.6 in any of the sources

Run `bundle install` to install missing gems.
```

¡Las gemas no están!

## Limpieza

Borrar la imagen `dockerlabs/rails-tutorial` y el contenedor `rails-tutorial` si no habéis usado la opción `--rm`

```shell
$ docker image rm dockerlabs/rails-tutorial
$ docker container rm rails-tutorial
```