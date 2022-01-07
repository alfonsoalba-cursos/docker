### Añadiendo ficheros a nuestra imagen

Las instrucciones para añadir ficheros a nuestra imagen son:

* [`COPY`](https://docs.docker.com/engine/reference/builder/#copy)
* [`ADD`](https://docs.docker.com/engine/reference/builder/#add)

En la propia documentación de Docker se recomienda el uso de `COPY` sobre `ADD`.

notes:

Cronológicamente, primero apareción la instrucción `ADD` y luego la instrucción 
`COPY`.

El problema que tiene `ADD` es que demasiadas cosas (copia y descomprime) y 
causaba confusión. Para  resolverlo se añadio la instrucción `COPY` que sólo 
hace una cosa.

^^^^^^

### Añadiendo ficheros a nuestra imagen

```Dockerfile
COPY [--chown=<user>:<group>] <src>... <dest>
COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

La segunda opción es necesaria para rutas que contienen espacios

`chown` sólo está disponible para ficheros Dockerfile que se usen para construir
imágenes para contenedores Linux

notes:

La instrucción `COPY` acepta múltiples fuentes `<src>`. Las rutas se interpretarán
siempre como relativas al contexto en el que se construye la imagen.

`<src>` puede contener _wildcards_ que se resuelven utilizando las reglas
de la función [`filepath.Match`](https://golang.org/pkg/path/filepath/#Match) de Go

`<dest>` puede ser:
* Una ruta absoluta dentro de la imagen
* Una ruta relativa a `WORKDIR`

^^^^^^

### Añadiendo ficheros a nuestra imagen

Si no se especifica `--chown` **los ficheros tendrán UID y GID 0**

`--chown` acepta tanto un nombre de usuario / UID o nombre de grupo / GID

```Dockerfile
COPY --chown=55:mygroup files* /somedir/
COPY --chown=bin files* /somedir/
COPY --chown=1 files* /somedir/
COPY --chown=10:11 files* /somedir/
```

^^^^^^

### Añadiendo ficheros a nuestra imagen

Si se utilizan UID o GID, estos no tienen que existir necesariamente en los ficheros 
`/etc/passwd` y `/etc/group` de la imagen

Si se utilizan nombres de usuario o de grupo, la construcción fallará si estos
no se pueden resolver usando los ficheros `/etc/passwd` y `/etc/group` de la imagen

^^^^^^

### ¿Cuál es la diferencia entre `ADD` y `COPY`?

`COPY` sólo copia ficheros

`ADD` permite desempaquetar ficheros `.tgz` directamente y tiene soporte para 
descargar ficheros desde URLs remotas

^^^^^^

### ¿Cuál es la diferencia entre `ADD` y `COPY`?

[Como indica la propia documentación](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy)
el uso de `ADD` se recomienda sólo para añadir ficheros y descomprimirlos. Por ejemplo:


```Dockerfile
FROM scratch
ADD alpine-minirootfs-20190925-x86_64.tar.gz /
CMD ["/bin/sh"]
```

