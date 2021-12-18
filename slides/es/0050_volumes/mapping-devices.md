### Mapping devices: Linux

Se consigue con la opción `--device` de `docker run` o `docker container create`

Permite acceder a dispositivos dentro del contenedor:

```bash
> docker run --device=/dev/sda:/dev/xvdc --rm -it ubuntu fdisk  /dev/xvdc
```

notes:

[Documentación de la opción `--device` en `docker run`](https://docs.docker.com/engine/reference/commandline/run/#add-host-device-to-container---device)

^^^^^^

### Mapping devices: Windows

En windows, la sintaxis es:

```bash
--device=<IdType>/<Id>
```

Ejemplo:

```PS
PS C:\> docker run --device=class/86E0D1E0-8089-11D0-9CE4-08003E301F73 mcr.microsoft.com/windows/servercore:ltsc2019
```

^^^^^^

### Mapping devices: Windows

la opción `--device` sólo está soportada en Contenedores windows que se ejecuten 
en modo `process-isolated`

No está disponible cuando el contenedor se ejecuta en modo `hyperv-isolated`
o cuando se ejecuta la nueva característica Linux Containers on Windows (LCOW)