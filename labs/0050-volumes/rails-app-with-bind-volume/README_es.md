# Ejecutar aplicación en Rails usando un _bind volume_

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Ilustrar el uso de los _bind volumes_.

## La aplicación

Utilizaremos la aplicación `blog` que creamos en el [taller anterior](../dockerfile-to-create-rails-projects/README_es.md). 
Si no tienes la aplicación rails creada, sigue los pasos de ese taller para generarla.
Una vez la hayas generado, copiala a la carpeta de este taller:

```shell
$ cp -r ../../0040-dockerfile-and-buildkit/dockerfile-to-create-rails-projects/blog .
```

## El _problema_

Cada vez que hagamos un cambio en el código, necesitaremos crear una nueva imagen. Esto está muy bien para
producción, pero para desarrollo es extremadamente incómodo. Si cada vez que hacemos el más mínimo cambio,
necesito esperar 30 segundos para poder recargar el navegador y verlo, la productividad del equipo de desarrollo
caerá en picado.

Veamos cómo los _bind volumes_ nos pueden ayudar a resolver este problema.

## La imagen

Utilizaremos la imagen de docker `dockerlabs/rails-tutorial:2` que creamos en el 
taller [`Dockerfile` para nuestra aplicación Rails](../../0040-dockerfile-and-builkit/dockerfile-for-our-rails-application).  

Si borraste esta imagen, vuelve a crearla siguiendo los pasos que dimos en ese taller.

## Contenedor con _bind volume_

Vamos a levantar el contenedor pero, en lugar de utilizar el código Rails que está dentro de la
imagen, vamos a utilizar el código que está en la carpeta `blog/` que copiamos en el paso anterior.

Para ello, utilizaremos un _bind volume_:

```shell
$ docker run \
--detach \
-p 3000:3000 \
--rm -ti \
--name rails-tutorial \
--mount "type=bind,src=$(pwd)/blog,dst=/blog"  \
dockerlabs/rails-tutorial:2
```
Apuntar el navegador a http://localhost:3000 para ver la página.

## Modificar el código

Crea un fichero `blog/public/test.html` con el siguiente contenido:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Esto es un test</title>
  </head>
  <body>
    Esto es un test
  </body>
</html>
```

Apunta el navegador a `http://localhost:3000/test.html` para ver la página que acabamos de crear.

A diferencia de los talleres anteriores, no hemos necesitado construir la imagen para poder ver
las modificaciones a nuestro código.

Tambien vemos cómo, en caso de montar un _bind volume_ en una carpeta que ya existe en la imagen,
vemos el contenido del _bind volume_ en lugar del contenido de la carpeta original.

Por último, es posible utilizar la opción `-v` en lugar `--mount` de la siguiente forma:

```shell
$ docker run \
--detach \
-p 3000:3000 \
--rm -ti \
--name rails-tutorial \
-v $(pwd)/blog:/blog  \
dockerlabs/rails-tutorial:2
```

## Limpieza

Borrar la imagen `dockerlabs/rails-tutorial` y el contenedor `rails-tutorial` si no habéis usado la opción `--rm`

```shell
$ docker container stop rails-tutorial
$ docker image rm dockerlabs/rails-tutorial:2
$ docker container rm rails-tutorial
```

## Siguiente paso

Para poder trabajar con Rails, necesitaremos una base de datos. En el [siguiente taller](../labs\0050-volumes\rails-app-with-bind-volume/README_es.md) veremos cómo crearla y persistir los datos utilizando volúmenes.