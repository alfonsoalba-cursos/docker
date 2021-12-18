### Listar y borrar imágenes

^^^^^^

### Listar imágenes

En lo que llevamos de curso hemos levantado ya varios contenedores...

¿Cómo podemos ver las imágenes?<br>Usando el comando [`docker image ls`](https://docs.docker.com/engine/reference/commandline/image_ls/)


^^^^^^

### 💻 Práctica 💻

Muestra las imágenes que tienes instaladas en tu sistema

```bash
> docker image ls
```

^^^^^^

### Borrar imágenes

[`docker image rm`](https://docs.docker.com/engine/reference/commandline/image_rm/)

^^^^^^

### 💻 Ejericio 💻

Vamos a borrar la imagen de ruby, que utilizamos en el último ejercicio del módulo 2

```bash
> docker image rm ruby
```

¿Qué pasaría si ahora intentamos de nuevo ejecutar el script de ruby?

notes:

Si borramos la imagen e intentamos ejecutar de nuevo el script:

```bash
> docker run --rm ruby:latest ruby -e 'puts "Bienvenido a Ruby #{RUBY_VERSION}"'
```

Lo primero que hará docker será descargarse la imagen:
```bash
> docker run --rm ruby:2.6.3 ruby -e 'puts "Bienvenido a Ruby #{RUBY_VERSION}"'
Unable to find image 'ruby:latest' locally
latest: Pulling from library/ruby
Digest: sha256:358f16e92d0f66599103318f7a8528d449b0973fd89e46a1a5c47cec7479f09b
Status: Downloaded newer image for ruby::latest
Bienvenido a Ruby 2.6.3
```

⚠️¡Cuidado! Si desde que descargaste la imagen e hiciste el ejercicio de módulo 2 hasta ahora, se ha actualizado la 
imagen de ruby en docker, **el resultado del ejercicio habrá cambiado**.