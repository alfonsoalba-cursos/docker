# `Dockerfile` para nuestra aplicación Rails

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Tenemos una aplicación Rails, cuyos ficheros están situados en nuestro host. Queremos
crear una imagen con la aplicación y ejecutarla posteriormente un contenedor.


## La aplicación

Utilizaremos la aplicación `blog` que creamos en el [taller anterior](../dockerfile-to-create-rails-projects/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta de este taller:

```shell
$ cp -r ../dockerfile-to-create-rails-projects/blog
```

## Creamos el fichero `Dockerfile`

Para que la aplicación en rails funcione dentro del contenedor,
tenemos que dar los siguientes pasos:

* Partir de una image que tenga `ruby` instalado
* Copiar los ficheros del proyecto
* Instalar las dependencias (gemas)
* Configurar el comando de arranque para que levante el servidor de aplicaciones de
  Rails

Podéis [ver el fichero `Dockerfile`](./Dockerfile) junto a este README.

## Construimos la imagen

Creamos la imagen:

```shell
$ docker buildx build -t dockerlabs/rails-tutorial:2 .
```

 En el taller anterior [_BuildKit cache mounts_](../buildkit-cache-mounts/) utilizamos
 la imagen `dockerlabs/rails-tutorial`. En este laboratorio utilizaremos el tag `:2` para 
 diferenciarla de la anterior.

## Levantamos el contenedor

Para levantar un contenedor con esta imagen ejecutamos:

```shell
$ docker run -d --rm --name rails-tutorial-2 -p 3000:3000 dockerlabs/rails-tutorial:2
```

Abrimos un navegador y lo apuntamos a [http://localhost:3000](http://localhost:3000),
donde deberíamos ver la página de inicio de nuestro tutorial.

## Limpieza

Paramos el contenedor (que se borrará solo si lo has levantado usando la opción `--rm`):

```shell
$ docker container stop rails-tutorial-2
```

Borramos la imagen:

```shell
$ docker image rm dockerlabs/rails-tutorial:2
```

## Siguiente paso

En el [siguiente laboratorio](../buildkit-cache-mounts/README_es.md) empezaremos a optimizar el proceso de construcción de nuestra imagen
mediante el uso de _BuildKit cache mounts_.