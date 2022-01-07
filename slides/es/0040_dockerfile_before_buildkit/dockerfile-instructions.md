### Instrucciones

* [`ENV`](https://docs.docker.com/engine/reference/builder/#env)
* [`WORKDIR`](https://docs.docker.com/engine/reference/builder/#workdir)
* [`ARG`](https://docs.docker.com/engine/reference/builder/#arg)
* [`EXPOSE`](https://docs.docker.com/engine/reference/builder/#expose)
* [`USER`](https://docs.docker.com/engine/reference/builder/#user)

^^^^^^

### `ENV`

Fija el valor de una variable de entorno

Una vez fijada:
* Esta variable está disponible en todas las instrucciones posteriores
* Se puede utilizar en otras instrucciones

notes:

[Documentación de la instrucción](https://docs.docker.com/engine/reference/builder/#env)

Las variables de entorno funcionan como en bash. A continuación
se muestran los comandos en los que se pueden utilizar:
* ADD
* COPY
* ENV
* EXPOSE
* FROM
* LABEL
* STOPSIGNAL
* USER
* VOLUME
* WORKDIR

Más información [aquí](https://docs.docker.com/engine/reference/builder/#environment-replacement).

^^^^^^

### `ENV`

Tiene dos formatos:

* `ENV <key> <value>`
* `ENV <key>=<value> <key>=<value> ...`

Ejemplos

```Dockerfile
ENV nombre="Alfonso" apellidos=Alba\ García \
    myCat=gatu
```

^^^^^^

### `ENV`

**Las variables de entorno definidas con ENV en el Dockerfile están disponibles
en contenedor sobre el que se ejecute la imagen**

Si solo las necesitamos para ejecutar un comando, podemos hacer lo siguiente:

```Dockerfile
RUN <key>=<value> <command>
```

^^^^^^

### `ENV`

Las variables definidas con `ENV` pueden sobreescribirse cuando se crea el contenedor:

```bash
> docker run --env <key>=<value>
```


^^^^^^

### `WORKDIR`

Configura el directorio de trabajo para todas las intrucciones `RUN`, `CMD`,
`ENTRYPOINT`, `COPY` o `ADD` que se ejecuten posteriormente

Si el directorio de trabajo no existe, este se crea.

^^^^^^

### `WORKDIR`

Se pueden pasar rutas absolutas

```Dockerfile
WORKDIR /usr/src/app
```

... o relativas **a la última instrucción `WORKDIR`**

```Dockerfile
# pwd es /usr/src/app 
WORKDIR /usr/src/app
...
WORKDIR bin
# pwd es /usr/src/app/bin
```

^^^^^^

### `ARG`

Define una variable que los usuarios pueden definir en el momento de construir 
la imagen utilizando el comando `docker build`.

```Dockerfile
ARG <name>[=<default value>]
```

```bash
> docker build --build-arg <name>=<value>
```

^^^^^^

### `ARG`

### ⚠️

**NO se recomienda utilizar este mecanismo para pasar _secrets_ como claves, 
contraseñas, etc.**

**¿Por qué? Estos valores serán visibles en la imagen a través del comando 
`docker history`**

^^^^^^

### `ARG`: valores por defecto

Admite la definición de valores por defecto

```Dockerfile
FROM alpine
ARG user=someuser
...
```

Si no se pasa el argumento `user`, este tenrá el valor `someuser` por defecto

^^^^^^

### `ARG`: ámbito de validez

Una variable definida con ARG empieza a tener validez a partir de la línea en la que esta se define.

```Dockerfile
FROM alpine
RUN RAILS_ENV=${ENVIRONMENT:-production} bin/rails ...
...
ARG ENVIRONMENT
RUN RAILS_ENV=${ENVIRONMENT} bin/rails ...
```

```bash
> docker build --build-arg ENVIRONMENT=staging
```

* la primera vez que se ejecuta `bin/rails`, RAILS_ENV valdrá `production`
* la segunda vez que se ejecuta `bin/rails`, RAILS_ENV valdrá `staging`

^^^^^^

### `ARG`: impacto sobre la caché

Las variables definidas como `ARG` no se persisten en la imagen, mientras que 
las difinidas como `ENV` sí

La definición de una variable `ARG` no causa un _cache miss_

El _cache miss_ se produce en el primer uso de la variable, no en su definición

^^^^^^

### `ARG`: impacto sobre la caché

```Dockerfile
FROM alpine
ARG APP_VERSION
RUN echo $APP_VERSION
```

Si ejecutamos primero 

```bash
> docker build --build-arg APP_VERSION=1.0.0
```

y después ejecutamos 

```bash
> docker build --build-arg APP_VERSION=1.0.1
```

El _cache miss_ tiene lugar en el tercer paso 

`RUN echo $APP_VERSION` 

del proceso de construcción de la imagen, no en el paso 2.

^^^^^^

### `ARG`

Documentación de la instrucción [`ARG`](https://docs.docker.com/engine/reference/builder/#arg)

^^^^^^

### `EXPOSE`

```Dockerfile
EXPOSE <port> [<port>/<protocol>...]
```

**Informa** a Docker de que el contenedor escucha en este puerto en tiempo 
de ejecución.

^^^^^^

### `EXPOSE`

Esta instrucción es **informativa** 

Su uso no supone la publicación del puerto en tiempo de ejecución del contenedor

Para publicar el puerto, se debe utilizar la opción `-p` del comando 
`docker container run` o `docker container create`

notes:

Como se indica en la propia documentación de docker, esta insturcción funciona
como una forma de documentación: la persona que _construye_ el contenedor
documenta qué puertos son los que pueden publicarse para que la persona que 
_crea_ los publique.

Ver [aquí](https://docs.docker.com/engine/reference/builder/#expose) la documentación completa del comando.

^^^^^^

### `USER`

```Dockerfile
USER <user>[:<group>] or
USER <UID>[:<GID>]
```

Después de esta instrucción, todos los comandos `RUN`, `CMD` y `ENTRYPOINT` que se
ejecuten lo harán con el usuario indicado (y el grupo si se define)

Si el usuario no tiene un grupo principal **los comandos se ejecutar con el grupo root**