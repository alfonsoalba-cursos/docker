### _Parser directives_

Directivas que lee el _frontend_ que convierte nuestro Dockerfile a LLB.

Formato: `# directive=value`

Aunque son case insensitive se recomienda escribirlas en minúsculas

**Tienen que aparece en la parte superior del fichero antes de cualquier otra instrucción o comentario**

^^^^^^

### ❌ Ejemplos no válidos 

```dockerfile
# direc \
  tive=value
```

Deben estar en una sóla línea


^^^^^^

### ❌ Ejemplos no válidos 

```dockerfile
# directive=value1
# directive=value2

FROM ubuntu:latest
```

No se pueden repetir

^^^^^^

### ❌ Ejemplos no válidos 

```dockerfile
FROM ubuntu:latest
# directive=value1
```

Se tratará como un comentario por aparecer después de una instrucción válida

^^^^^^

### ❌ Ejemplos no válidos 

```dockerfile
# This is my dockerfile
# directive=value1
FROM ubuntu:latest
```

Se tratará como un comentario por aparecer después de un comentario que no es 
un _parser directive_

^^^^^^

### ❌ Ejemplos no válidos 

```dockerfile
# unknowndirective=value
# knowndirective=value
FROM ubuntu:latest
```

Ambas se tratarán como un comentario. La primera por ser desconocida. La segunda
por aparecer después de la primera (que al ser desconocida, se tratará como un comentario)

^^^^^^

### ✅ Ejemplo válido

```dockerfile
#directive=value
# directive =value
#	directive= value
# directive = value
#	  dIrEcTiVe=value
FROM ubuntu:latest
```

^^^^^^ 

### Directivas soportadas

* [`syntax`](https://docs.docker.com/engine/reference/builder/#syntax)
* [`escape`](https://docs.docker.com/engine/reference/builder/#escape)

^^^^^^

### `syntax`

```dockerfile
# syntax=[remote image reference]
```

Define el lugar desde el que se puede descargar el Dockerfile que contiene 
la definición del _frontend_ que se usará para construir la imagen.

```dockerfile
# syntax=docker/dockerfile:1
```

[(doceker.io/docker/dockerfile)](https://hub.docker.com/r/docker/dockerfile)

notes:

Si accedemos al [Dockerfile del _frontend_](https://github.com/moby/buildkit/blob/dockerfile/1.3.1/frontend/dockerfile/cmd/dockerfile-frontend/Dockerfile) 
veremos cómo se construye el _frontend_ que usará buildkit para construir la imagen.

^^^^^^

### `syntax`

Ventajas de desacoplar el _frontend_ del proceso de construcción de la imagen:

* Actualizaciones y mejoras al Dockerfile sin necesidad de actualizar el demonio de docker
* Poder asegurarnos de que todo el mundo usa el mismo _frontend_ para construir las imágenes
* Usar [otros _frontends_ o incluso crear el nuestro](https://github.com/moby/buildkit#exploring-llb)

^^^^^^

### `syntax`

Valor recomendado:

`# syntax=docker/dockerfile:1`

* `docker/dockerfile:1.2` actualizar hasta la última versión `1.2.x`
* `docker/dockerfile:1.2.1` usar esta versión en particular

[Más información](https://docs.docker.com/engine/reference/builder/#official-releases)

notes:

El valor recomendado nos mantendrá actualizados a la última versión de la rama 1
del _frontend_.

Builkit comprueba si hay actualizaciones de forma automática cuando construye una imagen.

Existe un canal de distribución _labs_ que da acceso temprano a nuevas funcionalidades. Se
puede usar así: ` # syntax=docker/dockerfile:labs`

^^^^^^

### `escape`

Permite definir el valor del caracter de escape:

```dockerfile
# escape=\ 
```

`\` es el valor por defecto

notes:

Útil cuando creamos ficheros Dockerfile para Windows. 

```dockerfile
# escape=`

FROM microsoft/nanoserver
COPY testfile.txt c:\
RUN dir c:\
```