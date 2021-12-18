### Dockerfile

En el módulo de imágenes, vimos como crear imágenes por distintos métodos:
* `docker commit`
* Exportando e importando un contenedor
* Con los comandos `docker image save` y `docker image load`

**Sin embargo, el método recomendado para crear imágenes es a través del comando
`docker build` y el fichero `Dockerfile`**

^^^^^^

### 💻️Práctica💻 ️

Vamos a crear nuestra primera imagen

* Crea una carpeta vacía `mi_web`
* Crea un fichero `Dockerfile` con el siguiente contenido

```Dockerfile
# Version: 0.0.1
FROM ubuntu:18.04
LABEL maintainer="hola@becorecode.com"
RUN apt-get update; apt-get install -y nginx
RUN echo '¡Hola! Soy el contenedor de Alfonso' \
    >/var/www/html/index.html
EXPOSE 80
```

notes:

El fichero `Dockerfile` contiene una serie de instrucciones con sus argumentos.

Las instrucciones deben aparecer en mayúsculas y seguidas de su correspondiente argumento.

Cada instrucción añade una nueva capa a la imagen y hace un commit de la misma: Este 
es el flujo que se sigue para generar la imagen:

1. Docker corre un contenedor sobre la imagen del paso anterior. **Es por ello que 
  la primera instrucción debe ser siempre `FROM`
1. La instrucción se ejecuta y se modifica el contenedor
1. Docker ejecuta algo equivalente al comando `docker commit` que vimos en el módulo 3 para
  hacer commit de los cambios a una nueva capa
1. Volvemos al paso 1, en el que Docker corre un nuevo contenedor sobre esta última capa

Si se produce un fallo (por que alguna instrucción da error) dispones de la última imagen
en tu sistema. **Esto es especialmente útil para depurar** ya que puedes ejecutar un contenedor
sobre esta imagen y depurar qué es lo que ha podido fallar.

^^^^^^

### 💻️Práctica 💻️

* Construimos la imagen

```
> docker build -t="alfonso/static_web:v1" .
```

notes:

La opción `-t` añade un tag a la imagen. Si no es pone ningún tagname (en nuestro caso
`:v1`) docker utilizará `:latest` por defecto.

Como véis, estamos ya poniendo el repositorio de Docker Hub donde vamos a subir la imagen.
Recordad cómo subimos las imágenes a Docker Hub en el módulo 3 usando el comando

```bash
> docker push [repository]/[name]:[tag]
```

^^^^^^

#### 💻️ Práctica (cont.) 💻️

* Levantamos la imagen

```bash
> docker run -d -p '8080:80' --name static_web alfonso/static_web:v1 nginx -g "daemon off;"
```

Pregunta ¿porqué usamos la opción daemon off de nginx?

notes:

Porque necesitamos que nginx se ejecute en primer plano y sea el proceso 1 del contenedor.

^^^^^^

### Dockerfile

* [`LABEL maintainer="hola@becorecode.com"`](https://docs.docker.com/engine/reference/builder/#label) es el sustituto a la antigua instrucción 
  [`MAINTAINER`](https://docs.docker.com/engine/reference/builder/#maintainer) 
  Damos información sobre cómo contactar con nosotros por email
* [`RUN apt-get update; apt-get install -y nginx`](https://docs.docker.com/engine/reference/builder/#run) 
  Instalamos nginx
* [`RUN echo '¡Hola! Soy el contenedor de Alfonso' >/var/www/html/index.html`]((https://docs.docker.com/engine/reference/builder/#run)) Contenido de la web
* [`EXPOSE 80`](https://docs.docker.com/engine/reference/builder/#expose) Exponemos el puerto 80

notes:

* La instrucción LABEL nos permite añadir metadatos a las imágenes. Estos
  metadatos podemos luego usarlos para buscar imágenes

```bash
> docker image ls -f 'label=maintainer=hola@becorecode.com'
```

* La instrucción RUN hace lo siguiente:
  * ejecuta el comando que se pasa como argumento en una nueva capa sobre la última imagen
  * hace commit de una nueva imagen
* La instrucción `EXPOSE`, como se indica en la documentación, añade al Dockerfile
  información sobre qué puertos son utilizados por los contenedores pero no hace nada
  más, no abre realmente el puerto ni abre ningún socket. Se usa a modo de documentación.
  Tened en cuenta que el puerto por el que se accede al contenedor desde el host
  se puede sobreescribir con la opción `-p`. Además, como veremos cuando hablemos
  de las redes, los contenedores que estén la misma red no tienen limitación
  para comunicarse entre sí: pueden hacerlo por cualquier puerto.

    

