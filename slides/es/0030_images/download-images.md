### Descarga de imágenes

El comando para descargar imágenes es `docker image pull` o `docker pull`

* [Documentación de `docker pull`](https://docs.docker.com/engine/reference/commandline/pull/)
* [Documentación de `docker image pull`](https://docs.docker.com/engine/reference/commandline/image_pull/)

^^^^^^

### 💻 Práctica 💻

* Descargar la imagen de alpine linux

```bash 
> docker image pull ubuntu
```

### Descarga de imágenes

El comando `pull` admite como opción la descarga de un tag en particular:

```bash
> docker image pull ubuntu:16.04
> docker image pull ubuntu:18.10
```

notes:

El  uso y definición de etiquetas se verá con más detalle en el módulo de creación de imágenes.
