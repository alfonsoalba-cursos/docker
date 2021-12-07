### Listar contenedores

```bash 
> docker ps


CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS         PORTS                  NAMES
e209a5b9818f   node:10-alpine  "docker-entrypoint.s…"   18 minutes ago   Up 18 minutes  0.0.0.0:8002->8000/tcp module2
```

^^^^^^

* `docker ps` muestra por defecto los contenedores que se están ejecutando.
* Si quieres ver los contenedores que están parados y los que se están ejecutando utiliza la opción `-a` o `--all`

```bash
> docker ps -a
```

^^^^^^

### 💻 Práctica 💻

* Ejecuta `docker ps` en tu máquina. No deberías tener ningún contenedor en ejecución
* Ejecuta `docker ps -a`. Deberías ver los dos contenedores que hemos ejecutado hasta el momento:
  * `hello-world` en el módulo 1 del curso durante la instalación
  * `becorecode/curso-intro-docker-modulo-2` que hemos creado al iniciar el módulo 2

notes:

Si al llegar a este punto, no has parado ninguno de los dos contenedores que hemos levantado en la máquina,
el comando `docker ps` te los mostrará.

^^^^^^

### Listar contenedores

Comando alternativo:

```bash 
> docker container ls -a
```

notes:

¿Porqué hay dos comando para hacer esto? En la versión 1.13 de docker se llevó a cabo una reestructuración de los comandos.
Puedes ver el post oficial de docker al respecto [aquí](https://www.docker.com/blog/whats-new-in-docker-1-13/).

El objetivo de esta reesctructuración es que los comandos indiquen el tipo de objeto de docker sobre el que actúan.
Así `docker container ls`  es más claro y explícito que `docker ps`

Siguiendo la recomendación que hacen en el blog, nosotros usaremos la nueva nomenclatura.

^^^^^^

### 💻 Práctica 💻

* Vuelve a levantar el contenedor de las diapositivas como se indicó en la sección anterior
  ```bash
    docker run --rm becorecode/curso-intro-docker-modulo-2
  ```
* Abre una nueva consola y ejecuta `docker container ls`. Deberías ver el contenedor en el listado.
* Vuelve a la consola y para el contenedor pulsando CTRL+c o CMD+c
* Ejecuta `docker container ls -a`. No debería aparecer ningún contenedor.

^^^^^^

### 💻 Ejercicio 💻

* Levanta de nuevo el contenedor de las diapositivas **pero esta vez sin la opción `--rm`**
  ```bash
    docker run becorecode/curso-intro-docker-modulo-2
  ```
* Páralo con CTRL+c o CMD+c
* Levántalo y páralo dos o tres veces más
* Ejecuta `docker container ls` primero y luego `docker container ls -a` 
  
  🤯 ¿qué está pasando?

notes:

Lo que está pasando es que `docker container ls` muestra los contenedores en ejecución mientras 
que el comando `docker container ls -a` muestra todos los contenedores.

Cuando un contenedor se está ejecutando y lo paramos con CTLR+c o CMD+c **este se detiene, pero no se borra.**

Veremos [más adelante dentro de este módulo](#/stop-start-and-remove-containers) cómo borrar todos esos contenedores de más que hemos creado.









