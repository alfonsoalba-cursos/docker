### Mapping devices: Linux

Se consigue con la opción `--device` de `docker run` o `docker container create`

Permite acceder a dispositivos dentro del contenedor:

```shell
$ docker run --device=/dev/sda:/dev/xvdc --rm -it ubuntu fdisk  /dev/xvdc
```

notes:

[Documentación de la opción `--device` en `docker run`](https://docs.docker.com/engine/reference/commandline/run/#add-host-device-to-container---device)

^^^^^^

### Mapping devices: Windows

En windows, la sintaxis es:

```shell
--device=<IdType>/<Id>
```

Ejemplo:

```PS
PS C:\$ docker run --device=class/86E0D1E0-8089-11D0-9CE4-08003E301F73 mcr.microsoft.com/windows/servercore:ltsc2019
```

^^^^^^

### Mapping devices: Windows

la opción `--device` sólo está soportada en Contenedores windows que se ejecuten 
en modo `process-isolated`

No está disponible cuando el contenedor se ejecuta en modo `hyperv-isolated`
o cuando se ejecuta la nueva característica Linux Containers on Windows (LCOW)

^^^^^^

### GPUs NVIDIA

Usando la opción [`--gpu`](https://docs.docker.com/engine/reference/commandline/run/#access-an-nvidia-gpu),
es posible acceder a la GPU de este fabricante dentro de los contenedores:

```shell
$ docker run -it --rm --gpus device=GPU-3a23c669-1f69-c64e-cf85-44e9b07e7a2a ubuntu nvidia-smi
```

Requiere la instalación del [nvidia-container-runtime](https://nvidia.github.io/nvidia-container-runtime/)

notes:

Aunque las GPUs que se mencionan en la documentación oficial son las del fabricante NVIDIA,
una búsqueda en google muestra que es posible usar las GPUs de AMD. Como
muestra os dejo este artículo: 
[How to set up OpenCL for GPUs on Linux and Docker](https://linuxhandbook.com/setup-opencl-linux-docker/)