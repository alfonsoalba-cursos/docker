### Instalación

[Documentación](https://docs.docker.com/compose/install/)

^^^^^^
<!-- .slide: data-background="images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Windows 10

**Se instala con Docker for Windows**

^^^^^^
<!-- .slide: data-background="images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Windows 10

Probar la instalación:

```PowerShell
> docker-compose --version
```

^^^^^^
<!-- .slide: data-background="images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Windows Server

1. Abrir una consola PowerShell con permisos de administración
1. Github requiere el uso de TLS 1.2:

    ```PowerShell
      [Net.ServicePointManager]::SecurityProtocol = 
      [Net.SecurityProtocolType]::Tls12
    ````
1. Ejecutar el siguiente comando para instalar `docker-compose` versión 1.24.1 
   (versión disponible cuando se redactaron las diapositivas)
   
    ```PowerShell
    Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Windows-x86_64.exe" 
      -UseBasicParsing 
      -OutFile $Env:ProgramFiles\Docker\docker-compose.exe
    ```

^^^^^^
<!-- .slide: data-background="images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

#### Windows Server


En Windows Server 2019, se puede añadir el ejecutable `docker-compose` 
a `$Env:ProgramFiles\Docker` 

Como este directorio está registrado en el `PATH` del sistema, 
se puede ejecutar el comando `docker-compose --version` sin necesidad de ninguna configuración adicional

^^^^^^
<!-- .slide: data-background="images/osx.png" data-background-size="100vh" data-background-opacity="0.2"-->

### OS X

**Se instala con Docker Desktop for Mac**

^^^^^^
<!-- .slide: data-background="images/osx.png" data-background-size="100vh" data-background-opacity="0.2"-->

#### OS X

Probar la instalación:

```PowerShell
> docker-compose --version
```

^^^^^^
<!-- .slide: data-background="images/tux.png" data-background-size="100vh" data-background-opacity="0.2"-->

### Linux

Se instala descargando el ejecutable disponible desde el repositorio de github:

```bash
> sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

> sudo chmod +x /usr/local/bin/docker-compose

```
