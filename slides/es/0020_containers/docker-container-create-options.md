### ¿y cómo veo las diapositivas?

Para poder ver las diapositivas necesitamos utilizar la opción `-p` del comando

```bash
> docker container create --rm -p "8002:8002" becorecode/curso-intro-docker-modulo-2
THE_CONTAINER_ID

> docker container start THE_CONTAINER_ID
```

🤯

^^^^^^

### 💻 Ejercicio 💻

El comando `docker container start` deja el contenedor ejecutándose y nos devuelve a la consola.

Antes de hacer el ejercicio, vamos a detener el contenedor usando: 
```bash
> docker container stop THE_CONTAINER_ID
```
* usando el comando `docker run`, levanta de nuevo el contenedor.
* Si no tienes acceso al ID del contenedor ¿cómo lo conseguirías?

notes:

Para levantar el contenedor usando `docker run`:

```bash
> docker run --rm -p "8002:8002" becorecode/curso-intro-docker-modulo-2
```

Para conseguir el ID del contenedor, usaríamos el comando `docker container ls`

^^^^^^

### ¿Qué hace la opción `-p`? 🤔

* Esta opción hace un _port forwarding_ entre un puerto del host y un puerto del contenedor
* En el ejemplo que nos ocupa, usamos la opción `-p "8002:8002"`. 
* Eso significa que podremos acceder al puerto 8002 del contenedor usando el puerto 8002 del host
* Para ver las diapositivas, en este caso usaríamos un navegador apuntando a la URL `localhost:8002`

^^^^^^


### ¿Qué hace la opción `-p`? 🤔

* Si usasemos `-p "4444:8002"` entonces tendríamos que apuntar el navegador a `localhost:4444`
* Veremos esto con más detalle en el módulo de red
