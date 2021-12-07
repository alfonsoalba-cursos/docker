### Copiando ficheros

* Docker nos permite copiar ficheros entre el contenedor y el host
* Para ello disponemos del comando [`docker container cp`](https://docs.docker.com/engine/reference/commandline/container_cp/)

^^^^^^

### 💻 Práctica 💻

* Vamos a extraer la carpeta `slides/` del contenedor y a copiarla en nuestro sistema de ficheros local

```bash
> mkdir tmp/
> docker container cp [CONTAINER_ID OR NAME]:/home/node/slides/ tmp/
```

* Se creará la carpeta tmp/slides/ con una copia de las diapositivas en markdown que están en el contenedor

^^^^^^

### 💻 Ejercicio 💻

Usando `docker container cp`, realiza cualquier modificación en las diapositivas, súbelas al contenedor y
disfruta de ellas en el contenedor

Tip: [Markdown syntax](https://www.markdownguide.org/basic-syntax/)

notes:

Para hacer esta operación el contenedor **NO** tiene que estar levantado, sólo tiene que existir. Haremos la práctica 
suponiendo que no lo está. Si en tu caso lo tienes levantado, utiliza el comando `docker container stop` para pararlo.

Editamos la diapositiva `slides/toc.md` y añadimos un texto al principio de la diapositiva. A continuación copiamos el fichero:

```bash
> docker container cp tmp/slides/toc.md [CONTAINER_ID OR NAME]:/home/node/slides/toc.md
```

Levantar el contenedor:

```bash
> docker run --rm -p "8002:8002" --name modulo2 becorecode/curso-intro-docker-modulo-2
```

Abrir el navegador y confirmar que nuestros cambios se ven en las diapositivas.

^^^^^^

* Es posible generar un tar usando la opción `-`

```bash
> docker container cp [CONTAINER_ID OR NAME]:/home/node/slides/ - | tar tf -
```