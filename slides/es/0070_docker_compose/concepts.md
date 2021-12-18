### ¿Qué es `docker-compose`?

**Herramienta para definir y ejecutar aplicaciones multi-contenedor**

^^^^^^

#### ¿Qué es `docker-compose`?

* Utilizamos un fichero `yaml` para definir los servicios que necesita nuestra
  aplicación

```yaml
version: '3'
services:
  web:
    build: .
    ports:
    - "5000:5000"
    volumes:
    - .:/code
    - logvolume01:/var/log
    links:
    - redis
  redis:
    image: redis
volumes:
  logvolume01: {}
```

notes:

En el ejemplo que utilizamos aquí, tomado de la documentación, vemos
una aplicación multi-contenedor que define dos servicios:

* El servicio `web` que contiene incluye el código de nuestra aplicación 
  a través de un _bind mount_
* Un servicio redis

En la definición de `web`, incluimos instrucciones sobre cómo construir la imagen:
usando el `Dockerfile` que estará situado junto al fichero `docker-compose` en 
el sistema de ficheros (`build: .`)

También vemos la definición de un volumen en el que se almacenarán los logs 
de la aplicación `- logvolume01:/var/log`.

A lo largo del módulo, entraremos en más profundidad en las diferentes opciones
que nos da `docker-compose`.

^^^^^^

#### ¿Qué es `docker-compose`?

**Una vez definido el fichero de `docker-compose.yml` podemos levantar 
todos los servicios (o contedenedores) con un único comando**

^^^^^^

#### ¿Qué es `docker-compose`?

¿Cómo usar `docker-compose`?

1. Crear la imagen de nuestra aplicación con un `Dockerfile`
1. Definimos todos los servicios que necesita utilizar nuestra aplicación en
   el fichero `docker-compose.yml`
1. Ejecutar `docker-compose up` para levantar todos los contenedores en un entorno
   aislado

note:

El comando `docker-compose up` levanta todos los servicios definidos en el fichero
`docker-compose.yml` en un entorno aislado. Por ejemplo, utiliza un 
_user-defined bridge_ para aislar la rede de los contenedores del resto de procesos y/o
contenedores que podamos tener ejecutándose en la máquina.

^^^^^^

#### ¿Qué es `docker-compose`?

Compose tiene comandos para gestionar el ciclo de vida completo de la aplicación:

* Parar, iniciar y construir servicios
* Ver el estado de los servicios en ejecución
* Acceder a los logs
* Ejecutar comandos dentro de un servicio