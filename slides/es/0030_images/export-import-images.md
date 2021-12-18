### Importar y exportar imágenes

Los comandos para importar y exportar imágenes son

* [`docker container export`](https://docs.docker.com/engine/reference/commandline/container_export/) y [`docker export`](https://docs.docker.com/engine/reference/commandline/export/)
* [`docker import`](https://docs.docker.com/engine/reference/commandline/import/)


^^^^^^

 ### Exportación

`docker container export` exporta el contenido completo de un contenedor a un fichero `.tar`

```bash
> docker create modulo3 becorecode/curso-intro-docker-modulo-3
> docker container export modulo3 > backup_modulo3.tar
```

^^^^^^

### Importación 

`docker import` importa un fichero `.tar`y crear una imagen de docker a partir de él:

Si intentamos importar la imagen anterior:

```bash
> docker import backup_modulo3.tar becorecode/curso-intro-docker-modulo-3:restored
> docker run --rm becorecode/curso-intro-docker-modulo-3:restored
docker: Error response from daemon: No command specified.
See 'docker run --help'
```

^^^^^^
### Importación 

¿Porqué no podemos levantar la imagen?

...si inspeccionamos ambas imágenes

```bash
> docker image inspect -f '{{.ContainerConfig.Cmd}}' becorecode/curso-intro-docker-modulo-3:restored
[]

> docker image inspect -f '{{.ContainerConfig.Cmd}}' becorecode/curso-intro-docker-modulo-3:latest
[/bin/sh -c #(nop)  CMD ["npm" "start" "--" "--port=${APP_PORT}"]]
```

^^^^^^
### Importación 

Al exportar el contenedor perdemos parte de la información de la imagen que se utilizó para levantarlo

**Sólo exportamos el contenido
del contenedor**

^^^^^^
### 💻 Ejercicio 💻

¿Qué comando tendríamos que ejecutar para levantar un contenedor a partir de nuestro backup?

notes:

La respuesta es

```bash
docker run -p '10003:8003' \ 
       --name modulo3_restored \ 
       --user node \
       -w '/home/node' \
       becorecode/curso-intro-docker-modulo-3:restored npm start -- --port=8003
```

^^^^^^

### ¿Para qué se usa?

* Hacer backup del contenido de los contenedores
* Es una de las formas más sencillas de mover contenedores de un lugar a otro