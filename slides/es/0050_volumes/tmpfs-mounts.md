### `tmpfs-mounts`

![tmpfs-mounts](../../images/types-of-mounts-tmpfs.png)<!-- .element: class="plain"-->


notes:

Como comentamos al principio del módulo, este tipo de almacenamiento se utiliza 
principalmente para guardar secrets y no tener que persistirlos en disco.

^^^^^^

### `tmpfs-mounts`

* Punto de montaje que se sitúa en la memoria del host
* Desaparece cuando el host se borra
* Los ficheros que se escriban en él no son persistentes
* No se puede compartir entre contenedores
* Sólo funciona cuando Docker se ejecuta en Linux

notes:

Como Docker for MAc se ejecuta en una máquina virtual con Linux, esta funcionalidad
también está disponible.

Esta opción no está disponible en Windows.

^^^^^^

### Uso: `-tmpfs` o `--mount`

La principal diferencia entre ambos es que `--tmpfs` no permite configurar ninguna opción

notes:

`--mount` acepta las siguientes opciones:

* `type` debe ser `tmpfs` para este tipo de puntos de montaje
* `destination` ruta dentro del contenedor en la que montar el volumen. Se puede usar `dst` o
  `target`.
* `tmpfs-size` tamaño en bytes. Ilimitado por default.
* `tmpfs-mode` permisos de los ficheros en octal, por ejemplo 700 o 0770. 
  Por defecto es 1777