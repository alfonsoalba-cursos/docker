### Consolidar (commit) cambios

El comando **[`docker commit`]()** genera una imagen nueva a partir de los cambios generados en el sistema de ficheros
del contenedor

```bash
docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
```

^^^^^^

### 💻 Práctica 💻

Utilizando el comando commit, generar una nueva imagen que contenta vuestro nombre en el siguiente cuadro

```bash
[TU NOMBRE AQUÍ... O LO QUE QUIERAS]
```

^^^^^^

#### 💻 Práctica (cont.) 💻

* Levantar un contenedor a partir de la imagen de las diapositivas:

```bash
> docker run --rm -p '8003:80' --name modulo3 -d kubernetescourse/slides-docker
```

* Abrir una shell en el contenedor recién levantado

```bash
> docker exec -ti modulo3 sh
```

* Edita el fichero 

```bash
> vi slides/commit-changes-md
```

notes: 

La opción `-d` levanta el contenedor en segundo plano.

^^^^^^

#### 💻 Práctica (cont.) 💻

* Guardar los cambios en una image nueva:

```bash
docker commit modulo3 alfonso:1.0.0
```

* Levanta un contenedor que use la nueva imagen y verifica que se ha cambiado la diapositiva

```bash
> docker run --rm -p '10003:80' --name alfonso alfonso:1.0.0
```

* Verificar que los cambios se han guardado en la nueva imagen con un navegador
* Borrar la imagen

```bash 
> docker image rm alfonso:1.0.0
```

^^^^^^

### Consolidar (commit) cambios

La opción `--change` permite crear la nueva imagen añadiendo algunos nuevas instrucciones de  `Dockerfile`

```bash
docker commit --change='CMD ["nginx", ... ]' modulo3 alfonso:1.0.0
```

notes:

Este comando crea una nueva imagen en la que el contenedor levanta la aplicación node en el puerto 12345.

Para verificarlo:

* `docker commit --change='CMD ["nginx","-g","daemon off; listen 79;"]' modulo3 alfonso:1.0.0`
* Al intentar levantar un contenedor con la image, obtendremos un error:

```shell
$ docker commit --change='CMD ["nginx","-g","daemon off; listen 79;"]' modulo3 alfonso:1.0.0
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: IPv6 listen already enabled
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/01/06 15:38:04 [emerg] 1#1: "listen" directive is not allowed here in command line
nginx: [emerg] "listen" directive is not allowed here in command line
```

^^^^^^

### Consolidar (commit) cambios

Aunque esta es una manera rápida y sencilla de crear imágenes, **la manera recomendada de hacerlo es usar un Dockerfile**
como estudiaremos en detalle en el siguiente módulo.
