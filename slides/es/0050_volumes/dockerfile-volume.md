### `VOLUME`

```Dockerfile
VOLUME ["/tmp/path1", "/tmp/path2"]
VOLUME "/tmp/path1" "/tmp/path2"
```

[Instrucción de Dockerfile](https://docs.docker.com/engine/reference/builder/#volume)
que crea un punto de montaje.

Este punto de montaje se marca como que servirá para montar volúmenes bien del
host o de otros contenedores.

^^^^^^

### `VOLUME`

⚠️ **IMPORTANTE** 

una vez incluida la instrucción en el Dockerfile, cualquier modificación
a las rutas especificadas se ignora
 
^^^^^^


### `VOLUME`

Esta instrucción sólo se puede utilizar para configurar el punto de montaje en 
el contenedor

La carpeta del host que se montará no puede especificarse de antemano; se 
configura en el momento de levantar el contenedor en un host