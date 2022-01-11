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
> docker run --rm -p "9003:8003" -d --name instancia1 kubernetescourse/slides-docker
> docker run --rm -p "9004:8003" -d --name instancia2 kubernetescourse/slides-docker
> docker run --rm -p "9005:8003" -d --name instancia3 kubernetescourse/slides-docker
````

notes:

La opción -d ejecuta los contenedores en segundo plano.

Prestad atención a la opción -p de cada comando. Si intentamos levantar los tres contenedores en el mismo puerto
del host (9003) la segunda vez que ejecutemos el comando nos dará un error diciéndonos que ese puerto ya está ocupado:

```bash
> docker run --rm -p "9004:8003" -d --name instancia2 kubernetescourse/slides-docker

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
FROM nginx:latest

COPY . /usr/share/nginx/html/
```

notes:

La sintaxis de este fichero la veremos en detalle en el siguiente módulo.

Este fichero lo que dice es más o menos lo siguiente:

1. `FROM nginx:latest` Partiendo de la imagen de nginx, última versión
2. Copia todos los ficheros a la carpeta /usr/share/ninx/html/ dentro de la imagen

^^^^^^

### ¿Y como se crea la imagen de nginx:latest?

[Ver Dockerfile para nginx:latest](https://github.com/nginxinc/docker-nginx/blob/3a7105159a6c743188cb1c61e4186a9a59c025db/mainline/debian/Dockerfile)

[Ver Dockerfile para debian:bullseye-slim](https://github.com/debuerreotype/docker-debian-artifacts/blob/d5eb7c589d016973bce6f3e1827b5c315b7cefbc/bullseye/slim/Dockerfile)<!-- .element: class="fragment"  data-fragment-index="1"-->


```bash
# Dockerfile para crear la imagen de Debian
FROM scratch
ADD rootfs.tar.xz /
CMD ["bash"]
```
<!-- .element: class="fragment"  data-fragment-index="2"-->

[Ver Dockerfile para `scratch`](https://hub.docker.com/_/scratch)<!-- .element: class="fragment"  data-fragment-index="3"-->

[Create a base image (avanzado)](https://docs.docker.com/develop/develop-images/baseimages/)<!-- .element: class="fragment"  data-fragment-index="4"-->

notes:

Para crear la imagen de las diapositivas, hemos seguido esta ruta:

```scratch -> debian -> nginx -> Código de las diapositivas```

Si cada vez que tenemos que crear la imagen, tenemos que seguir todos los pasos, pues vamos a tardar un rato en hacerlo.

¿Qué hace docker para resolver el problema? Crear un sistema de cache

^^^^^^

### ¿Y como se crea la imagen de nginx?

* Para evitar tener que crear uno a uno todos los pasos cada vez que creamos una 
  imagen <br> **se ha desarrollado un sistema de cache basado en capas (layers)**

^^^^^^

### Capas (Layers)

Vamos a descargar la imagen de Ubuntu:


```bash [4]
$ docker image pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
7b1a6ab2e44d: Pull complete
Digest: sha256:626ffe58f6e7566e00254b638eb7e0f3b11d4da9675088f4781a50ae288f3322
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest
```

Se descarga una sola capa

^^^^^^

### Capas (Layers)

```bash
$ docker image history ubuntu
IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
ba6acccedd29   2 months ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      2 months ago   /bin/sh -c #(nop) ADD file:5d68d27cc15a80653…   72.8MB
```

notes:

En esta diapositiva, vemos que la imagen de ubuntu tiene dos capas, que se corresponden con los comandos necesarios
para crear la imagen. En la diapositiva anterior, cuando nos descargamos la imagen de ubuntu 
**nos descargamos una sola capa**.

Si os fijáis, el último comando no genera una capa adicional porque tiene 0Bytes (son
capas que sólo añaden metadatos a la imagen y que no generan una nueva capa física
descargable), por eso sólo nos descargamos una capa.

Si ahora construimos algo encima de la imagen de ubuntu, nos tendremos que descargar todas las 
capas de ubuntu (en este caso, sólo una) más las 
capas de lo que vayamos a construir.

^^^^^^ 

### Capas (Layers)

Veamos un ejemplo de cómo funcionan el cacheado de capas:

```bash 
> docker image pull debian:stretch-slim
stretch-slim: Pulling from library/debian
35b2232c987e: Pull complete
Digest: sha256:5913f0038562c1964c62fc1a9fcfff3c7bb340e2f5dbf461610ab4f802368eee
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

```bash [3]
> docker image pull postgres:11
11: Pulling from library/postgres 
35b2232c987e: Already exists <----- ¡¡¡ESTA CAPA YA LA TIENE!!!
c03727fea36b: Pull complete 
40c6d8e16779: Pull complete
c2ef16a628a4: Pull complete
e74a9f29f468: Pull complete
433f4ea81bed: Pull complete
0e16d29f73c0: Pull complete
0dcac015b659: Pull complete
e2e8de9996da: Downloading [======================================>            ]  54.71MB/71.52MB
58e7858fb26e: Download complete
2b30b3b45bf0: Download complete
6b863d1914b8: Download complete
6112fcb67f21: Download complete
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

