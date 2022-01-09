### Dockerfile

En el módulo de imágenes, vimos cómo crear imágenes por distintos métodos:
* `docker commit`
* Exportando e importando un contenedor
* Con los comandos `docker image save` y `docker image load`

**Sin embargo, el método recomendado para crear imágenes es a través del comando
`docker build` y el fichero `Dockerfile`**

^^^^^^

### 💻️Práctica💻 ️

Vamos a crear nuestra primera imagen

* Crea una carpeta vacía `mi_web`
* Crea un fichero `Dockerfile` con el siguiente contenido

```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

notes:

El fichero `Dockerfile` contiene una serie de instrucciones con sus argumentos.

Las instrucciones deben aparecer en mayúsculas y seguidas de su correspondiente argumento.

Cada instrucción añade una nueva capa a la imagen.

El proceso de creación de las imágenes cambio sustancialmente con la introducción de BuildKit
en la versión 18.09 de Docker.

Por suerte, los detalles de cómo funciona todo este proceso no son necesarios
para poder trabajar con las imágenes, por lo que no entraremos en los detalles de
implementación. Sí que es útil tener una imagen a alto nivel de cómo funciona el proceso,
y a eso nos limitaremos en esta pequeña sección.

A pinceladas, BuildKit funciona de la siguiente manera:
* A partir de la definición de una imagen (ficher Dockerfile) se genera un grafo
  LLB (_low-level build definition format_). La herramienta que hace esta conversión
  se llama _frontend_
* Una vez el _frontend_ ha generado el grafo LLB, este se le pasa BuildKit para que
  genere la imagen
* BuildKit genera imágenes compatibles con la 
[especificación OCI para imágenes](https://github.com/opencontainers/image-spec)

El uso de este grafo permite analizar las dependencias entre capas y, de forma
mucho más precisa que antes, establecer dependencias y cachear partes del proceso.
También permite paralelizar aquellas partes que son independientes entre sí.

Además, al separar el _frontend_ del proceso de generación de la imagen, ya no
estamos obligados a utilizar un `Dockerfile` para generar las imágenes. Basta
con escribir nuestro propio lenguage y escribir un _frontend_ que genere el
grafo LLB para generar una imagen. Ejemplos de este tipo de lenguages:

-   Dockerfile
-   [Buildpacks](https://github.com/tonistiigi/buildkit-pack)
-   [Mockerfile](https://matt-rickard.com/building-a-new-dockerfile-frontend/)
-   [Gockerfile](https://github.com/po3rin/gockerfile)
-   [bldr (Pkgfile)](https://github.com/talos-systems/bldr/)
-   [HLB](https://github.com/openllb/hlb)
-   [Earthfile (Earthly)](https://github.com/earthly/earthly)
-   [Cargo Wharf (Rust)](https://github.com/denzp/cargo-wharf)
-   [Nix](https://github.com/AkihiroSuda/buildkit-nix)


Enlaces para profundizar:
* [Repo de BuildKit en GitHub](https://github.com/moby/buildkit) es un buen punto de partida
* [Introducing BuildKit](https://blog.mobyproject.org/introducing-buildkit-17e056cc5317)
* [DockerCon EU Moby Summit: BuildKit ▶️](https://www.youtube.com/watch?v=cbLk3Egc42E)

^^^^^^

### 💻️Práctica 💻️

Construimos la imagen

```shell
> DOCKER_BUILDKIT=1 docker build --progress=plain -t="kubernetescourse/our-first-image:v1" .
asdf    asdf    asdfas d
```

notes:

El uso de la variable de entorno es necesaria para utilizar BuildKit/buildx. 

A partir de Septiembre de 2020, esta opción está activada por defecto en Docker Desktop
for Mac y Docker Desktop for Windows. En Linux, todavía es necesario utilizar la variable
de entorno o añadire la siguiente opción a `/etc/docker/daemon.json`

```json
{ "features": { "buildkit": true } }
```

La opción `-t` añade un tag a la imagen. Si no se pone ningún tagname (en nuestro caso
`:v1`) docker utilizará `:latest` por defecto.

Como véis, estamos ya poniendo el repositorio de Docker Hub donde vamos a subir la imagen.
Recordad cómo subimos las imágenes a Docker Hub en el módulo 3 usando el comando

```shell
> docker push [repository]/[name]:[tag]
```

^^^^^^

### 💻️Práctica 💻️
 
* Podemos ver la imagen que acabamos de construir

```shell
> docker image ls --filter 'reference=kubernetescourse/*:v1'
asdf    asdf    asdfas d
```

* Veamos las capas que contiene nuestra imagen:

```shell
$ docker image history kubernetescourse/our-first-image:v1
IMAGE          CREATED              CREATED BY                                      SIZE      COMMENT
7d761578acff   About a minute ago   EXPOSE map[80/tcp:{}]                           0B        buildkit.dockerfile.v0 
<missing>      About a minute ago   RUN /bin/sh -c echo '¡Hola! Soy el contenedo…   37B       buildkit.dockerfile.v0 
<missing>      About a minute ago   RUN /bin/sh -c apt-get update; apt-get insta…   91.7MB    buildkit.dockerfile.v0 
<missing>      About a minute ago   LABEL maintainer=alfonso@alfonsoalba.com        0B        buildkit.dockerfile.v0 
<missing>      2 months ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      2 months ago         /bin/sh -c #(nop) ADD file:5d68d27cc15a80653…   72.8MB
```

notes:

Como comentamos en el módulo anterior del curso, vemos cómo las instrucciones del 
Dockerfile generan capasa en nuestra imagen.

Algunas de las instrucciones, como por ejemplo `LABEL` o `EXPOSE`, no generan
una capa (su tamaño es de 0B) ya que solon añaden metadatos a la imagen.

^^^^^^

#### 💻️ Práctica (cont.) 💻️

* Levantamos la imagen

```bash
> docker run -d -p '8080:80' --name static_web alfonso/static_web:v1 nginx -g "daemon off;"
```

Pregunta ¿porqué usamos la opción daemon off de nginx?

notes:

Porque necesitamos que nginx se ejecute en primer plano y sea el proceso 1 del contenedor.

^^^^^^

### Dockerfile

```Dockerfile [1]
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

