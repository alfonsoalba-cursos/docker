# Ejecutar script en ruby sin instalar ruby

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Sin instalar el lenguaje de programación [`ruby`](https://www.ruby-lang.org/en/), queremos ejecutar
un pequeño script de una línea usando este lenguaje.

## La imagen de `ruby`

En el 
[repositorio oficial de ruby en dockerhub](https://hub.docker.com/_/ruby), 
podemos acceder a las distintas
versiones de la imagen que podemos utilizar para ejecutar el script.

Aunque las imágenes de docker es un tema que veremos en detalle en el módulo 3 del curso, 
ya hemos visto en la teoría correspondiente a este taller cómo podemos utilizarlas.

Para este ejemplo, utilizaremos la imagen `3.1.0-slim`.

## El script

El script que queremos ejecutar es:

```ruby
puts "Bienvenido a Ruby!! #{RUBY_VERSION}"
```

## Ejecución
El comando `ruby` tiene una opción que permite pasarle como argumento
las instrucciones de ruby que queremos que se ejecuten. Podemos imprimir la
ayuda del comando de la siguiente manera:


```text
$ docker run --rm ruby:3.1.0-slim ruby -h

Unable to find image 'ruby:3.1.0-slim' locally
3.1.0-slim: Pulling from library/ruby
a2abf6c4d29d: Extracting [============>                                      ]  7.864MB/31.36MB
cc01ab7c5652: Download complete
622f415b3531: Verifying Checksum
345158565943: Download complete
09be0cfac501: Download complete
Digest: sha256:5a6f9717fce7bab760c5d45378c011fc92cc93ddb96722b533db2c8b90f5cc5b
Status: Downloaded newer image for ruby:3.1.0-slim

Usage: ruby [switches] [--] [programfile] [arguments]
  -0[octal]       specify record separator (\0, if no argument)
  -a              autosplit mode with -n or -p (splits $_ into $F)
  -c              check syntax only
  -Cdirectory     cd to directory before executing your script
  -d              set debugging flags (set $DEBUG to true)
  -e 'command'    one line of script. Several -e's allowed. Omit [programfile]
  -Eex[:in]       specify the default external and internal character encodings
  -Fpattern       split() pattern for autosplit (-a)
  -i[extension]   edit ARGV files in place (make backup if extension supplied)
  -Idirectory     specify $LOAD_PATH directory (may be used more than once)
  -l              enable line ending processing
  -n              assume 'while gets(); ... end' loop around your script
  -p              assume loop like -n but print line also like sed
  -rlibrary       require the library before executing your script
  -s              enable some switch parsing for switches after script name
  -S              look for the script using PATH environment variable
  -v              print the version number, then turn on verbose mode
  -w              turn warnings on for your script
  -W[level=2|:category]     set warning level; 0=silence, 1=medium, 2=verbose
  -x[directory]   strip off text before #!ruby line and perhaps cd to directory
  --jit           enable JIT for the platform, same as --yjit (experimental)
  --mjit          enable C compiler-based JIT compiler (experimental)
  --yjit          enable in-process JIT compiler (experimental)
  -h              show this message, --help for more info
```

En las primeras líneas de la salida del comando vemos cómo docker, que no tiene la 
imagen descargada en local, la descarga. Una vez descargada la imagen, crea el contenedor
y ejecuta el comando `ruby -h`

Vamos a ejecutar el script:

```shell
$ docker run --rm ruby:3.1.0-slim ruby -e 'puts "Bienvenido a Ruby!! #{RUBY_VERSION}"'
Bienvenido a Ruby!! 3.1.0
```

De esta forma hemos conseguido ejecutar un script de ruby sin instalar ruby en nuestra
máquina. 

## Limpieza

Como paso final, y de forma opcional, podemos borrar la imagen que nos acabamos de descartar:

```shell
$ docker image rm ruby:3.1.0-slim
Untagged: ruby:3.1.0-slim
Untagged: ruby@sha256:5a6f9717fce7bab760c5d45378c011fc92cc93ddb96722b533db2c8b90f5cc5b
Deleted: sha256:58e87585c63afb306376697307fd767d814c502bf7334cc733cb4448a113ac48
Deleted: sha256:c14827b6e85a31103356eed3fe09e80c592ac2655f6ee26fbf5cad46bf007f4a
Deleted: sha256:f2ed7c77ecf8cca64c738b7eeb8645612c470182e543426d645ad3f23740ef3a
Deleted: sha256:76aa17fdb820bd06feb57ea2fa96379f8b8c2ff217017d7162f22379105aa0b9
Deleted: sha256:026302f408550195d1466de4348ccbd510837b8bdf1b06330bc117115ff1454f
Deleted: sha256:2edcec3590a4ec7f40cf0743c15d78fb39d8326bc029073b41ef9727da6c851f
```