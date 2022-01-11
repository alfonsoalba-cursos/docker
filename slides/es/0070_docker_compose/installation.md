### Instalación

Actualmente hay dos versiones de `docker compose`

* Versión 1: comando independiente `docker-compose` (python)
* Versión 2: comando de docker `docker compose` (reimplementación en Go)

En este curso utilizaremos la versión 2.

notes:

A fecha de redacción de estas diapositivas, no existe una fecha programada para que
la versión 1 quede obsoleta. El equipo de docker está trabajando para hacer la transición
lo más facil y transparente posible. Podéis ver 
[más información sobre esta transición aquí](https://docs.docker.com/compose/cli-command/#transitioning-to-ga-for-compose-v2).

En la página 
[Compose command compatibility with docker-compose](https://docs.docker.com/compose/cli-command-compatibility/)
podéis ver algunas opciones de `docker-compose` que no están implementadas en la versión 2.


^^^^^^
### Instalación

[Documentación](https://docs.docker.com/compose/install/)

notes:

Recordad que en este curso usaremos la versión 2, por lo que aseguraos de instalar esta
versión en vuestras máquinas con Linux.


^^^^^^
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Windows 10/11

**Se instala con Docker for Windows**

notes:

Docker for Windows instala la versión 2 por defecto.

^^^^^^
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Windows 10/11

Probar la instalación:

```PowerShell
> docker compose version
Docker Compose version v2.2.1
```

^^^^^^
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Windows Server: Sólo versión 1

1. Abrir una consola PowerShell con permisos de administración
1. Github requiere el uso de TLS 1.2:

    ```PowerShell
      [Net.ServicePointManager]::SecurityProtocol = 
      [Net.SecurityProtocolType]::Tls12
    ````
1. Ejecutar el siguiente comando para instalar `docker-compose` versión 1.29.2 
   (versión disponible cuando se redactaron las diapositivas)
   
    ```PowerShell
    Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Windows-x86_64.exe" 
      -UseBasicParsing 
      -OutFile $Env:ProgramFiles\Docker\docker-compose.exe
    ```

^^^^^^
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

#### Windows Server


En Windows Server 2019, se puede añadir el ejecutable `docker-compose` 
a `$Env:ProgramFiles\Docker` 

Como este directorio está registrado en el `PATH` del sistema, 
se puede ejecutar el comando `docker-compose --version` sin necesidad de ninguna configuración adicional

^^^^^^
<!-- .slide: data-background="../../images/osx.png" data-background-size="100vh" data-background-opacity="0.2"-->

### OS X

**Se instala con Docker Desktop for Mac**

^^^^^^
<!-- .slide: data-background="../../images/osx.png" data-background-size="100vh" data-background-opacity="0.2"-->

#### OS X

Probar la instalación:

```PowerShell
> docker compose version
Docker Compose version v2.2.1
```

^^^^^^
<!-- .slide: data-background="../../images/tux.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Linux

Se instala descargando el ejecutable disponible desde el repositorio de github:

```bash
$ mkdir -p ~/.docker/cli-plugins/local/bin/docker-compose
$ curl -SL https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
$ chmod +x ~/.docker/cli-plugins/docker-compose
$ docker compose version
Docker Compose version v2.2.2
```

notes:

Ver [Install V2 on Linux](https://docs.docker.com/compose/cli-command/#install-on-linux)