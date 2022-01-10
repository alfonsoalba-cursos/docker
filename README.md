# Material curso de Docker

Este repositorio contiene el material para el curso de Docker.

## Diapositivas

Puedes ver las diapositivas de las siguientes maneras:

### Descargando los PDFs

### Viendo la versión online

[https://docker-course.alfonsoalba.com/slides/index.html](https://docker-course.alfonsoalba.com/slides/index.html)
### Abriendo los ficheros html

Clona el repositorio en tu máquina, utiliza el navegador de archivos de tu sistema operativo
para llegar a los ficheros html que están en la carpeta `slides`. Abrelos con tu navegador favorito.

Este método, aunque sencillo, no te permitirá ver las notas del ponente.

### Servidor web local

Para poder levantar un servidor web necesitarás tener instalado docker en tu máquina.

Clona el repositorio:

```bash
> git clone git@github.com:alfonsoalba-cursos/docker.git
> cd docker
```

Levanta el servidor web:

```bash
docker> docker compose up -d slides
```

Apunta tu navegador a `http://localhost:8081`. Deberías tener acceso ya a las diapositivas.

Cuando acabes, detén el servidor web y borra el contenedor ejecutando el comando:

```bash
docker> docker compose down slides
```


## Laboratorios

Puedes acceder al índice de laboratorios en [este enlace](labs/README_es.md). La documentación para cada uno de ellos
la encontarás en la carpeta correspondiente.