### Levantar, parar y borrar contenedores

* Levantar:
  * [`docker container run`](https://docs.docker.com/engine/reference/commandline/container_run/) (crear y levantar)
  * [`docker container start`](https://docs.docker.com/engine/reference/commandline/container_start/)
* Parar un contenedor: [`docker container stop`](https://docs.docker.com/engine/reference/commandline/container_stop/)
* Borrar un contenedor: [`docker container rm`](https://docs.docker.com/engine/reference/commandline/container_rm/)

^^^^^^

### 💻 Ejercicio 💻

* Listar todos los contenedores que tenéis en vuestra máquina
* Borrarlos todos excepto el que estéis usando para ver las diapositivas
* ¿Se puede borrar un contenedor que se está ejecutando?

notes:

Desde que empezamos el curso hemos ejecutado varias veces el comando `docker run`.

Vamos a hacer un poco de limpieza:

```bash
> docker container ls -a
```

Buscar el nombre o el ID de los contenedores que nos sobran y una vez los tengamos:

```bash
> docker container rm [IDS O NOMBRES DE LOS CONTENEDORES]
```

La respuesta a la pregunta es que no, no se puede.

^^^^^^

### Otros comandos

* [`docker prune`](https://docs.docker.com/engine/reference/commandline/container_prune/): borra todos los contenedores que no se están ejecutando

notes:

El ejercicio anterior se podía haber hecho sencillamente ejecutando:

```bash
> docker container prune
```