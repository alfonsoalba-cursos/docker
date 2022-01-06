### Importar y exportar imágenes

Los comandos para importar y exportar imágenes son

* [`docker container export`](https://docs.docker.com/engine/reference/commandline/container_export/) y [`docker export`](https://docs.docker.com/engine/reference/commandline/export/)
* [`docker import`](https://docs.docker.com/engine/reference/commandline/import/)


^^^^^^

 ### Exportación

`docker container export` exporta el contenido completo de un contenedor a un fichero `.tar`

```bash
> docker create modulo3 kubernetescourse/slides-docker
> docker container export modulo3 > backup_modulo3.tar
```

^^^^^^

### Importación 

`docker import` importa un fichero `.tar`y crear una imagen de docker a partir de él:

Importamos la imagen anterior:

```bash
$ docker import backup_modulo3.tar kubernetescourse/slides-docker:restored
sha256:c51570a0b2d342d6f57047e51c556703314ec31578656892e747ee2173c46ffb

$ docker image ls
REPOSITORY                                  TAG               IMAGE ID       CREATED              SIZE
kubernetescourse/slides-docker              restored          c51570a0b2d3   About a minute ago   151MB
```

^^^^^^

### Importación 

Intentamos levantar un contenedor con la imagen que acabamos de importar:

```shell
$ docker container run --rm -p "8079:80" kubernetescourse/slides-docker:restored
docker: Error response from daemon: No command specified.
See 'docker run --help'.
```

^^^^^^
### Importación 

¿Porqué no podemos levantar la imagen?

...si inspeccionamos ambas imágenes

```bash
$ docker image inspect -f '{{.Config.Cmd}}' kubernetescourse/slides-docker:restored
[]
$ docker image inspect -f '{{.Config.Cmd}}' kubernetescourse/slides-docker:latest
[nginx -g daemon off;]
```

^^^^^^
### Importación 

Al exportar el contenedor perdemos parte de la información de la imagen que se utilizó para levantarlo

**Sólo exportamos el contenido del contenedor**

^^^^^^
### 💻 Ejercicio 💻

¿Qué comando tendríamos que ejecutar para levantar un contenedor a partir de nuestro backup?

notes:

La respuesta es

```bash
docker run -p '10003:80' \ 
       --name modulo3_restored \ 
       kubernetescourse/slides-docker:restored nginx -g "daemon off;"
```

^^^^^^

### ¿Para qué se usa?

* Hacer backup del contenido de los contenedores
* Es una de las formas más sencillas de mover contenedores de un lugar a otro