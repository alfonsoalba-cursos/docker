### Buscar imágenes

El comando para buscar imágenes es [`docker search`](https://docs.docker.com/engine/reference/commandline/search/)

```bash
docker search kubernetescourse
```

Este comando busca por defecto en [Docker Hub](https://hub.docker.com)

^^^^^^

### Buscar imágenes

* Filtros que se pueden aplicar
  * `starts`
  * `is-automated`
  * `is-official`

^^^^^^

### 💻 Práctica 💻

* Vamos a buscar imágenes oficiales que contengan la cadena _debian_

```bash
> docker search --filter is-official=true debian
```

* Se pueden aplicar varios filtros
```bash
> docker search --filter is-official=false --filter is-automated=true debian
```

^^^^^^

### ¿Qué es una imagen `is-automated=true`?

Una imagen que está conectada a un repositorio y que se construye automáticamente en base a unas reglas

^^^^^^

### Buscar imágenes instaladas

Si lo que queremos el buscar imágenes entre las que tenemos instaladas, el comando es
[docker image ls](https://docs.docker.com/engine/reference/commandline/images/)
<br>(alias del comando `docker images`)

```bash
> docker image ls [OPCIONES] [REPOSITORIO[:TAG]]
```

^^^^^^

### 💻 Práctica 💻

Listar todas las imágenes que tenemos instaladas de `kubernetescourse`

```bash
> docker image ls "kubernetescourses/*"
```

^^^^^^

### Buscar imágenes instaladas

* Filtros que acepta el comando `docker image ls --filter`:
  * `dangling` (true or false) Imagen sin etiqueta
  * `label` (label=\<key\> o label=\<key\>=\<value\>)
  * `before` (\<image-name\>[:\<tag\>], \<image id\> or <image@digest>) imágenes creadas antes de la imagen con id o referencia
  * `since` (\<image-name\>[:\<tag\>], \<image id\> or <image@digest>) imágenes creadas después de la imagen con id o referencia
  * `reference` (patrón o referencia) imágenes cuyo tag cumple el patrón o tiene el tag indicado


^^^^^^

### 💻 Ejemplos 💻

* Mostrar todas las imágenes con el tag `latest`

```bash
> docker image ls --filter 'reference=*:latest'
```

* Mostrar las imágenes con el tag `latest` dentro de `kubernetescourse`
```bash
> docker image ls --filter 'reference=kubernetescourse/*:latest'
```

notes:

Aparte del uso de `--filter` para filtrar, siempre tenéis la opción de utilizar tuberías (pipes) del sistema operativo
y apollaros en comandos como `grep`: 

```bash
> docker image ls | grep kubernetescourse |grep latest
```