[syntax=docker/dockerfile:1](https://docs.docker.com/engine/reference/builder/#syntax)

Utilizar la última versión de la rama 1 de la definición del fichero Dockerfile (1.2.1)

notes:

En el momento de redacción de esta sección, la última version estable del _frontend_ 
de Dockerfile es la 1.2.1 (https://hub.docker.com/r/docker/dockerfile)

^^^^^^

### Dockerfile

```Dockerfile [2]
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

[`FROM`](https://docs.docker.com/engine/reference/builder/#from)

Partimos de la última versión de la imagen de Ubuntu


^^^^^^

### Dockerfile

```Dockerfile [3]
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

[`LABEL`](https://docs.docker.com/engine/reference/builder/#label) 

es el sustituto a la antigua instrucción 
[`MAINTAINER`](https://docs.docker.com/engine/reference/builder/#maintainer)

Damos información sobre cómo contactar con nosotros por email

notes:

La instrucción `LABEL` nos permite añadir metadatos a las imágenes. Estos
  metadatos podemos luego usarlos para buscar imágenes
```bash
> docker image ls -f 'label=maintainer=alfonso@alfonsoalba.com'
```

Podemos añadir las etiquetas que queramos a nuestra imagen


^^^^^^

### Dockerfile

```Dockerfile [4]
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

[`RUN`](https://docs.docker.com/engine/reference/builder/#run) 

Instalamos nginx

notes:

La instrucción `RUN` hace lo siguiente:
  * ejecuta el comando que se pasa como argumento en una nueva capa sobre la última imagen
  * hace commit de una nueva imagen

^^^^^^

### Dockerfile

```Dockerfile [5,6]
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```


[`RUN`](https://docs.docker.com/engine/reference/builder/#run) 

Añadimos el contenido de la página web

^^^^^^

### Dockerfile

```Dockerfile [7]
# syntax=docker/dockerfile:1
FROM ubuntu:latest
LABEL maintainer="alfonso@alfonsoalba.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

[`EXPOSE`](https://docs.docker.com/engine/reference/builder/#expose) 

Exponemos el puerto 80

notes: 

La instrucción `EXPOSE`, como se indica en la documentación, añade al Dockerfile
  información sobre qué puertos son utilizados por los contenedores pero no hace nada
  más, no abre realmente el puerto ni abre ningún socket. Se usa a modo de documentación.
  Tened en cuenta que el puerto por el que se accede al contenedor desde el host
  se puede sobreescribir con la opción `-p`. Además, como veremos cuando hablemos
  de las redes, los contenedores que estén la misma red no tienen limitación
  para comunicarse entre sí: pueden hacerlo por cualquier puerto.

    

