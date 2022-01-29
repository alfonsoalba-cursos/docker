### Múltiples procesos en un mismo contenedor

Dentro de las buenas prácticas está la recomendación es utilizar un contenedor 
por servicio.<!-- .element: class="plain fragment" data-fragment-index="0" -->

Por ejemplo: un contenedor con la aplicación y un contenedor con la base de 
datos<!-- .element: class="plain fragment" data-fragment-index="1" -->

Podemos encontrarnos servicios que para funcionar correctamente necesitan ejecutar múltiples
procesos dentro del contenedor<!-- .element: class="plain fragment" data-fragment-index="2" -->

Por ejemplo apache, que levanta múltiples workers para poder ejecutarse<!-- .element: class="plain fragment" data-fragment-index="3" -->

^^^^^^

#### Múltiples procesos en un mismo contenedor

El proceso principal (PID 1) de un contenedor es el responsable de procesar
y responder a las señales IPC que recibe

¿Está ese proceso bien diseñado?

notes:

Si el proceso no está bien diseñado podemos encontrarnos con situaciones en
las que ese proceso no es capaz de gestionar correctamente esas señales y,
por ejemplo, eliminar los procesos hijo correctamente cuando recibe un SIGINT

¿Es capaz ese proceso de eliminar procesos _zombie_ adecuadamente?

^^^^^^

#### Múltiples procesos en un mismo contenedor

Si nos enfrentamos a un proceso de este tipo:

* ✅ Utilizar la opción `--init` cuando levantamos el contenedor
* ❌ Utilizar `sysvinit`, `upstart` o `systemd`

notes:

La opción `--init` inserta en el contenedor un proceso prinicipal que lanza el resto
de procesos y se encarga de eliminarlos correctamente cuando el contenedor se para.
También se encarga de hacer la limpieza de procesos zombi.

[Specify an init process](https://docs.docker.com/engine/reference/run/#specify-an-init-process)

El proceso `docker-init` que se incluye en la instalación por defecto utiliza
[tini](https://github.com/krallin/tini)

^^^^^^

#### Múltiples procesos en un mismo contenedor
 
 Recomendaciones para lanzar varios procesos dentro un contenedor:

 * Utilizar un envoltorio
 * Utilizar `supervisord`

 ^^^^^^

#### Múltiples procesos: Envoltorio

```shell
#!/bin/bash
  
# Activamos el control de trabajos de bash
set -m
  
# Empezamos el proceso principal en segundo plano
./my_main_process &
  
# Empezamos el proceso secundario. Quizas, sste proceso necesite
# esperar a que el proceso prinicipal se levante antes de poder 
# ejecutarse y terminar
./my_helper_process

# Cuando el proceso secundario ha terminado, ponemos el proceso principal
# en primer plano
fg %1
```

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:latest
COPY my_main_process my_main_process
COPY my_helper_process my_helper_process
COPY my_wrapper_script.sh my_wrapper_script.sh
CMD ./my_wrapper_script.sh
```

notes:

En este ejemplo, tenemos un proceso principal que se mantiene en ejecución
y luego tenemos un proceso secundario que se tiene que ejecutar temporalmente.

Podemos utilizar un script en bash similar al que os incluyo aquí para conseguirlo.

Este script será el que utilicemos como `CMD` en la imagen.

Notar que el proceso 1 del contenedor será `bash` y no nuestro proceso, ya que en ejemplo,
este se ejecuta dentro del intérprete de comandos.

^^^^^^

#### Múltiples procesos: `supervisord`

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:latest
RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY my_first_process my_first_process
COPY my_second_process my_second_process
CMD ["/usr/bin/supervisord"]
```

notes:

Esta solución es más _pesada_ que la anterior ya que nos obliga a instalar
`supervisord` y python dentro de nuestra imagen. Como alternativa,
podemos buscar algo similar utilizando [runit](http://smarden.org/runit/)