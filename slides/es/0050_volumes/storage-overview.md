### Almacenamiento en contenedores

![container layer](../../images/docker-containers-and-images-1.jpg)<!-- .element: class="plain"-->

notes:

Como vimos en el módulo 3 de gestión de imágenes, los datos que se guardan en un contenedor
se almacenan en la capa que denominamos _container layer_.

Esto implica lo siguiente:

* La información desparacerá cuando el contenedor deje de existir.
* Si otro proceso o contenedor, incluido el propio host, necesita acceder a los datos
 no hay una manera sencilla de acceder a ellos
* Estos datos estarán acoplados al contenedor y por lo tanto a la máquina en la que
  este se ejecute. **No nos resultará nada facil moverlos de un host a otro**
* Escribir en esta capa require el uso de un _storage driver_ que gestiona este 
  sistema de ficheros tan especial. Este driver añade una capa extra de abstracción 
  que reduce el rendimiento, que será menor que si accediésemos a los datos almacenados
  en el host.

^^^^^^

### Tipos de puntos de montaje 

![tipos de puntos de montaje](../../images/types-of-mounts.png)

* Volúmenes
* _bind mounts_
* `tmpfs` _mounts_

^^^^^^

#### Tipos de puntos de montaje: Volúmenes

* Espacio de almacenamiento que se guarda en el sistema de ficheros del host
* Este espacio se reserva **dentro del espacio configuración del contenedor** 
  (`/var/lib/docker/volumes/[VOLUME NAME]/_data`)
* Gestionado por `dockerd` (mala idea andar tocando ahí a pelo...)
* Estos volúmenes del host se montan en los contenedores. Los datos aquí almacenados
  son accesibles desde los contenedores

^^^^^^

#### Tipos de puntos de montaje: Volúmenes

* Este espacio de almancenamiento **no se borra cuando se borra el contenedor**. 
  Se tienen que borrar explícitamente del host.
* La información de los volúmenes **no se transfiere a la imagen con el comando `docker commit`**
* Existe un sistema de _drivers_ que permite que los datos puedan almacenarse
  en hosts remotos o proveedores cloud para conseguir la máxima flexibilidad

^^^^^^

#### Tipos de puntos de montaje: Volúmenes

* ¿Cuándo usarlos?
  * Si queremos compartir información entre múltiples contenedores
  * Quieres almacenar la información en un host remoto o en proveedor cloud
    en lugar de hacerlo en el sistema de ficheros del host
  * Hacer backup, recuperar o mover datos de un host a otro. Si tienes la información 
    almacenada en volúmenes, sólo tienes que parar los contenedores y trabajar sobre la
    carpeta `/var/lib/docker/volumes/`

^^^^^^

#### Tipos de puntos de montaje:  _bind mounts_

![tipos de puntos de montaje](../../images/types-of-mounts.png)

A diferencia de los volúmenes, un _bind mount_ nos permite acceder a una
determinada carpeta del host desde el contenedor

^^^^^^

#### Tipos de puntos de montaje:  _bind mounts_

* El rendimiento es muy bueno
* La carpeta del host a la que queremos acceder debe existir **si no existe
  el contenedor no se podrá ejecutar**
* No existen comandos para gestionar estos puntos de montaje

^^^^^^

#### Tipos de puntos de montaje:  _bind mounts_

* ¿Cuándo usarlos?
  * Compartir ficheros de configuración entre el host y los contenedores
  * En entornos de desarrollo
  * Si tenemos la garantía absoluta de que la estructura de carpetas del host
    en el que se levantará el contenedor tiene los puntos de montaje que 
    necesitamos

^^^^^^

#### Tipos de puntos de montaje: _tmpfs_

![tipos de puntos de montaje](../../images/types-of-mounts.png)

Se ejecuta en memoria y nunca se persiste a disco.

notes:

Se utilizan principalmente para almacenar información sensible. Por ejemplo,
los servicios de `swarm` lo utilizan para compartir `secrets` entre contenedores.

^^^^^^

### Tips

* Si montas un volumen vacío en un directorio de un contenedor que contiene 
  directorios o ficheros, *estos se copiarán al volumen*
* Si levantas un contenedor y especificas un volumen que no existe, **este se crea**
* Si montas directorio o fichero del host utilizando un _bind mount_ sobre 
  un fichero o directorio del contenedor que contiene algo, 
  **dentro del contenedor verás el contenido del host**. Los ficheros y directorios
  del contenedor no se borran, pero no podrás acceder a ellos.
