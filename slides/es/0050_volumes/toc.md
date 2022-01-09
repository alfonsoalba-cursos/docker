#### Contenido módulo 5

#### Volúmenes

* [Almacenamiento en contenedores](#storage-overview)
* [Volúmenes](#volumes)
* [`bind mounts`](#bind-mounts)
* [`tmpfs mounts`](#tmpfs-mounts)
* [`VOLUME`](#dockerfile-volume)
* [Mapping devices](#mapping-devices)
* [Ejercicio](#exercise)

notes:

Hemos visto, en el módulo 2, que la información almacenada en la última capa de la imagen
del contenedor se borra cuando el contenedor termina de ejecutarse. Aquí es donde entran
en juego los volúmenes, que nos permitirán persistir la información entre
sucesivas ejecuciones de un contenedor.

Los objetivos de este módulo son:

* Entender qué es un volumen
* Usar volúmenes para persistir datos en contenedores