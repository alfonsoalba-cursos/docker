#### Contenido módulo 4

#### Construcción de imágenes (Dockerfile)

* [Nuestra primera imagen](#our-first-image)
* [la caché](#build-cache)
* [`buildx`](#buildx)
* [_parser directives_](#parser-directives)
* [ENTRYPOINT vs CMD](#entrypoint-vs-cmd)
* [Instrucciones en el Dockerfile](#dockerfile-instructions)   
* [Ejecutando comandos](#running-commands)
* [Añadiendo ficheros a nuestra imagen](#copy-files)
* [_Secrets_](#secrets)
* [`RUN --mount=type=cache`](#run-mount-cache)
* [BuildKit _cache exporters_](#cache-exporters)
* [Buenas prácticas](#best-practices)
* [Múltiples servicios por contenedor](#multiple-services-in-a-container)
* [Ejercicio](#exercise)

notes:

Los objetivos de este módulo son:

* Entender el proceso de construcción de imágenes
* Crear nuestras primeras imágenes con docker usando un `Dockerfile`