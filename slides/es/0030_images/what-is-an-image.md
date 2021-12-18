### ¿Qué es una imagen?

[![docker-architecture](../../images/docker-architecture.svg)<!-- .element: class="plain" -->](https://docs.docker.com/engine/docker-overview/#docker-architecture)

notes:

Si recordamos lo que hemos visto en el módulo 1 sobre arquitectura de docker, hasta el momento hemos trabajado con 
contenedores, especialmente en el módulo anterior (módulo 2).

Recordando el simil que utilizamos en el módulo 1 para diferenciar contenedores e imágenes, un contenedor es el 
equivalente a un "Objeto" y una imagen sería el equivalente a una "Clase".

**Eso significa que hasta el momento hemos trabajado sólo con "Objetos"** ¿Dónde están las clases?

^^^^^^

### ¿Qué es una imagen?

Una imagen es un fichero que se compone de varias capas que contiene las instrucciones para construir un contenedor y 
ejecutar el código que está contenido en la imagen.

^^^^^^

### 💻 Práctica 💻

* Veamos un ejemplo de que un contenedor (objeto) es una instancia de una imagen (clase)
* Vamos a levantar varias instancias del mismo objeto

```bash
> docker run --rm -p "9003:8003" -d --name instancia1 becorecode/curso-intro-docker-modulo-3
> docker run --rm -p "9004:8003" -d --name instancia2 becorecode/curso-intro-docker-modulo-3
> docker run --rm -p "9005:8003" -d --name instancia3 becorecode/curso-intro-docker-modulo-3
````

notes:

La opción -d ejecuta los contenedores en segundo plano.

Prestad atención a la opción -p de cada comando. Si intentamos levantar los tres contenedores en el mismo puerto
del host (9003) la segunda vez que ejecutemos el comando nos dará un error diciéndonos que ese puerto ya está ocupado:

```bash
> docker run --rm -p "9004:8003" -d --name instancia2 becorecode/curso-intro-docker-modulo-3

docker: Error response from daemon: driver failed programming external connectivity on endpoint instancia2
(7c1ea225545c23385619e7e9c3022d4607b11d22a8c5d18cb1f0cd589dd6db31): Bind for 0.0.0.0:9003 failed: port is already allocated.
```

^^^^^^

#### 💻 Práctica (cont.) 💻

* Mostrar los contenedores en ejecución

```bash
> docker container ls
```

* Como podéis ver, hemos levantado tres instancias en ejecución de la misma imagen.

^^^^^^

### 💻 Ejercicio 💻

* Añadir un fichero a uno de los contenedores, por ejemplo instancia2
* ¿Es visible ese fichero desde los otros contenedores?

**No, el fichero sólo es visible desde el contenedor `instancia2`**<!-- .element: class="fragment"  data-fragment-index="1"-->

**Analogía: si cambiamos un variable de un objeto, la cambiamos sólo en esa instancia**<!-- .element: class="fragment"  data-fragment-index="2"-->

notes:

Este ejercicio se puede hacer de varias maneras. Una de ellas es usar `docker exec` para abrir una shell en el contenedor
`instancia2`, crear el fichero y salir. Abrir una shell en los otros contenedores y ver si el fichero está o no.

Otra forma es con el comando `docker container copy`: crear un fichero en el host, copiarlo al contenedor `instancia2` y
ver si el fichero existe en los otros contenedores:

```bash
> touch prueba.txt
> docker container copy prueba.txt instancia2:/home/node/prueba.txt
> docker container exec instancia1 ls /home/node/prueba.txt
> docker container exec instancia3 ls /home/node/prueba.txt
```

¿Se os ocurre alguna otra manera de hacerlo?

^^^^^^

##### ¿Dónde están las instrucciones para crear esa imagen?

En un fichero que se llama "Dockerfile"


```Dockerfile
# instrucciones (imagen) para crear el contenedor de este módulo del curso
FROM node:10-alpine

ENV APP_PATH=/home/node
ENV APP_PORT=8003
USER node

WORKDIR $APP_PATH

COPY --chown=node . $APP_PATH

RUN npm install

EXPOSE $APP_PORT

CMD ["npm", "start", "--", "--port=${APP_PORT}"]
```

notes:

La sintaxis de este fichero la veremos en detalle en el siguiente módulo.

Este fichero lo que dice es más o menos lo siguiente:

1. `FROM node:10-alpine` Partiendo de la imagen de node, versión 10
2. Haz varias cosas (que veremos el siguiente módulo del curso...)

^^^^^^

### ¿Y como se crea la imagen de node?

[Ver Dockerfile para node:alpine](https://github.com/nodejs/docker-node/blob/master/Dockerfile-alpine.template)

[Ver Dockerfile para alpine:0.0](https://github.com/alpinelinux/docker-alpine/blob/master/Dockerfile)<!-- .element: class="fragment"  data-fragment-index="1"-->


```bash
# Dockerfile para crear la imagen de Alpine Linux
FROM scratch
ADD alpine-minirootfs-20190925-x86_64.tar.gz /
CMD ["/bin/sh"]
```
<!-- .element: class="fragment"  data-fragment-index="2"-->

[Ver Dockerfile para `scratch`](https://hub.docker.com/_/scratch)<!-- .element: class="fragment"  data-fragment-index="3"-->

notes:

Para crear la imagen de node, hemos seguido esta ruta:

```scratch -> alpine -> node -> Código de las diapositivas```

Si cada vez que tenemos que crear la imagen, tenemos que seguir todos los pasos, pues vamos a tardar un rato en hacerlo.

¿Que hace docker para resolver el problema? Crear un sistema de cache

^^^^^^

### ¿Y como se crea la imagen de node?

* Para evitar tener que crear uno a uno todos los pasos cada vez que creamos una 
  imagen <br> **se ha desarrollado un sistema de cache basado en capas (layers)**

^^^^^^

### Capas (Layers)

Vamos a descargar la imagen de Ubuntu:



```bash
> docker image pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
5667fdb72017: Pull complete
d83811f270d5: Pull complete
ee671aafb583: Pull complete
7fc152dfb3a6: Pull complete
```

Se descarga cuatro capas

^^^^^^

### Capas (Layers)

```bash
> docker image history ubuntu
IMAGE               CREATED             CREATED BY                                      SIZE
2ca708c1c9cc        2 weeks ago         /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
<missing>           2 weeks ago         /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B
<missing>           2 weeks ago         /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B
<missing>           2 weeks ago         /bin/sh -c [ -z "$(apt-get indextargets)" ]     987kB
<missing>           2 weeks ago         /bin/sh -c #(nop) ADD file:288ac0434f65264f3…   63.2MB
```

notes:

En esta diapositiva, vemos que la imagen de ubuntu tiene cuatro capas, que se corresponden con los comandos necesarios
para crear la imagen. En la diapositiva anterior, cuando nos descargamos la imagen de ubuntu 
**nos descargamos cuatro capas precisamente**.

Si os fijáis, el último comando no genera una capa adicional porque tiene 0Bytes, por eso
sólo se generan cuatro capas.

Si ahora construimos algo encima de la imagen de ubuntu, nos tendremos que descargar las cuatro capas de ubuntu más las 
capas de lo que vayamos a construir.

^^^^^^ 

### Capas (Layers)

Veamos un ejemplo de cómo funcionan el cacheado de capas:

```bash 
> docker image pull debian:stretch-slim
stretch-slim: Pulling from library/debian
8f91359f1fff: Pull complete
Digest: sha256:8ef99f5a3e800df50ea02334d233360d26c414208815686fbcbf34648ec596d4
Status: Downloaded newer image for debian:stretch-slim
docker.io/library/debian:stretch-slim
```

notes:

No usamos la imagen de `node:10-alpine` porque esa imagen tiene toda la pinta de que está usando una técnica conocida
como _image flattering_ y no me sirve como ejemplo. Veremos qué es esto de _image flattering_
[más adelante en este mismo módulo](#/image-flattering)

^^^^^^

### Capas (Layers)

Ahora vamos a descargarnos la imagen de Postgres11:

```bash
> docker image pull postgres:11
11: Pulling from library/postgres 
8f91359f1fff: Already exists <----- ¡¡¡ESTA CAPA YA LA TIENE!!!
c6115f5efcde: Downloading [====>                                              ]  441.5kB/4.501MB
28a9c19d8188: Download complete
2da4beb7be31: Download complete
fb9ca792da89: Waiting
cedc20991511: Waiting
b866c2f2559e: Waiting
5d459cf6645c: Waiting
fe547ab13055: Waiting
1ec7153c8a1e: Waiting
04f5c9a661a4: Waiting
2fa57c35e01c: Waiting
ecf80d85543f: Waiting
a367f7a702e8: Waiting
```

notes:

Como se puede ver en la captura, la capa que ya teníamos descargada antes, no nos la volvemos a descargar de nuevo.

^^^^^^

### Capas y contenedores

¿Qué ocurre cuando creamos un contenedor?

```bash
> docker run --rm -ti ubuntu bash
```

![containers and images](../../images/docker-containers-and-images-1.jpg)

notes:

Cuando se crea un contenedor nuevo, docker añade encima de todas las capas de la imagen una nueva capa con permiso 
de escritura (Thin R/W layer). Las capas que están por debajo, que son las que se corresponden con la imagen que 
estamos usando, no se pueden modificar. 

Cualquier modificación que hagamos dentro del contenedor **se escribe en esta capa fina.**

Docker tiene una serie de configuraciones con lo que se llama _storage driver_. Este driver es el que se encarga
de gestionar estas capas. Hay varios _storage drivers_ disponibles; todos ellos tienen una característica en común
y es que se utiliza una estrategia _copy-on-write_ (CoW) para getionar los cambios en la capa del contenedor.

Puedes encontrar información más detallada [aquí](https://docs.docker.com/storage/storagedriver/)

^^^^^^

### Capas y contenedores

![containers and images](../../images/docker-containers-and-images-2.jpg)

notes:

Los contenedores comparten todas las capas de la imagen (que no se pueden modificar). Cada contenedor crea su propia
capa (_container layer_) en la que añadir ficheros, modificarlos o borrarlos.

Si recordáis, al principio de esta sección, levantamos tres contenedores y vimos que si creábamos un fichero nuevo en uno de ellos
el resto no lo veía. Esta diapositiva explica el motivo por el que esto ocurre.

Lectura muy recomendable: [About storage drivers](https://docs.docker.com/storage/storagedriver/)

