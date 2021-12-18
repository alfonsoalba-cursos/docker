### Command Line Interface

```bash
wordpress-compose > docker-compose up
```

notes:

Ya hemos visto el primer comando del CLI de `docker-compose`. El comando
`up` 

Este comando construye, crear e inicia los servicios definidos en el fichero
`docker-compose`

^^^^^^

#### Command Line Interface: `docker-compose up`

Algunas opciones útiles del comando `docker-compose up`

* `-d`:  ejecuta los contenedores en segundo plano
* `--build`: construye las imágenes antes de levantar los contenedores
* `--force-recreate`: en lugar de reutilizar contenedores anteriores, los vuelve a crear

[Más información](https://docs.docker.com/compose/reference/up/)


notes:

Puedes ver todas las opciones del comando `up` usando el comando:

<pre>
docker-compose up -h
Builds, (re)creates, starts, and attaches to containers for a service.

Unless they are already running, this command also starts any linked services.

The `docker-compose up` command aggregates the output of each container. When
the command exits, all containers are stopped. Running `docker-compose up -d`
starts the containers in the background and leaves them running.

If there are existing containers for a service, and the service's configuration
or image was changed after the container's creation, `docker-compose up` picks
up the changes by stopping and recreating the containers (preserving mounted
volumes). To prevent Compose from picking up changes, use the `--no-recreate`
flag.

If you want to force Compose to stop and recreate all containers, use the
`--force-recreate` flag.

Usage: up [options] [--scale SERVICE=NUM...] [SERVICE...]

Options:
    -d, --detach               Detached mode: Run containers in the background,
                               print new container names. Incompatible with
                               --abort-on-container-exit.
    --no-color                 Produce monochrome output.
    --quiet-pull               Pull without printing progress information
    --no-deps                  Don't start linked services.
    --force-recreate           Recreate containers even if their configuration
                               and image haven't changed.
    --always-recreate-deps     Recreate dependent containers.
                               Incompatible with --no-recreate.
    --no-recreate              If containers already exist, don't recreate
                               them. Incompatible with --force-recreate and -V.
    --no-build                 Don't build an image, even if it's missing.
    --no-start                 Don't start the services after creating them.
    --build                    Build images before starting containers.
    --abort-on-container-exit  Stops all containers if any container was
                               stopped. Incompatible with -d.
    -t, --timeout TIMEOUT      Use this timeout in seconds for container
                               shutdown when attached or when containers are
                               already running. (default: 10)
    -V, --renew-anon-volumes   Recreate anonymous volumes instead of retrieving
                               data from the previous containers.
    --remove-orphans           Remove containers for services not defined
                               in the Compose file.
    --exit-code-from SERVICE   Return the exit code of the selected service
                               container. Implies --abort-on-container-exit.
    --scale SERVICE=NUM        Scale SERVICE to NUM instances. Overrides the
                               `scale` setting in the Compose file if present.
</pre>

^^^^^^

#### Command Line Interface: [`docker-compose down`](https://docs.docker.com/compose/reference/down/)

Detiene y borra los contenedores creados con el comando `docker-compose up`

Por defecto borra:
* Los contenedores para los servicios definidos en el fichero `docker-compose`
* Las redes definidas en la sección `networks` del fichero de Compose
* La red por defecto si se ha utilizado una.


^^^^^^

#### Command Line Interface: [`docker-compose down`](https://docs.docker.com/compose/reference/down/)

Las siguientes opciones permiten borrar más cosas:
* `--rmi` borra imágenes
* `-v, --volumes` borra los volúmenes declarados en la sección `volumes` así como
   los volúmenes anónimos


^^^^^^
#### Command Line Interface: [`docker-compose exec`](https://docs.docker.com/compose/reference/exec/)

Ejecuta un comando en un contenedor en ejecución:

```bash
wordpress-compose > docker-compose exec wordpress bash
root@31d0474ac91f:/var/www/html#
```

Es el equivalente al comando `docker exec`

notes:

Por defecto, este comando asigna un TTY de forma que se pueden ejecutar terminales
interactivas sin necesidad de opciones adicionales.

Las opciones de este comando son las siguientes:

<pre>
docker-compose exec [options] [-e KEY=VAL...] SERVICE COMMAND [ARGS...]

Options:
    -d, --detach      Detached mode: Run command in the background.
    --privileged      Give extended privileges to the process.
    -u, --user USER   Run the command as this user.
    -T                Disable pseudo-tty allocation. By default `docker-compose exec`
                      allocates a TTY.
    --index=index     index of the container if there are multiple
                      instances of a service [default: 1]
    -e, --env KEY=VAL Set environment variables (can be used multiple times,
                      not supported in API < 1.25)
    -w, --workdir DIR Path to workdir directory for this command.
</pre>


^^^^^^
#### Command Line Interface: [`docker-compose top`](https://docs.docker.com/compose/reference/top/)

Muestra los procesos en ejecución

```bash
wordpress-compose > docker-compose top

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
#### Command Line Interface: [`docker-compose images`](https://docs.docker.com/compose/reference/images/)

Muestra las imágenes utilizadas por los contenedores

```bash
wordpress-compose > docker-compose images

      Container               Repository  Tag      Image Id       Size
________________________________________________________________________
wordpress-compose_db_1        mysql       5.7      cd3ed0dfff7e   416 MB
wordpress-compose_wordpress_1 wordpress   latest   264da8cf7ba4   512 MB
```

notes:

Los contenedores deben estar levantados para que este comando muestre algún resultado

^^^^^^
#### Command Line Interface: [`docker-compose pause`](https://docs.docker.com/compose/reference/pause/)

Los comandos `pause` y `unpause` sirven para suspender y reactivar servicios
definidos en `docker-compose.yml`

notes:

Pausar el contenedor de wordpress:

```bash
wordpress-compose > docker-compose pause wordpress
```

Si accedermos a `localhost:8080` el contenedor no responde. Para reactivarlo:

```bash
wordpress-compose > docker-compose unpause wordpress
```

^^^^^^
#### Command Line Interface: [`docker-compose config`](https://docs.docker.com/compose/reference/config/)

Valida el fichero de configuración `docker-compose.yml` y lo muestra por la consola

notes:

Una de las opciones que permite el comando `docker-compose config` es
obtener el hash de configuración de un servicio:

```bash
wordpress-compose > docker-compose config --hash="wordpress"
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

#### Command Line Interface: [`docker-compose kill`](https://docs.docker.com/compose/reference/kill/)

Permite enviar una señal IPC a un contenedor

```bash
wordpress-compose > docker-compose kill -s SIGTERM wordpress
```

notes:

```bash
Usage: kill [options] [SERVICE...]

Options:
    -s SIGNAL         SIGNAL to send to the container.
                      Default signal is SIGKILL.
```

[POSIX Signals](https://en.wikipedia.org/wiki/Signal_(IPC)#POSIX_signals)


^^^^^^

#### Command Line Interface: [`docker-compose logs`](https://docs.docker.com/compose/reference/logs/)

Muestra los logs de un servicio

```bash
wordpress-compose > docker-compose logs -f db
```

^^^^^^

#### Command Line Interface: [`docker-compose ps`](https://docs.docker.com/compose/reference/ps/)

Muestra los contenedores en ejecución

```bash
wordpress-compose > docker-compose ps

        Name                       Command               State          Ports
_____________________________________________________________________________________
wordpress_db_1          docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
wordpress_wordpress_1   docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp
```

^^^^^^

#### Command Line Interface: [`docker-compose pull`](https://docs.docker.com/compose/reference/pull/)

Se descarga la imagen asociada a un servicio

```bash
wordpress-compose > docker-compose pull wordpress
```

^^^^^^

#### Command Line Interface: [`docker-compose start`](https://docs.docker.com/compose/reference/start/) / [`stop`](https://docs.docker.com/compose/reference/stop/) / [`restart`](https://docs.docker.com/compose/reference/restart/)

Estos tres comandos sirven para parar, iniciar o reiniciar cualquiera de los servicios
definidos en el fichero `docker-compose.yml`

```bash
wordpress-compose > docker-compose restart wordpress
```

⚠️ Nota importante: las modificaciones realizadas sobre el fichero
`docker-compose.yml` no se reflejarán ejecutando `restart` o 
`stop -> start`


^^^^^^
#### Command Line Interface: [`docker-compose run`](https://docs.docker.com/compose/reference/run/)

Ejecuta un comando utilizando un contenedor definido en uno de los servicios

```bash
wordpress-compose > docker-compose run wordpress bash
```

```bash
docker-compose ps
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

* `wordpress_wordpress_1` que se levantó con `docker-compose up`
* `wordpress_wordpress_run_e433c908717e` que es el que levantamos con 
  `docker-compose run`

Además, como vemos en la diapositiva también **el comando `docker-compose run`**
no hace port-binding de los puertos definidos en el fichero `docker-compose.yml`.
Esto se hace así para evitar errores por que los puertos ya puedan estar ocupados,
como es el caso en el ejemplo que nos ocupa en esta diaposisitiva.

Si queremos que se los puertos asociados al servicio se creen, podemos usar la
opción `--service-ports` o la opción `-p` si queremos hacerlo de forma manual:

```bash
wordpress-compose > docker-compose run --service-ports wordpress bash
```

Si el servicio que queremos levanta depende de otros servicios, el comando
run verifica que estos servicios estén levantados (levantándolos si no lo están) 
antes de ejecutar el comando.