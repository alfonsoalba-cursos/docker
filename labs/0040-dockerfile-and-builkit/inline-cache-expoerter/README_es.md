# _Inline cache exporter_

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Ilustrar el uso de _inline cache exporter_

## Requisitos previos

En este taller necesitaremos:
* dos máqinas virtuales con docker instalado, a las que me referiré como `vm-1` y  `vm-2`
* una cuenta en el _registry_ `hub.docker.com` para subir y descargar la imagen generada.

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el [taller anterior](../dockerfile-for-our-rails-application/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta de este taller:

```shell
$ cp -r ../dockerfile-to-create-rails-projects/blog
```

## Creamos el fichero `Dockerfile`

Utilizaremos el fichero [`Dockerfile`](./Dockerfile) junto a este README.

## Construimos la imagen

En la primera de las máquinas virtuales, creamos la imagen. Para utilizar el 
_inline cache exporter_, pasaremos el valor `BUILDKIT_INLINE_CACHE=1` como 
argumento:

```shell
vm-1 $ docker buildx build --build-arg BUILDKIT_INLINE_CACHE=1 -t kubernetescourse/rails-tutorial:inline-cache .
```

Subimos la imagen al _registry_:

```shell
vm-1 $ docker login
vm-1 $ docker push kubernetescourse/rails-tutorial:inline-cache
```

## Construir la imagen en la segunda máquina virtual

Necesitamos transferir los siguientes ficheros a la segunda máquina virtual:
* `Dockerfile`
* La carpeta `blog`

Creamos en `vm-2` la carpeta `~/inline-cache-exporter`:

```shell
vm-2 $ mkdir inline-cache-exporter
```

Transferimos los ficheros utilizando scp:

```self
vm-1 $ scp -r blog/ root@212.227.168.11:inline-cache-exporter/
vm-1 $ scp Dockerfile root@212.227.168.11:inline-cache-exporter/Dockerfile
```

Una vez el fichero está en la máquina, ejecutamos el mismo comando:

```shell
vm-2 $ docker buildx build --cache-from kubernetescourse/rails-tutorial:inline-cache --build-arg BUILDKIT_INLINE_CACHE=1 -t kubernetescourse/rails-tutorial:inline-cache-2 .

[+] Building 17.8s (16/16) FINISHED
 => [internal] load build definition from Dockerfile                                                                                     0.0s
 => => transferring dockerfile: 215B                                                                                                     0.0s 
 => [internal] load .dockerignore                                                                                                        0.0s 
 => => transferring context: 2B                                                                                                          0.0s 
 => resolve image config for docker.io/docker/dockerfile:1                                                                               1.3s 
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1357b3b2          0.0s
 => [internal] load build definition from Dockerfile                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                        0.0s 
 => [internal] load metadata for docker.io/library/ruby:3.0                                                                              0.0s 
 => importing cache manifest from kubernetescourse/rails-tutorial:inline-cache                                                           1.3s 
 => [1/5] FROM docker.io/library/ruby:3.0                                                                                                0.0s 
 => [internal] load build context                                                                                                        0.2s
 => => transferring context: 7.93MB                                                                                                      0.2s
 => CACHED [2/5] RUN apt update && apt install -y vim                                                                                    1.1s
 => => pulling sha256:782e7f6eb354aa2512585c01dfa18defb2169e73ab5d1da14934db78a273af5e                                                   0.4s 
 => [3/5] COPY ./blog /blog                                                                                                              0.5s
 => [4/5] WORKDIR /blog                                                                                                                  0.1s
 => [5/5] RUN bundle install                                                                                                            12.2s
 => exporting to image                                                                                                                   0.0s
 => => exporting layers                                                                                                                  0.0s
 => => writing image sha256:d108250e2e7778f0442ce4d1597ecc1b8f227765b56fff9cfc246c7c6e791fb6                                             0.0s
 => exporting cache                                                                                                                      0.0s
 => => preparing build cache for export                                                                                                  0.0s
```

Al construir la imagen, la instrucción `RUN apt update && apt install vim` no se ha ejecutado.
En su lugar, BuildKit ha descargado la capa de la cahé y la ha reutilizado:

```text
...
=> CACHED [2/5] RUN apt update && apt install -y vim                                       1.1s
 => => pulling sha256:782e7f6eb354aa2512585c01dfa18defb2169e73ab5d1da14934db78a273af5e     0.4s 
...
```

