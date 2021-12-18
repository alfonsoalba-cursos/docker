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

* Levantar un contenedor a partir de la imagen del módulo 3

```bash
> docker run --rm -p '8003:8003' --name modulo3 -d becorecode/curso-intro-docker-modulo-3
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
> docker run --rm -p '10003:8003' --name alfonso alfonso:1.0.0
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
docker commit --change='CMD ["npm", "start", "--", "--port=12345"]' modulo3 alfonso:1.0.0
```

notes:

Este comando crea una nueva imagen en la que el contenedor levanta la aplicación node en el puerto 12345.

Para verificarlo:

* `docker run --rm -p '12345:12345' --name alfonso alfonso:1.0.0`
* Acceder con el navegador al puerto 12345

^^^^^^

### Consolidar (commit) cambios

Aunque esta es una manera rápida y sencilla de crear imágenes, **la manera recomendada de hacerlo es usar un Dockerfile**
como estudiaremos en detalle en el siguiente módulo.
