### Caché

El proceso de construcción de imágenes utiliza una caché para evitar construir
capas innecesariamente.

^^^^^^

### La caché en acción

Vamos a contruir de nuevo nuestra primera imagen sin utilizar la caché:

```shell
time docker build -t 'kubernetescourse/our-first-image:v1' --no-cache --progress=plain .
#1 [internal] load build definition from Dockerfile
#1 sha256:ee59825c833344024c1a0b1894a5dcce921d38f07c8cee6f9aac67c14d5a8565
#1 transferring dockerfile: 38B done
#1 DONE 0.0s

....

#9 [1/3] FROM docker.io/library/ubuntu:latest
#9 sha256:0a5f349eacf4edfd2fc1577c637ef52a2ed3280d9d5c0ab7f2e4c4052e7d6c9f
#9 CACHED

#10 [2/3] RUN apt-get update; apt-get install -y nginx
#10 sha256:c8cad4d288d011b1f818aa1f38d385e4c19cc3301f61900ba9d0062481229858
#10 0.586 Get:1 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
....
#10 25.76 Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
#10 DONE 26.0s

#11 [3/3] RUN echo '¡Hola! Soy el contenedor de Alfonso'     >/var/www/html/index.html
#11 sha256:6a2e1a08fa09b77ce2ede73e28fb90ed9821f1084245c2e6f5daaeb9e27b1604
#11 DONE 0.5s

#12 exporting to image
#12 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
#12 exporting layers
#12 exporting layers 0.4s done
#12 writing image sha256:edb11d2240fb8e3b2da32f0312f665d84a3f10e78fa55c78a16987b0ce6eb214
#12 writing image sha256:edb11d2240fb8e3b2da32f0312f665d84a3f10e78fa55c78a16987b0ce6eb214 done
#12 naming to docker.io/kubernetescourse/our-first-image:v1 done
#12 DONE 0.5s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them   

real    0m30.005s
user    0m0.267s
sys     0m0.160s
```

Tiempo de ejecución: unos 30 segundos

^^^^^^

### La caché en acción

La construimos de nuevo, en esta ocasión usando la caché:

```shell [36,38, 40,42,53-55]
time docker build -t 'kubernetescourse/our-first-image:v1' --progress=plain .
#1 [internal] load build definition from Dockerfile
#1 sha256:1b5946140f84e8af84eb1d5f475d1d4a1678b41c000473d86d826e034c4bae74
#1 transferring dockerfile: 38B done
#1 DONE 0.0s

#2 [internal] load .dockerignore
#2 sha256:b508e10225e366c75c49a70979d20c1d6244795c192a13f87e66d4d8d63845ac
#2 transferring context: 2B done
#2 DONE 0.0s

#3 resolve image config for docker.io/docker/dockerfile:1
#3 sha256:ac072d521901222eeef550f52282877f196e16b0247844be9ceb1ccc1eac391d
#3 DONE 0.7s

#4 docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1357b3b2
#4 sha256:e7000a2113ce0d8d3e5eb20bd235706bb1408cc39fef67c756c938ffe32b6067
#4 CACHED

#5 [internal] load .dockerignore
#5 sha256:12c1ca5515c0064126e62bfb996fb2dba6e3687b0b10d1cd4dfffb395a255287
#5 DONE 0.0s

#6 [internal] load build definition from Dockerfile
#6 sha256:9e289f4a839ed32ff47e6c7a0a6fd0ece32570b3402a144c4529a30838a67456
#6 DONE 0.0s

#7 [internal] load metadata for docker.io/library/ubuntu:latest
#7 sha256:8c6bdfb121a69744f11ffa1fedfc68ec20085c2dcce567aac97a3ff72e53502d
#7 DONE 0.0s

#10 [1/3] FROM docker.io/library/ubuntu:latest
#10 sha256:0a5f349eacf4edfd2fc1577c637ef52a2ed3280d9d5c0ab7f2e4c4052e7d6c9f
#10 DONE 0.0s

#8 [2/3] RUN apt-get update; apt-get install -y nginx
#8 sha256:c8cad4d288d011b1f818aa1f38d385e4c19cc3301f61900ba9d0062481229858
#8 CACHED

#9 [3/3] RUN echo '¡Hola! Soy el contenedor de Alfonso'     >/var/www/html/index.html
#9 sha256:6a2e1a08fa09b77ce2ede73e28fb90ed9821f1084245c2e6f5daaeb9e27b1604
#9 CACHED

#11 exporting to image
#11 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
#11 exporting layers done
#11 writing image sha256:edb11d2240fb8e3b2da32f0312f665d84a3f10e78fa55c78a16987b0ce6eb214 done
#11 naming to docker.io/kubernetescourse/our-first-image:v1 done
#11 DONE 0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them   

real    0m1.328s
user    0m0.105s
sys     0m0.096s
```

Tiempo de ejecución: poco más de 1 segundo

😎

^^^^^^

### Caché

¿Como se construye una imagen a partir de un `Dockerfile`?

* Selecciona la siguiente instrucción a ejecutar
* Crea una imagen con todas las capas anteriores
* Con esa imagen, crea un contenedor y ejecuta la instrucción dentro de ese contenedor
* Extrae la _thin layer_ que se ha generado y genera una caché: la instrucción que se ha ejecutado
  y los cambios en el sistema de ficheros que han tenido lugar
* Guarda la capa y la caché
* Pasa a la siguiente instrucción  

notes:

El proceso aquí descrito se corresponde con cómo se construian las imágenes antes
de BuilKit.

En BuildKit, el proceso se ha optimizado y **no es necesario generar las imágenes
intermedias aunque sigue siendo cierto que utiliza contenedores para generar las capas** 

Se mantiene en las diapositivas el procedimiento antiguo únicamente por motivos pedagógicos:
es un proceso más simple y por lo tanto más facil de entender.

^^^^^^

### Caché

¿Cómo se utiliza la caché entonces?

* Selecciona la siguiente instrucción a ejecutar
* **Compara la nueva instrucción a ejecutar con la caché almacenada para esa instrucción**
* **Si no hay cambios, utiliza la capa cacheada**
* Si hay cambios, invalida la caché y
  * Crea una imagen con todas las capas anteriores
  * Con esa imagen, crea un contenedor y ejecuta la instrucción dentro de ese contenedor
  * Extrae la _thin layer_ que se ha generado y genera una caché
* Pasa a la siguiente instrucción  

^^^^^^

### Caché 

Si la caché queda invalidada para una instrucción

**queda invalidada para todas las instrucciones posteriores** 

notes:

Este hecho es muy importante y queda se refleja en el diseño de todos los `Dockerfiles`.

Siempre se intenta poner aquellas instrucciones que invalidan la cache debajo
de aquellas que, o bien no lo hacen, o lo hacen con menos frecuencia.

Por ejemplo, la instrucción para copiar el código dentro de la imagen intentaremos
ponerla lo más abajo posible dentro del `Dockerfile`. Si la ponemos la primera, justo debajo del
`FROM`, basta con que cambiemos un sólo caracter en el código para que la cache quede invalidada
y todas las instrucciones posteriores se tengan que volver a ejecutar.

^^^^^^

### Caché

Más información:

* [Leverage build cache](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#leverage-build-cache)
* [DOCKER IMAGES AND THEIR LAYERS EXPLAINED](https://dominikbraun.io/blog/docker/docker-images-and-their-layers-explained/)

^^^^^^ 

### 💻 Lab. _Cache invalidation_

[Ir al taller](https://github.com/alfonsoalba-cursos/docker/tree/main/labs/0040-dockerfile-and-builkit/cache-invalidation)