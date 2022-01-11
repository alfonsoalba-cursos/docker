### `RUN --mount=type=cache`

Caché para compiladores y gestores de paquetes

```dockerfile [3]
FROM ubuntu
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt update && apt-get --no-install-recommends install -y gcc
```

notes:

[Documentación en el repo de BuilKit](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md#run---mounttypecache)

^^^^^^

### `RUN --mount=type=cache`

El contenido de estos directorios permanece entre diferentes ejecuciones de `docer buildx build`

**Usarlos solo para mejorar el rendimiento**

Nuestro proceso de construcción debe funcionar con cualquier contenido presente en esta carpeta

notes:

Estas carpetas pueden ser utilizadas concurrentemente por varios constructores de imágenes
([ver la opción `shared`](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md#run---mounttypecache)), o el
recolector de basura puede borrarlas arbitrariamente si nos quedamos sin espacio. Por este motivo,
nuestro proceso de construcción de imágenes debe estar preparado para gestionar estas situaciones.

Siguiendo con el ejemplo anterior de `apt`. Sería un error no ejecutar `apt update` en este paso:

```dockerfile
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
  apt-get --no-install-recommends install -y gcc
```

asumiendo que como tenemos cacheadas las cosas en `/var/cache/apt/` y `/var/lib/apt`, 
el comando `apt-get install` ya tiene todo lo que necesita.

El contenido de esos directorios puede cambiar entre builds porque otros constructores los utilizan
o pueden vaciarse si nos quedamos sin espacio. En este caso, el comando `apt` sabe muy bien
cómo gestionar su caché y no necesita nuestra ayuda, por lo que saltarnos este paso
no es buena idea.

^^^^^^

#### `RUN --mount=type=cache`

* `uid`,`gid`: ID de usuario y grupo para el directorio (0 por defecto)
* `mode`: permisos del directorio
* `readonly`
* `id`
* `from` y `source` permiten utilizar un directorio utilizado en un _build stage_ anterior
* `sharing` configura el tipo de acceso
  * `shared` acceso concurrente al directorio 
  * `private` crea un directorio para cada _builder_
  * `locked` semáforo: si un segundo _builder_ intenta acceder mientras otro lo está usando, este segundo
  queda en espera

notes:

`id` nos permite definir un identificador para separar o diferenciar diferentes caches. Por
defecto toma el mismo valor que `target`

[En la documentación](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md#run---mounttypecache)
puedes ver la versión actualizada de todas las opciones disponibles 

