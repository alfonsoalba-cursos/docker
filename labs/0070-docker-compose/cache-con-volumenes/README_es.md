# Caché con volúmenes

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

En el taller [Aplicación Rails con `docker compose`](../aplicacion-rails-con-compose/README_es.md) 
levantamos nuestra aplicación rails multicontenedor utilizando `Compose V2`.

Esta aplicación tiene un problema: cada vez que necesitemos añadir una nueva gema o un nuevo
paquete de npm, tendremos que crear una nueva imagen. 

El objetivo de este taller es ilustrar cómo podemos utilizar volúmenes para cachear estas dependencias
y evitar construir la imagen cuando estas cambian.

⚠️ Esta técnica es aplicable en entornos en los que necesitamos una manera
rápida de cambiar el código y probar que funciona. Entorno típico es el de desarrollo. 
En los entornos de producción las dependencias formarán parte de la imagen y necesitaremos
construir una nueva cuándo estas cambien.

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el taller 
[Aplicación Rails con `docker compose`](../aplicacion-rails-con-compose/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta de este taller:

```shell
$ cp -r ../aplicacion-rails-con-compose/blog .
```

Después de copiar el código, asegúrate de que el fichero `blog/tmp/pids/server.pid` no existe. Si existe, bórralo.

## Servicios

Crearemos un fichero `compose.yaml` que contendrá los mismos servicios que utilizamos en el taller
[Aplicación Rails con `docker compose`](../aplicacion-rails-con-compose/README_es.md). Puedes ver la descripción
detallada de estos servicios en ese taller:

* `rails`: contenedor con el código de nuestra aplicación y que ejecutará el servidor de aplicaciones. 
  Escuchará en el puerto 3000.
* `db`: contenedor con la base de datos

## El problema

Levantamos la aplicación:

```shell
$ docker compose -p 0070 up -d
```

Comprobamos que la aplicación funciona abriendo `https://localhost:3000` en el navegador. Deberíamos
ver nuestra aplicación para crear posts.

Queremos añadir una nueva funcionalidad a nuestra aplicación: los usuarios tendrán que registrarse antes 
de poder crear posts.

Para implementar esta funcionalidad, utilizaremos una de las gema más populares de ruby: 
[`devise`](https://rubygems.org/gems/devise). 

---
⚠️ En este taller, sólo instalaremos la gema, no modificaremos el código de la aplicación.
---

Editamos el fichero `blog/Gemfile` y añadimos la siguiente línea al final del fichero:

```ruby
gem 'devise', '~> 4.8', '>= 4.8.1'
```

Instalamos la dependencia:

```shell
$ docker compose -p 0070 exec rails bundle install
...
...
Fetching responders 3.0.1
Using actiontext 7.0.1
Using rspec-rails 5.0.2
Using stimulus-rails 1.0.2
Using turbo-rails 1.0.1
Using rails 7.0.1
Using web-console 4.2.0
Installing warden 1.2.9
Installing bcrypt 3.1.16 with native extensions
Installing responders 3.0.1
Installing orm_adapter 0.5.0
Fetching devise 4.8.1
Installing devise 4.8.1
Bundle complete! 18 Gemfile dependencies, 86 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

Reiniciamos el contenedor de rails para que la nueva gema se cargue:

```shell
$ docker compose -p 0070 restart rails
```

¿Qué ocurre si paramos todos los contenedores y los volvemos a levantar?

```shell
$ docker compose -p 0070 down

$ docker compose -p 0070 up -d
[+] Running 3/3
 ⠿ Network 0070_default    Created       0.0s 
 ⠿ Container 0070-rails-1  Started       5s 
 ⠿ Container 0070-db-1     Started       5s 

$ docker compose -p 0070 ps   
NAME                COMMAND                  SERVICE             STATUS              PORTS
0070-db-1           "docker-entrypoint.s…"   db                  running             5432/tcp
0070-rails-1        "bin/rails s -b 0.0.…"   rails               exited (1)
```

El contenedor de Rails no se está ejecutando. Veamos el motivo:

```shell
$ docker compose -p 0070 logs rails

0070-rails-1  | /usr/local/lib/ruby/3.0.0/bundler/definition.rb:502:in `materialize': Could not find devise-4.8.1, bcrypt-3.1.16, orm_adapter-0.5.0, responders-3.0.1, warden-1.2.9 in any of the sources (Bundler::GemNotFound)
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/definition.rb:189:in `specs'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/definition.rb:237:in `specs_for'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/runtime.rb:18:in `setup'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler.rb:150:in `setup'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/setup.rb:20:in `block in <top (required)>'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/ui/shell.rb:136:in `with_level'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/ui/shell.rb:88:in `silence'
0070-rails-1  |         from /usr/local/lib/ruby/3.0.0/bundler/setup.rb:20:in `<top (required)>'
0070-rails-1  |         from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
0070-rails-1  |         from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
0070-rails-1  |         from /blog/config/boot.rb:3:in `<top (required)>'
0070-rails-1  |         from bin/rails:3:in `require_relative'
0070-rails-1  |         from bin/rails:3:in `<main>'
```

Al parar los contenedores con el comando `docker compose down`, se ha borrado la capa del contenedor `0070_rails`
(en la que instalamos 
la gema `devise`). Al volver a levantar el contenedor, se crea una capa nueva que no contiene la dependencia.

Necesitaríamos construir una imagen nueva que incluya la dependencia. Para evitar tener que construir imágenes
cada vez que hacemos esto utilizaremos un volumen para almacenar las gemas.

## Volumen para cacheado de gemas

Paramos la aplicación si la tenemos levantada:

```shell
$ docker compose -p 0070 down
```

Como hemos ilustrado en la sección anterior, queremos evitar que como desarrollador tenga que generar
una nueva imagen cada vez que añada una dependencia, ya sea una gema de ruby o un paquete de npm.

En el tutorial de rails que estamos haciendo, no se utilizan paquetes de npm, por lo que únicamente
crearemos un volúmen para cachear gemas.

¿En qué carpeta almacena ruby las gemas? mirando la 
[documentación del comando `bundler`](https://bundler.io/v2.3/guides/bundler_docker_guide.html), vemos que 
por defecto, estas se guardan en `/usr/local/bundle` 

Modificaremos el fichero [`compose.yaml`](./compose.yaml) y añadimos las siguientes líneas:

```yaml
services:
  rails:
    volumes:
      - rails-bundle-cache:/usr/local/bundle

volumes:
  rails-bundle-cache:
```

Instalamos las gemas que necesitamos:

```shell
docker compose -p 0070 run --rm rails bundle install
[+] Running 2/0
 ⠿ Network 0070_default              Created      0.0s
 ⠿ Volume "0070_rails-bundle-cache"  Created      0.0s 
Fetching gem metadata from https://rubygems.org/..........
Using rake 13.0.6
Using minitest 5.15.0
Using rack 2.2.3
Using nio4r 2.5.8
Using websocket-extensions 0.1.5
Using builder 3.2.4
Using mini_mime 1.1.2
Using erubi 1.10.0
Using crass 1.0.6
Using concurrent-ruby 1.1.9
Using strscan 3.0.1
Using racc 1.6.0
Using digest 3.1.0
Fetching bcrypt 3.1.16
Using timeout 0.2.0
Using marcel 1.0.2
Using bundler 2.2.32
Using io-wait 0.2.1
Using bindex 0.8.1
Using msgpack 1.4.2
Using public_suffix 4.0.6
Using matrix 0.4.2
Fetching orm_adapter 0.5.0
Using childprocess 4.1.0
Using io-console 0.5.11
Using regexp_parser 2.2.0
Using method_source 1.0.0
Using thor 1.2.1
Using zeitwerk 2.5.3
Using rspec-support 3.10.3
Using rubyzip 2.3.2
Using rack-test 1.1.0
Fetching warden 1.2.9
Using diff-lcs 1.5.0
Using pg 1.2.3
Using rexml 3.2.5
Using puma 5.5.2
Using websocket-driver 0.7.5
Using mail 2.7.1
Using i18n 1.8.11
Using tzinfo 2.0.4
Using sprockets 4.0.2
Using nokogiri 1.13.1 (x86_64-linux)
Using net-protocol 0.1.2
Using bootsnap 1.9.4
Using addressable 2.8.0
Using rspec-expectations 3.10.2
Using rspec-mocks 3.10.2
Using selenium-webdriver 4.1.0
Using activesupport 7.0.1
Using loofah 2.13.0
Using xpath 3.2.0
Using net-imap 0.2.3
Using net-pop 0.1.1
Using net-smtp 0.3.1
Using reline 0.3.1
Using rails-html-sanitizer 1.4.2
Using rspec-core 3.10.1
Using rails-dom-testing 2.0.3
Using globalid 1.0.0
Using activemodel 7.0.1
Using capybara 3.36.0
Using webdrivers 5.0.0
Using rspec 3.10.0
Using irb 1.4.1
Using actionview 7.0.1
Using activejob 7.0.1
Using activerecord 7.0.1
Using debug 1.4.0
Using actionpack 7.0.1
Using jbuilder 2.11.5
Using actioncable 7.0.1
Using activestorage 7.0.1
Using actionmailer 7.0.1
Using railties 7.0.1
Using actiontext 7.0.1
Using actionmailbox 7.0.1
Installing orm_adapter 0.5.0
Using sprockets-rails 3.4.2
Using rspec-rails 5.0.2
Using stimulus-rails 1.0.2
Fetching responders 3.0.1
Using turbo-rails 1.0.1
Using importmap-rails 1.0.2
Using web-console 4.2.0
Installing bcrypt 3.1.16 with native extensions
Using rails 7.0.1
Installing warden 1.2.9
Installing responders 3.0.1
Fetching devise 4.8.1
Installing devise 4.8.1
Bundle complete! 18 Gemfile dependencies, 86 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

Notar que al ejecutar el comando, no se están instalando todas las gemas a pesar de que el volumen está vacío.
¿Porqué? El motivo es que, como indicamos en las diapositivas, cuando se monta un volumen por primera vez,
si este está vacío, se copia el contenido de la imagen. Eso es lo que ha ocurrido en este caso.

Levantamos de nuevo la aplicación:

```shell
$ docker compose -p 0070 up -d
```

Con las dependencias instaladas correctamente, la aplicación se debería levantar sin problemas:

```shell
NAME                COMMAND                  SERVICE             STATUS              PORTS
0070-db-1           "docker-entrypoint.s…"   db                  running             5432/tcp
0070-rails-1        "bin/rails s -b 0.0.…"   rails               running             0.0.0.0:3000->3000/tcp, :::3000->3000/tcp
```


## Limpieza

Tendremos que hacer lo siguiente:
* Parar los servicios
* Eliminar los volúmenes


```shell
$ docker compose -p 0070 down --volumes
```
