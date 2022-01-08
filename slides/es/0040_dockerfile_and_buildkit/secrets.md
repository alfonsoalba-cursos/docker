### _Secrets_

La gestión de información sensible como contraseñas o claves privadas

que se puedan necesitar durante el proceso de construcción de una imagen

ha sido una de las mejoras estrella que introdujo BuildKit

[Documentación sobre BuildKit Secrets](https://docs.docker.com/develop/develop-images/build_enhancements/#new-docker-build-secret-information)

notes:

Antes de BuilKit, no existía una manera sencilla de gestionar la información
sensible que se pasaba durante el proceso de construcción de una imagen. Aunque 
se podía hacer utilizando un proceso con múltiples pasos (_multistage build_)
era tedioso, propenso a errores y a acabar dejando la información sensible en la imagen
sin darnos cuenta.

El artículo [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066) es también una buena
fuente para ver cómo utilizar esta funcionalidad de BuildKit.

^^^^^^

### _Secrets_

Crear un fichero con la información sensible:

```shell
$ echo "ThePassword" > secret.txt
```

^^^^^^

### _Secrets_

```Dockerfile
# syntax=docker/dockerfile:1

FROM alpine

# Acceder desde la ruta por defecto
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret

# Cambiar la ruta en la que mysecret estará disponible:
RUN --mount=type=secret,id=mysecret,dst=/foobar cat /foobar
```

notes:

Modificamos nuestro Dockerfile para utilizar esta información sensible. Para ello
utilizamos la opción `--mount` de la instrucción `RUN`.

^^^^^^

### _Secrets_

Cuando ejecutamos el comando `docker build` utilizamos la opción `--secret`

```shell
$ docker build --progress=plain --secret id=mysecret,src=mysecret.txt .
```

^^^^^^

### `--ssh`

Una de las operaciones más habituales que es necesario realizar cuando se construye una imagen es

**acceder a un repositorio privado con el código**

^^^^^^

### `--ssh`

Esta opción del comando `docker build` nos facilita enormemente la tarea.

Esta opción nos permite exportar el agente SSH al contexto de BuildKit para poder usarlo durante la construcción

Para que funcione, tendremos que cargar las claves en el agente usando el comando `ssh-add`

^^^^^^

### `--ssh`: ejemplo

```dockerfile
# syntax=docker/dockerfile:1
FROM alpine
RUN apk add --no-cache openssh-client git
# Descarga la clave pública de github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
# Clona el repositorio privado
RUN --mount=type=ssh git clone git@github.com:myorg/myproject.git myproject
```

```shell
$ docker build --ssh default .
```

notes:

En este ejemplo, estamos utilizando la configuración por defecto (`--ssh default`)
con consiste en _compartir_ el agente de nuestra máquina local con el contexto de 
construcción de la imagen (en realidad lo que se hace es reenviar peticiones desde
el contexto hasta el agente que se ejecuta en nuestra máquina local).

La opción permite pasar la ruta al socket del agente, por ejemplo:

```shell
$ docker build --ssh default=/path/to/socket .
```

El valor por defecto es `default=$SSH_AUTH_SOCK`.

También es posible utilizar un identificador:

```dockerfile
...
RUN --mount=type=ssh,id=projecta git clone projecta …
RUN --mount=type=ssh,id=projectb git clone projectb …
...
```

y construir la imagen:

```shell
$ docker build --ssh projecta=./projecta.pem --ssh projectb=./projectb.pem .
```

Recuerda que lo único que estamos haciendo es seleccionar la clave privada
a utilizar, **no se transifere al contexto de ejecución**. Ambas claves deberán
haber sido previamente cargadas usando `ssh-add`.

Más información en [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066)

