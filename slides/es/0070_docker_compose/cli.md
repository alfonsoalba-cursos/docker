### _Command Line Interface_

En la página [Docker Compose](https://docs.docker.com/engine/reference/commandline/compose/) 
podéis encontrar la documentación del comando, incluyendo enlaces a los 
[subcomandos de `docker compose`](https://docs.docker.com/engine/reference/commandline/compose/#child-commands)

^^^^^^
### _Command Line Interface_

```shell
wordpress-compose > docker compose up
```

notes:

Ya hemos visto el primer comando del CLI de `docker compose` en la sección anterior. 
[El comando `docker compse up`](https://docs.docker.com/engine/reference/commandline/compose_up/)

Este comando construye, crear e inicia los servicios definidos en el fichero
`docker compose`

^^^^^^

#### _Command Line Interface_: `docker compose up`

Algunas opciones útiles del comando `docker compose up`

* `-d`:  ejecuta los contenedores en segundo plano
* `--build`: construye las imágenes antes de levantar los contenedores
* `--force-recreate`: en lugar de reutilizar contenedores anteriores, los vuelve a crear

[Más información](https://docs.docker.com/engine/reference/commandline/compose_up/)


notes:

Puedes ver todas las opciones del comando `up` usando el comando:

```shell
$ docker compose up --help

Usage:  docker compose up [SERVICE...]

Create and start containers

Options:
      --abort-on-container-exit   Stops all containers if any container was stopped. Incompatible with -d
      --always-recreate-deps      Recreate dependent containers. Incompatible with --no-recreate.
      --attach stringArray        Attach to service output.
      --attach-dependencies       Attach to dependent containers.
      --build                     Build images before starting containers.
  -d, --detach                    Detached mode: Run containers in the background
      --exit-code-from string     Return the exit code of the selected service container. Implies --abort-on-container-exit       
      --force-recreate            Recreate containers even if their configuration and image haven't changed.
      --no-build                  Don't build an image, even if it's missing.
      --no-color                  Produce monochrome output.
      --no-deps                   Don't start linked services.
      --no-log-prefix             Don't print prefix in logs.
      --no-recreate               If containers already exist, don't recreate them. Incompatible with --force-recreate.
      --no-start                  Don't start the services after creating them.
      --quiet-pull                Pull without printing progress information.
      --remove-orphans            Remove containers for services not defined in the Compose file.
  -V, --renew-anon-volumes        Recreate anonymous volumes instead of retrieving data from the previous containers.
      --scale scale               Scale SERVICE to NUM instances. Overrides the scale setting in the Compose file if present.     
  -t, --timeout int               Use this timeout in seconds for container shutdown when attached or when containers are
                                  already running. (default 10)
      --wait                      Wait for services to be running|healthy. Implies detached mode.
```

^^^^^^

#### _Command Line Interface_: [`docker compose down`](https://docs.docker.com/engine/reference/commandline/compose_down/)

Detiene y borra los contenedores creados con el comando `docker compose up`

Por defecto borra:
* Los contenedores para los servicios definidos en el fichero `docker compose`
* Las redes definidas en la sección `networks` del fichero de Compose
* La red por defecto si se ha utilizado una.


^^^^^^

#### _Command Line Interface_: [`docker compose down`](https://docs.docker.com/engine/reference/commandline/compose_down/)

Las siguientes opciones permiten borrar más cosas:
* `--rmi` borra imágenes
* `-v, --volumes` borra los volúmenes declarados en la sección `volumes` así como
   los volúmenes anónimos


^^^^^^
#### _Command Line Interface_: [`docker compose exec`](https://docs.docker.com/engine/reference/commandline/compose_exec/)

Ejecuta un comando en un contenedor en ejecución:

```shell
wordpress-compose > docker compose exec wordpress bash
root@31d0474ac91f:/var/www/html#
```

Es el equivalente al comando `docker exec`

notes:

Por defecto, este comando asigna un TTY de forma que se pueden ejecutar terminales
interactivas sin necesidad de opciones adicionales.

Las opciones de este comando son las siguientes:

```text
$ docker compose exec --help


Usage:  docker compose exec [options] [-e KEY=VAL...] [--] SERVICE COMMAND [ARGS...]

Execute a command in a running container.

Options:
  -d, --detach                       Detached mode: Run command in the background.
  -e, --env stringArray              Set environment variables
      --index int                    index of the container if there are multiple instances of a service [default: 1].
                                     (default 1)
  -T, --no-TTY docker compose exec   Disable pseudo-TTY allocation. By default docker compose exec allocates a TTY.
      --privileged                   Give extended privileges to the process.
  -u, --user string                  Run the command as this user.
  -w, --workdir string               Path to workdir directory for this command.

```

^^^^^^
#### _Command Line Interface_: [`docker compose top`](https://docs.docker.com/engine/reference/commandline/compose_top/)

Muestra los procesos en ejecución

```shell
wordpress-compose > docker compose top

wordpress-compose_db_1
PID    USER   TIME   COMMAND
____________________________
2684   999    0:02   mysqld

wordpress-compose_wordpress_1
PID    USER   TIME         COMMAND
__________________________________________
2845   root   0:00   apache2 -DFOREGROUND
3232   xfs    0:00   apache2 -DFOREGROUND
3233   xfs    0:00   apache2 -DFOREGROUND
3234   xfs    0:00   apache2 -DFOREGROUND
3235   xfs    0:00   apache2 -DFOREGROUND
3236   xfs    0:00   apache2 -DFOREGROUND
3240   xfs    0:00   apache2 -DFOREGROUND
3241   xfs    0:00   apache2 -DFOREGROUND
3242   xfs    0:00   apache2 -DFOREGROUND
3243   xfs    0:00   apache2 -DFOREGROUND
3258   xfs    0:00   apache2 -DFOREGROUND
```

^^^^^^
#### _Command Line Interface_: [`docker compose images`](https://docs.docker.com/engine/reference/commandline/compose_images/)

Muestra las imágenes utilizadas por los contenedores

```shell
wordpress-compose > docker compose images

      Container               Repository  Tag      Image Id       Size
________________________________________________________________________
wordpress-compose_db_1        mysql       5.7      cd3ed0dfff7e   416 MB
wordpress-compose_wordpress_1 wordpress   latest   264da8cf7ba4   512 MB
```

notes:

Los contenedores deben estar levantados para que este comando muestre algún resultado

^^^^^^
#### _Command Line Interface_: [`docker compose pause`](https://docs.docker.com/engine/reference/commandline/compose_pause/)

Los comandos `pause` y `unpause` sirven para suspender y reactivar servicios
definidos en `compose.yaml`

notes:

Pausar el contenedor de wordpress:

```shell
wordpress-compose > docker compose pause wordpress
```

Si accedermos a `localhost:8080` el contenedor no responde. Para reactivarlo:

```shell
wordpress-compose > docker compose unpause wordpress
```

^^^^^^
#### _Command Line Interface_: [`docker compose convert`](https://docs.docker.com/engine/reference/commandline/compose_convert/)

Valida el fichero de configuración `compose.yaml` y lo muestra por la consola

notes:

Es el antiguo `docker-compose config`, de hecho, se ha difinido un alias `docker compose config`
que ejecuta `docker convert`

Una de las opciones que permite el comando `docker compose convert` es
obtener el hash de configuración de un servicio:

```shell
wordpress-compose > docker compose config --hash="wordpress"
wordpress 04cb8c6a952ab67a69c95af642d3b31c9a5a7e37baa18aecd79e0bc4b0e4bfde
```

Este hash se utiliza para verificar si la configuración de un servicio ha cambiado. 

Como ejemplo de uso, podríamos intentar desarrollar una aplicación externa 
que monitoriza el fichero y regenera los contenedores
de nuevo si observa alguna modificación en la configuración de un servicio.

Como prueba de uso:

1. Obtener el hash del configuración del servicio `wordpress`
1. Realizar alguna modificación en la configuración del servicio
1. Obtener le nuevo hash de configuración
1. Volver a la configuración original
1. Comprobar que se recupera la configuración original

^^^^^^

#### _Command Line Interface_: [`docker compose kill`](https://docs.docker.com/engine/reference/commandline/compose_kill/)

Permite enviar una señal IPC a un contenedor

```shell
wordpress-compose > docker compose kill -s SIGTERM wordpress
```

notes:

```shell
docker compose kill --help

Usage:  docker compose kill [options] [SERVICE...]

Force stop service containers.

Options:
  -s, --signal string   SIGNAL to send to the container. (default "SIGKILL")
```

[POSIX Signals](https://en.wikipedia.org/wiki/Signal_(IPC)#POSIX_signals)


^^^^^^

#### _Command Line Interface_: [`docker compose logs`](https://docs.docker.com/engine/reference/commandline/compose_logs/)

Muestra los logs de un servicio

```shell
wordpress-compose > docker compose logs -f db
```

^^^^^^

#### _Command Line Interface_: [`docker compose ps`](https://docs.docker.com/compose/reference/ps/)

Muestra los contenedores en ejecución

```shell
wordpress-compose > docker compose ps

        Name                       Command               State          Ports
_____________________________________________________________________________________
wordpress_db_1          docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
wordpress_wordpress_1   docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp
```

^^^^^^

#### _Command Line Interface_: [`docker compose pull`](https://docs.docker.com/engine/reference/commandline/compose_pull/)

Se descarga la imagen asociada a un servicio

```shell
wordpress-compose > docker compose pull wordpress
```

^^^^^^

#### _Command Line Interface_: [`docker compose start`](https://docs.docker.com/engine/reference/commandline/compose_start/) / [`stop`](https://docs.docker.com/engine/reference/commandline/compose_stop/) / [`restart`](https://docs.docker.com/engine/reference/commandline/compose_restart/)

Estos tres comandos sirven para parar, iniciar o reiniciar cualquiera de los servicios
definidos en el fichero `compose.yaml`

```shell
wordpress-compose > docker compose restart wordpress
```

⚠️ Nota importante: las modificaciones realizadas sobre el fichero
`compose.yaml` no se reflejarán ejecutando `restart` o 
`stop -> start`


^^^^^^
#### _Command Line Interface_: [`docker compose run`](https://docs.docker.com/engine/reference/commandline/compose_run/)

Ejecuta un comando utilizando un contenedor definido en uno de los servicios

```shell
wordpress-compose > docker compose run wordpress bash
```

```shell
docker compose ps
                Name                              Command               State          Ports
____________________________________________________________________________________________________
wordpress_db_1                         docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
wordpress_wordpress_1                  docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp
wordpress_wordpress_run_e433c908717e   docker-entrypoint.sh bash        Up      80/tcp
```

notes:

Este comando inicia un nuevo contenedor en el que se ejecuta el comando pasado
como argumento. Para comprobar que se levanta un nuevo contenedor, podemos utilizar
el comando `docker-compos ps` como se indica en la captura de la diapositivam
en la que vemos los dos contenedores:

* `wordpress_wordpress_1` que se levantó con `docker compose up`
* `wordpress_wordpress_run_e433c908717e` que es el que levantamos con 
  `docker compose run`

Además, como vemos en la diapositiva también **el comando `docker compose run`**
no hace port-binding de los puertos definidos en el fichero `compose.yaml`.
Esto se hace así para evitar errores por que los puertos ya puedan estar ocupados,
como es el caso en el ejemplo que nos ocupa en esta diaposisitiva.

Si queremos que los puertos asociados al servicio se creen, podemos usar la
opción `--service-ports` o la opción `-p` si queremos hacerlo de forma manual:

```shell
wordpress-compose > docker compose run --service-ports wordpress bash
```

Si el servicio que queremos levanta depende de otros servicios, el comando
run verifica que estos servicios estén levantados (levantándolos si no lo están) 
antes de ejecutar el comando.

^^^^^^
#### _Command Line Interface_: [`docker compose logs`](https://docs.docker.com/engine/reference/commandline/compose_logs/)

Muestra los logs de un servicio.

Muy útil cuando se han levantado los servicios usando `docker compose up --detach`
