# Imagen con el tutorial de Rails

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Queremos dar los primeros pasos del tutorial de Rails dentro de un contenedor.

## Imagen de partida

No existe una imagen oficial de Rails, por lo que el partiremos de la imagen de 
[`ruby`](https://hub.docker.com/_/ruby)
y dentro de ella instalaremos Rails.

**Dado que todavía no podemos usar volúmenes (los veremos en el módulo 5), todo lo que
hagamos dentro del contenedor quedará persistido en la _container layer_ y desaparecerá
cuando borremos el contenedor.** Por este motivo, no usaremos la opción `--rm` del comando
`docker run` y borraremos el contenedor manualmente cuando terminemos el ejercicio.

## Crear el contenedor

Podremos acceder a la aplicacion en rails a través del puerto 3000, por lo que 
expondremos este puerto cuando creemos el contenedor:

```shell
$ docker run -ti --name rails-tutorial -p 3000:3000 ruby:3.0-slim bash
root@a0b361ddbfa8:/$ 
```

## Actualizar los paquetes

Antes de continuar, nos aseguramos de que tenemos actualizados los paquetes dentro
del contenedor:

```shell
root@a0b361ddbfa8:/$ apt update && apt upgrade -y
```

## Instalar rails

El siguiente paso que daremos será instalar rails:

```shell
root@a0b361ddbfa8:/$ gem install rails

Fetching method_source-1.0.0.gem
Fetching thor-1.2.1.gem
Fetching concurrent-ruby-1.1.9.gem
Fetching tzinfo-2.0.4.gem
Fetching i18n-1.8.11.gem
Fetching zeitwerk-2.5.3.gem
Fetching nokogiri-1.13.0-x86_64-linux.gem
Fetching activesupport-7.0.1.gem
Fetching crass-1.0.6.gem
Fetching loofah-2.13.0.gem
Fetching rails-html-sanitizer-1.4.2.gem
Fetching rails-dom-testing-2.0.3.gem
Fetching rack-2.2.3.gem
Fetching rack-test-1.1.0.gem
Fetching erubi-1.10.0.gem
Fetching builder-3.2.4.gem
Fetching actionview-7.0.1.gem
Fetching actionpack-7.0.1.gem
Fetching railties-7.0.1.gem
Fetching mini_mime-1.1.2.gem
Fetching marcel-1.0.2.gem
Fetching activemodel-7.0.1.gem
Fetching activerecord-7.0.1.gem
Fetching globalid-1.0.0.gem
Fetching activejob-7.0.1.gem
Fetching activestorage-7.0.1.gem
Fetching actiontext-7.0.1.gem
Fetching mail-2.7.1.gem
Fetching actionmailer-7.0.1.gem
Fetching actionmailbox-7.0.1.gem
Fetching websocket-extensions-0.1.5.gem
Fetching websocket-driver-0.7.5.gem
Fetching rails-7.0.1.gem
Fetching nio4r-2.5.8.gem
Fetching actioncable-7.0.1.gem
Successfully installed zeitwerk-2.5.3
Successfully installed thor-1.2.1
Successfully installed method_source-1.0.0
Successfully installed concurrent-ruby-1.1.9
Successfully installed tzinfo-2.0.4
Successfully installed i18n-1.8.11
Successfully installed activesupport-7.0.1
Successfully installed nokogiri-1.13.0-x86_64-linux
Successfully installed crass-1.0.6
Successfully installed loofah-2.13.0
Successfully installed rails-html-sanitizer-1.4.2
Successfully installed rails-dom-testing-2.0.3
Successfully installed rack-2.2.3
Successfully installed rack-test-1.1.0
Successfully installed erubi-1.10.0
Successfully installed builder-3.2.4
Successfully installed actionview-7.0.1
Successfully installed actionpack-7.0.1
Successfully installed railties-7.0.1
Successfully installed mini_mime-1.1.2
Successfully installed marcel-1.0.2
Successfully installed activemodel-7.0.1
Successfully installed activerecord-7.0.1
Successfully installed globalid-1.0.0
Successfully installed activejob-7.0.1
Successfully installed activestorage-7.0.1
Successfully installed actiontext-7.0.1
Successfully installed mail-2.7.1
Successfully installed actionmailer-7.0.1
Successfully installed actionmailbox-7.0.1
Successfully installed websocket-extensions-0.1.5
Building native extensions. This could take a while...
Successfully installed websocket-driver-0.7.5
Building native extensions. This could take a while...
Successfully installed nio4r-2.5.8
Successfully installed actioncable-7.0.1
Successfully installed rails-7.0.1
35 gems installed
```

Verificamos que ha funcionado todo correctamente:

```shell
root@a0b361ddbfa8:/$ rails --version
Rails 7.0.1
```

## Crear la aplicación

Dentro del contenedor, vamos a crear la aplicación `blog`. La crearemos en la
raiz del sistema de ficheros del contenedor:


```shell
root@a0b361ddbfa8:/$ rails new blog
```

<details>
<summary>Salida del comando <code>rails new blog</code></summary>
```shell
      create  app
      create  app/assets/config/manifest.js
      create  app/assets/stylesheets/application.css
      create  app/channels/application_cable/channel.rb
      create  app/channels/application_cable/connection.rb
      create  app/controllers/application_controller.rb
      create  app/helpers/application_helper.rb
      create  app/jobs/application_job.rb
      create  app/mailers/application_mailer.rb
      create  app/models/application_record.rb
      create  app/views/layouts/application.html.erb
      create  app/views/layouts/mailer.html.erb
      create  app/views/layouts/mailer.text.erb
      create  app/assets/images
      create  app/assets/images/.keep
      create  app/controllers/concerns/.keep
      create  app/models/concerns/.keep
      create  bin
      create  bin/rails
      create  bin/rake
      create  bin/setup
      create  config
      create  config/routes.rb
      create  config/application.rb
      create  config/environment.rb
      create  config/cable.yml
      create  config/puma.rb
      create  config/storage.yml
      create  config/environments
      create  config/environments/development.rb
      create  config/environments/production.rb
      create  config/environments/test.rb
      create  config/initializers
      create  config/initializers/assets.rb
      create  config/initializers/content_security_policy.rb
      create  config/initializers/cors.rb
      create  config/initializers/filter_parameter_logging.rb
      create  config/initializers/inflections.rb
      create  config/initializers/new_framework_defaults_7_0.rb
      create  config/initializers/permissions_policy.rb
      create  config/locales
      create  config/locales/en.yml
      create  config/master.key
      append  .gitignore
      create  config/boot.rb
      create  config/database.yml
      create  db
      create  db/seeds.rb
      create  lib
      create  lib/tasks
      create  lib/tasks/.keep
      create  lib/assets
      create  lib/assets/.keep
      create  log
      create  log/.keep
      create  public
      create  public/404.html
      create  public/422.html
      create  public/500.html
      create  public/apple-touch-icon-precomposed.png
      create  public/apple-touch-icon.png
      create  public/favicon.ico
      create  public/robots.txt
      create  tmp
      create  tmp/.keep
      create  tmp/pids
      create  tmp/pids/.keep
      create  tmp/cache
      create  tmp/cache/assets
      create  vendor
      create  vendor/.keep
      create  test/fixtures/files
      create  test/fixtures/files/.keep
      create  test/controllers
      create  test/controllers/.keep
      create  test/mailers
      create  test/mailers/.keep
      create  test/models
      create  test/models/.keep
      create  test/helpers
      create  test/helpers/.keep
      create  test/integration
      create  test/integration/.keep
      create  test/channels/application_cable/connection_test.rb
      create  test/test_helper.rb
      create  test/system
      create  test/system/.keep
      create  test/application_system_test_case.rb
      create  storage
      create  storage/.keep
      create  tmp/storage
      create  tmp/storage/.keep
      remove  config/initializers/cors.rb
      remove  config/initializers/new_framework_defaults_7_0.rb
         run  bundle install
Fetching gem metadata from https://rubygems.org/...........
Resolving dependencies....
Fetching rake 13.0.6
Installing rake 13.0.6
Using concurrent-ruby 1.1.9
Fetching minitest 5.15.0
Using builder 3.2.4
Using marcel 1.0.2
Fetching racc 1.6.0
Using crass 1.0.6
Using rack 2.2.3
Fetching io-wait 0.2.1
Using websocket-extensions 0.1.5
Fetching timeout 0.2.0
Using mini_mime 1.1.2
Using strscan 3.0.1
Using nio4r 2.5.8
Fetching public_suffix 4.0.6
Fetching digest 3.1.0
Using erubi 1.10.0
Fetching bindex 0.8.1
Fetching msgpack 1.4.2
Installing io-wait 0.2.1 with native extensions
Installing minitest 5.15.0
Installing bindex 0.8.1 with native extensions
Installing timeout 0.2.0
Installing digest 3.1.0 with native extensions
Installing racc 1.6.0 with native extensions
Installing msgpack 1.4.2 with native extensions
Installing public_suffix 4.0.6
Using bundler 2.2.32
Fetching matrix 0.4.2
Fetching regexp_parser 2.2.0
Installing matrix 0.4.2
Fetching childprocess 4.1.0
Installing regexp_parser 2.2.0
Fetching io-console 0.5.11
Installing childprocess 4.1.0
Installing io-console 0.5.11 with native extensions
Using method_source 1.0.0
Using thor 1.2.1
Using zeitwerk 2.5.3
Using rexml 3.2.5
Fetching sqlite3 1.4.2
Fetching rubyzip 2.3.2
Using i18n 1.8.11
Using tzinfo 2.0.4
Using rack-test 1.1.0
Fetching sprockets 4.0.2
Installing rubyzip 2.3.2
Installing sqlite3 1.4.2 with native extensions
Installing sprockets 4.0.2
Using websocket-driver 0.7.5
Using mail 2.7.1
Fetching puma 5.5.2
Installing puma 5.5.2 with native extensions
Fetching addressable 2.8.0
Installing addressable 2.8.0
Using activesupport 7.0.1
Fetching selenium-webdriver 4.1.0
Installing selenium-webdriver 4.1.0
Using globalid 1.0.0
Using activemodel 7.0.1
Using activejob 7.0.1
Using activerecord 7.0.1
Fetching net-protocol 0.1.2
Installing net-protocol 0.1.2
Using nokogiri 1.13.0 (x86_64-linux)
Using rails-dom-testing 2.0.3
Using loofah 2.13.0
Fetching xpath 3.2.0
Fetching webdrivers 5.0.0
Using rails-html-sanitizer 1.4.2
Using actionview 7.0.1
Using actionpack 7.0.1
Fetching jbuilder 2.11.5
Installing xpath 3.2.0
Installing webdrivers 5.0.0
Using actioncable 7.0.1
Installing jbuilder 2.11.5
Using activestorage 7.0.1
Using railties 7.0.1
Fetching sprockets-rails 3.4.2
Using actiontext 7.0.1
Fetching importmap-rails 1.0.1
Fetching stimulus-rails 1.0.2
Installing sprockets-rails 3.4.2
Fetching turbo-rails 1.0.0
Installing stimulus-rails 1.0.2
Installing importmap-rails 1.0.1
Installing turbo-rails 1.0.0
Fetching web-console 4.2.0
Fetching capybara 3.36.0
Installing web-console 4.2.0
Installing capybara 3.36.0
Fetching reline 0.3.1
Installing reline 0.3.1
Fetching irb 1.4.1
Installing irb 1.4.1
Fetching debug 1.4.0
Installing debug 1.4.0 with native extensions
Using net-pop 0.1.1
Fetching net-imap 0.2.3
Fetching net-smtp 0.3.1
Installing net-smtp 0.3.1
Installing net-imap 0.2.3
Using actionmailbox 7.0.1
Using actionmailer 7.0.1
Using rails 7.0.1
Fetching bootsnap 1.9.3
Installing bootsnap 1.9.3 with native extensions
Bundle complete! 15 Gemfile dependencies, 74 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
         run  bundle binstubs bundler
       rails  importmap:install
Add Importmap include tags in application layout
      insert  app/views/layouts/application.html.erb
Create application.js module as entrypoint
      create  app/javascript/application.js
Use vendor/javascript for downloaded pins
      create  vendor/javascript
      create  vendor/javascript/.keep
Ensure JavaScript files are in the Sprocket manifest
      append  app/assets/config/manifest.js
Configure importmap paths in config/importmap.rb
      create  config/importmap.rb
Copying binstub
      create  bin/importmap
       rails  turbo:install stimulus:install
Import Turbo
      append  app/javascript/application.js
Pin Turbo
      append  config/importmap.rb
Run turbo:install:redis to switch on Redis and use it in development for turbo streams
Create controllers directory
      create  app/javascript/controllers
      create  app/javascript/controllers/index.js
      create  app/javascript/controllers/application.js
      create  app/javascript/controllers/hello_controller.js
Import Stimulus controllers
      append  app/javascript/application.js
Pin Stimulus
      append  config/importmap.rb
```
</details>


## Levantar el servidor de aplicaciones

Una vez tenemos el esqueleto de la aplicación creado, podemos levantar el
servidor de aplicaciones:

```shell
root@a0b361ddbfa8:/$ cd blog

root@a0b361ddbfa8:/blog $ rails server -b 0.0.0.0
=> Booting Puma
=> Rails 7.0.1 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.5.2 (ruby 3.0.3-p157) ("Zawgyi")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 27
* Listening on http://0.0.0.0:3000
Use Ctrl-C to stop
```

Si apuntamos nuestro navegador a la dirección `http://localhost:3000` veremos
la página de bienvenida de la aplicación rails.

Necesitamos utilizar la opción `-b` para que el servidor de aplicaciones
escuche en todas las interfaces de red, incluyendo la red del contenedor. Si no
utilizamos este parámetro, el servidor de rails escuchará en `localhost`, que
no es accesible desde fuera del contenedor.

## Parar el contenedor

Dado que no hemos usado la opción `--rm`, podemos parar el contenedor y volver a 
ejecutarlo. 

Paramos el servidor de aplicaciones usando <kbd>Ctrl</kbd> + <kbd>C</kbd> y cerramos
el contenedor:

```shell
root@a0b361ddbfa8:/$ cd blog

root@a0b361ddbfa8:/blog $ rails server -b 0.0.0.0
=> Booting Puma
=> Rails 7.0.1 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.5.2 (ruby 3.0.3-p157) ("Zawgyi")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 27
* Listening on http://0.0.0.0:3000
Use Ctrl-C to stop

root@a0b361ddbfa8:/blog# exit
$ _
```

Si accedemos a `http://localhost:3000`, el navegador nos dará un error. Volvemos
a ejecutar el contenedor:

```shell
$ docker start rails-tutorial
rails-tutorial
```

Si accedemos a `http://localhost:3000`, seguimos obteniendo un error. El motivo
es porque dentro del contenedor, no se está ejecutando el servidor de aplicaciones de rails.
El proceso principal del contenedor es una shell de bash. Pdemos verlo ejecutando:

```shell [6]
$ docker exec -ti rails-tutorial bash
root@a0b361ddbfa8:/$ ps uxaf
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        55  0.4  0.0   5988  3848 pts/1    Ss   03:57   0:00 bash
root        62  0.0  0.0   8588  3356 pts/1    R+   03:57   0:00  \_ ps uxaf
root         1  0.0  0.0   5988  3628 pts/0    Ss+  03:45   0:00 bash
```

El proceso con PID 1 es un interprete de bash.

Volvemos a parar el contenedor. Para ello, salimos del contenedor y ejecutamos 
`docker stop`:

```shell
root@a0b361ddbfa8:/$ esit

$ docker stop rails-tutorial
rails-tutorial
```

Este contenedor tiene dos problemas:
1. cada vez que paremos el contenedor, tendremos que meternos dentro y ejecutar el
   comando `rails server` para levantar el servidor de aplicaciones
1. El proceso principal del contenedor no será nuestro servidor de aplicaciones. Por
   ello, cuando le enviemos señales IPC al contenedor no las recibirá nuestro servidor
   de aplicaciones sino bash.
   
Vamos a corregir estos problemas.

## Levantar el servidor de aplicaciones automáticamente

Utilizando `docker commit`, y con el contenedor parado, crearemos una imagen nueva
a partir del contenedor que ya existe. De esta manera, nos ahorramos tener que volver
a ejecutar todos los comandos que ejecutamos antes para instalar rails.

Creamos una imagen `rails-tutorial` a partir del contenedor con el mismo nombre:

```shell
$ docker commit rails-tutorial rails-tutorial
sha256:d28b73ca095337d704cded157f175ceca516a996cc1a6f7b7ade15e62bd3a244

$ docker image ls --filter 'reference=rails*'                         
REPOSITORY       TAG       IMAGE ID       CREATED              SIZE
rails-tutorial   latest    d28b73ca0953   About a minute ago   1GB
```

Levantamos un nuevo contenedor, que llamaremos `rails-tutorial-2` usando esta nueva imagen.
Además, le indicaremos al contenedor cual será el comando que queremos que se ejecute:

```shell
$ docker run -d -p 3001:3000 -w /blog --name rails-tutorial-2 rails-tutorial rails server -b 0.0.0.0
0c2fcbd08b59d651e91553c94f57ae4083b79e849a30b75909301283c3866bc9
$ _
```

Veremos las opciones que hemos utilizado:
* `-d` Ejecuta el contenedor de segundo plano
* `-p 3001:3000` El puerto 3000 ya está siendo utilizado por el contenedor anterior
  `rails-tutorial`, que no hemos borrado. Es por ello que necesitamos utilizar otro 
  puerto del host, en este caso el puerto 3001
* `-w` Cambiamos el directorio de trabajo a la carpeta `/blog/` dentro del contenedor,
  que es donde está nuestra aplicación rails. Esté será el directorio en el que se ejecutará
  el comando que pasamos como argumento
* `--name` Nombre del nuevo contenedor, `rails-tutorial-2`
* `rails-tutorial` Nombre de la imagen
* Por último, el comando que queremos ejecutar.

Si apuntamos nuestro navegador a `http://localhost:3001` veremos de nuevo la página 
de bienvenida de Rails.

Veamos qué procesos se están ejecutando en el contenedor:

```shell
$ docker exec -ti rails-tutorial-2 bash
root@2e494a9b7cf4:/blog$ ps uxfa
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        20  2.0  0.0   5988  3764 pts/0    Ss   04:22   0:00 bash
root        27  0.0  0.0   8588  3372 pts/0    R+   04:22   0:00  \_ ps uxfa
root         1  1.5  0.6 943904 101948 ?       Ssl  04:20   0:01 puma 5.5.2 (tcp://0.0.0.0:3000) [blog]
root@2e494a9b7cf4:/blog$ exit
$ _
```

## Limpieza

Paramos los contenedores:

```shell
$ docker stop rails-tutorial rails-tutorial-2
rails-tutorial
rails-tutorial-2
```

Borramos los contenedores:

```shell
$ docker container rm rails-tutorial rails-tutorial-2
rails-tutorial
rails-tutorial-2
```

Borramos la imagen:

```shell
$ docker image rm rails-tutorial
Untagged: rails-tutorial:latest
Deleted: sha256:d28b73ca095337d704cded157f175ceca516a996cc1a6f7b7ade15e62bd3a244
Deleted: sha256:a1b8bb8e779a583abf1225065ebce41e38203a4e196a829f0b9d7306e0776c0c
```

La imagen de ruby podemos mantenerla ya que la necesitaremos los próximos talleres.


