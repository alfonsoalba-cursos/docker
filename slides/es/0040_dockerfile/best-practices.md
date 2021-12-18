### Buenas prácticas 👍

notes:

Docker [dispone de una página en su documentación] en la que nos da una serie
de pautas y buenas prácticas para crear imágenes.

Revisaremos en las siguientes diapositivas los consejos más importantes.

^^^^^^

##### Buenas prácticas 👍 

_Create ephemeral containers_

Diseña tus contenedores para que estos puedan levantarse, pararse, borrarse
y volverse a crear, es decir

 **no almacenes estado en los contenedores**

notes:

...de esto ya hemos hablado en los módulos anteriores.

^^^^^^

##### Buenas prácticas 👍 

_Understand build context_

El contexto es la carpeta dentro de la que se ejecuta el comando `docker build`

**TODO el contenido de esta carpeta se envía recursivamente a `dockerd` para construir
este _build context_**

Si se envían más ficheros de los necesarios podemos acabar con una imagen más grande
de la que realmente necesitamos


notes:

Cuando construimos una image, un mensaje parecido al siguiente nos indicará
el tamaño del _build context_

```
Sending build context to Docker daemon  563.53MB
```

El fichero `Dockerfile` no tiene por qué estar dentro del _build context_
puede estar en otra carpeta fuera y utilizar la opción `-f` para referenciarlo. En
la siguiente diapositiva veremos un ejemplo.

^^^^^^

##### Buenas prácticas 👍 

_Understand build context_

![Ejemplo de contexto](images/context-example.png)

Con una estructura de carpetas como esta, el comando para construir nuestra imagen
sería:

```bash
> docker build -f Dockerfile context
```

^^^^^^

##### Buenas prácticas 👍 

_Exclude with .dockerignore_

A imagen y semejanza del fichero `.gitignore`, el comando `docker build` utiliza
el fichero `.dockerignore` para excluir ficheros y carpetas del _build _context_

[Información detallada sobre `.dockerignore`](https://docs.docker.com/engine/reference/builder/#dockerignore-file)

^^^^^^
##### Buenas prácticas 👍 

_Use multi-stage builds_

```Dockerfile
#### PRIMER PASO DE LA GENERACIÓN DE LA IMAGEN
FROM golang:1.11-alpine AS build

# Install tools required for project
RUN apk add --no-cache git
RUN go get github.com/golang/dep/cmd/dep

# List project dependencies with Gopkg.toml and Gopkg.lock
# These layers are only re-built when Gopkg files are updated
COPY Gopkg.lock Gopkg.toml /go/src/project/
WORKDIR /go/src/project/
# Install library dependencies
RUN dep ensure -vendor-only

# Copy the entire project and build it
COPY . /go/src/project/
RUN go build -o /bin/project

#### SEGUNDO PASO DE LA GENERACIÓN DE LA IMAGEN
# This results in a single layer image
FROM scratch
COPY --from=build /bin/project /bin/project
ENTRYPOINT ["/bin/project"]
CMD ["--help"]
```

[Documentación](https://docs.docker.com/develop/develop-images/multistage-build/)

notes:

Aunque no entraremos en mucho detalle sobre este tema por limitaciones de tiempo
y temario, **eso no quiere decir
que no sea importante**. Es una de las herramientas más potentes que tiene 
docker para reducir el tamaño de la imagen.

Usaremos el propio ejemplo que nos da la documentación de docker en la [página de
buenas prácticas](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#use-multi-stage-builds).

En el ejemplo se construye una imagen para una aplicación en Go.

* Partiendo de una imagen de alpine, instalamos todo lo que necesitamos para
  crear nuestro ejecutable en go.

* Una vez lo hemos creado, la imagen anterior (que llamamos `build`) y que contiene
  el ejecutable compilado a partir de go, se utiliza para copiar sólo ese 
  fichero a la imagen final (`FROM scratch`)


^^^^^^

##### Buenas prácticas 👍 

_Don’t install unnecessary packages_

^^^^^^

##### Buenas prácticas 👍 

_Minimize the number of layers_

Ten en cuenta que sólo los comandos `RUN`, `COPY` y `ADD` crean nuevas capas.

El resto de instrucciones sólo crean imágenes intermedias y **no afectan
al tamaño final de la imagen**

^^^^^^

##### Buenas prácticas 👍 

_Minimize the number of layers_

* Combina múltiples instrucciones `RUN` consecutivas en un unica instrucción
* Usa _multi-stage builds_ siempre que sea posible

