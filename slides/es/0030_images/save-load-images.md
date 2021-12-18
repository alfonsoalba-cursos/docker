### Guardar/cargar imágenes

Los comandos para guardar y cargar imágenes son:

* [`docker image save`](https://docs.docker.com/engine/reference/commandline/image_save/) y [`docker save`](https://docs.docker.com/engine/reference/commandline/save/)
* [`docker image load`](https://docs.docker.com/engine/reference/commandline/image_load/) y
[`docke load`](https://docs.docker.com/engine/reference/commandline/load/)

^^^^^^

### Guardar una imagen

El comando `docker image save` guarda una imagen a un archivo tar:

```bash
> docker save becorecode/curso-intro-docker-modulo-3 > modulo3_saved.tar
```

^^^^^^

### Cargar una imagen

Este fichero `.tar` generado por `docker image save` puede luego utilizarse para 
crear una nueva imagen usando `docker image load`:

```bash
> docker image ls -f 'reference=becorecode/*'
# Borramos la imagen
> docker image rm becorecode/curso-intro-docker-modulo-3
# La volvemos a cargar del fichero .tar
> docker image load < modulo3_saved.tar
> docker image ls -f 'reference=becorecode/*'
```

notes:

Para ilustrar cómo funciona `docker image ls` hacemos lo siguiente 
**después de guardar la imagen como hicimos en la diapositiva anterior**

* Borramos la imagen 
* Comprobamos que ya no la tenemos
* La cargamos
* Comprobamos que volvemos a tenerla


^^^^^^

### ¿Diferencia con export / import?

* La imagen que guardamos contiene toda la información de la imagen, puertos, comando de
  ejecución, etc.
* Si ejecutamos un contenedor con la imagen guardada, no hace falta escribir todas las opciones de
  nuevo como cuando la exportamos. Estas opciones guardan junto con la imagen al hacer `docker save`

^^^^^^

### Image flattering

* Técnica que consiste en crear una imagen, exportarla con `docker export` y crear una nueva a partir de fichero `.tar` generado
* De esta forma se eliminan capas intermedias y la imagen puede reducirse de tamaño

