### BuilKit _cache exporters_

¿Dónde se guarda la caché?

En el demonio `dockerd` que genera la imagen

^^^^^^

#### BuilKit _cache exporters_

¿Qué ocurre en entornos distribuidos?

Ejemplo: Jenkins levanta _workers_ para generar las imágenes

notes:

Nuestro sistema de integración contínua levanta máquinas para generar las imágenes.
Cuando estas máquinas se eliminan, la cache desaparece y la siguiente máquina que
se levante tendrá que volver a generar la caché.

Podemos pensar en utilizar un demonio docker centralizado para construir las imágenes
pero eso plantea problemas de rendimiento y escalabilidad... al final queremos que 
nuestra arquitectura para construir las imágenes pueda escalar horizontalmente.

^^^^^^

#### BuilKit _cache exporters_

Para resolver estos problemas se crearon los [_cache exporters_](https://github.com/moby/buildkit#export-cache)

Permiten subir al _registry_ las capas de la imagen y la caché

notes:

Si junto a las imágenes y sus capas, guardamos la caché en el registry, el
siguiente _worker_ que se cree en nuestro sistema de integración contínua
podrá bajarse la caché del _registry_ y el tiempo de generación de la imagen
se mantendrá constante.

^^^^^^

#### BuilKit _cache exporters_

* `inline`
* `registry`
* `local`
* `gha` (GitHub Actions)

^^^^^^

#### BuilKit _cache exporters_: `inline`

* Sube la cache junto a la imagen al _registry_
* Sólo sube las capas de la imagen final, no incluye las capas de las imagenes
  intermedias en un _multistage build_
* Uso: `docker build --build-arg BUILDKIT_INLINE_CACHE=1 ...`

^^^^^^

#### BuilKit _cache exporters_: `registry`

* Guarda la caché en el _registry_
* Guarda la caché y la imagen en lugares separados
* Permite guardar la caché de los pasos intermedios de un _multistage build_

notes:

Este método permite guardar por separado la caché de la imagen, bien en distintas
URLs dentro del mismo _registry_ o incluso en _registries_ separados. Por ejemplo,
envía la caché a uno privado y la imagen a uno público.

^^^^^^

#### BuilKit _cache exporters_: `registry`

Uso con `buildx`
* Necesitamos [crear un _builder_](https://docs.docker.com/engine/reference/commandline/buildx_create/) con el drive `docker-container`
* Usar las siguientes opciones del comando `docker buildx build`:
  * [`--output`](https://docs.docker.com/engine/reference/commandline/buildx_build/#output)
  * [`--cache-from`](https://docs.docker.com/engine/reference/commandline/buildx_build/#cache-from) 
  * [`--cache-to`](https://docs.docker.com/engine/reference/commandline/buildx_build/#cache-to)

notes:

Cuando usamos un _builder_ de tipo `docker-container` tenemos que especificar un formato de salida
de la imagen.

El motivo es que este _builder_ utiliza un contenedor para generar la imagen, mientras que
el _builder_ tradicional (de tipo `docker`) que es del que hemos estado hablando y utilizando
hasta, hace que sea el propio `dockerd` el que construye la imagen.

^^^^^^

#### BuilKit _cache exporters_: `local`

* Guarda la información en una carpeta local

notes:

Útil si sólo tienes una máquina en la que construyes las imágenes. Si tienes
un sistema de máquinas distribuido y auto escalable, debemos utilizar los otros
_exporters_.

^^^^^^

#### BuilKit _cache exporters_: `gha`

* Experimental en este momento
* Permite guardar la caché dentro del servicio de Caché de GitHub
* Requiere parámetros de [configuración adicional](https://github.com/moby/buildkit#github-actions-cache-experimental)

