
### Variables de entorno

Dentro de nuestro fichero `compose.yaml`, podemos utilizar variables de entorno

```yaml [3]
services:
  db:
    image: "postgres:${POSTGRES_VERSION:-latest}"
```

Si la variable de entorno `POSTGRES_VERSION` está definida, se utilizará para
seleccionar la imagen de postgres que vamos a utilizar.

^^^^^^

### Variables de entorno

Dos opciones para pasar variables de entorno

```shell
$ POSTGRES_VERSION=14 docker compose up
```

^^^^^^

### Variables de entorno: `.env`

Utilizar un fichero [`.env`](https://docs.docker.com/compose/env-file/)


^^^^^^

### Variables de entorno: `.env`

1. `docker-compose` < v1.28 Este fichero podía leer de dos sitios:
   * En la carpeta en la ejecutabas el comando
   * o de la carpeta definida por `--project-directory` (si se especificaba el comando)
2. `docker-compose` >= 1.28 (incluyendo Compose V2)
   * En la carpeta del proyecto
   * Utilizando la opción `--env-file`


notes:

La primera opción no era muy consistente por lo que en la versión >=1.28 se pasó
a implementar la segunda opción.

El directorio del proyecto es, por orden de precedentia:

* Definido por `--project-directory`
* Carpeta del primer fichero definido por `--file`
* Directorio de trabajo

^^^^^^

### Variables de entorno: `.env`

* Una variable por línea en formato `ENV=VAL`
* Lìneas que empiezan por `#` se ignoran
* Líneas en blanco se ignoran

Las variables definidas en este ficher **no están disponibles dentro de los contenedores
de los servicios**

notes:

Si queremos utilizar estas variables dentro de los contenedores, tendremos que pasarlas
como variables de entorno utilizando la clave `environment:` dentro de `compose.yaml`.


^^^^^^

### Variables de entorno

* COMPOSE_DOCKER_CLI_BUILD
* COMPOSE_API_VERSION
* COMPOSE_CONVERT_WINDOWS_PATHS
* COMPOSE_FILE
* COMPOSE_HTTP_TIMEOUT
* COMPOSE_PROFILES
* COMPOSE_PROJECT_NAME
* COMPOSE_TLS_VERSION
* DOCKER_CERT_PATH
* DOCKER_HOST
* DOCKER_TLS_VERIFY

notes:

Mostramos aquí algunas variables de entorno que utiliza compose. El listado
completo [puedes verlo aquí](https://docs.docker.com/compose/reference/envvars/)

Muchas de estas variables tienen equivalente como una opción del comando `docker compose`,
por ejemplo `--profile`, `--file`. Otras no, como por ejemplo `COMPOSE_DOCKER_CLI_BUILD`.

^^^^^^

### Variables de entorno

* ${VARIABLE:-default} default si VARIABLE no está definida o está vacía
* ${VARIABLE-default} default solo si VARIABLE no está definida
* ${VARIABLE:?err} termina con el mensaje de error `err` si VARIABLE no está definida o está vacía
* ${VARIABLE?err} termina con el mensaje de error `err` si VARIABLE no está definida

^^^^^^

### Variables de entorno

Utilizar `$$` si queremos evitar la interpolación por parte de Compose:

```yaml
web:
  build: .
  command: "$$VAR_NOT_INTERPOLATED_BY_COMPOSE"
```

Este doble $ permite que podamos usar la variable de entorno `$VAR_NOT_INTERPOLATED_BY_COMPOSE`
como parte del comando del servicio `web`