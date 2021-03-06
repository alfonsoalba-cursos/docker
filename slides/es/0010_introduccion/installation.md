### 馃捑 Instalaci贸n de Docker: Linux 馃捑
<!-- .slide: data-background="../../images/tux.png" data-background-size="100vh" data-background-opacity="0.2"-->

^^^^^^

### Linux
<!-- .slide: data-background="../../images/tux.png" data-background-size="100vh" data-background-opacity="0.2"-->

* La forma recomendada es utilizar el gestor de paquetes de cada distribuci贸n
  * [Centos](https://docs.docker.com/install/linux/docker-ce/centos/)
  * [Debian](https://docs.docker.com/install/linux/docker-ce/debian/)
  * [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/)
  * [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* Todas las versiones y arquitecturas soportadas [aqui](https://docs.docker.com/engine/install/).

^^^^^^

### M茅todos alternativos:
<!-- .slide: data-background="../../images/tux.png" data-background-size="100vh" data-background-opacity="0.2"-->

* [Instalaci贸n a partir de binarios](https://docs.docker.com/install/linux/docker-ce/binaries/)
* Descarga e instalaci贸n de paquetes ```.rpm``` / ```.deb```

^^^^^^

### 馃捑 Instalaci贸n de Docker: Mac 馃捑
<!-- .slide: data-background="../../images/osx.png" data-background-size="100vh" data-background-opacity="0.2"-->

* Descargar [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/)
* Instalar el paquete

notes:

Como se indica en el enlace, para poder instalar Docker en Mac, se necesita:
* Hardware: de 2010 o posterior (debes tener soporte para MMU Virtualization, incluyendo Extended Page Tables (EPT) y Unrestricted Mode). Lo puedes comprobar f谩cilmente ejecutando ```sysctl kern.hv_support```
* Software: OSX 10.12 o posterior. Docker s贸lo da soporte a la versi贸n actual de OSX (10.14 en el momento de redactar estas diapositivas) y dos versiones anteriores.
* Al menos 4GB de RAM
* **No tener una versi贸n anterior a VirtualBox 4.3.30 instalada** ya que las versiones anteriores no son compatibles con Docker Desktop.

Pod茅is encontrar informaci贸n m谩s detallada en el enlace de la diapositiva.

^^^^^^

### 馃捑 Instalaci贸n de Docker: Windows 馃捑
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

^^^^^^

### Requisitos del sistema
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

* Dos opciones de ejecuci贸n: WSL2 o Hyper-V
* WSL2 recomendada (mejor rendimiento)
* Windows 11 64-bit: Home, Pro, Enterprise o Education versi贸n 21H2 o posterior
* Windows 10 64-bit: Home o Pro (Build >=19041) Enterprise o Education 1909 (build >=18363).
* Activar la caracter铆stica WSL2 de Windows
* Procesador de 64 bit con Second Level Address Translation (SLAT)
* 4GB  RAM
* Activar a nivel de BIOS el soporte de virtualizaci贸n de hardware ([M谩s informaci贸n sobre virtualizaci贸n](https://docs.docker.com/docker-for-windows/troubleshoot/#virtualization-must-be-enabled))
* Instalaci贸n de [Linux kernel update package](https://docs.microsoft.com/en-us/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)

^^^^^^

### Instalaci贸n
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->


* Descargar e instalar "Docker Desktop for Windows"

^^^^^^

### Instalaci贸n
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

* Una vez instalado dispondremos del icono en la barra del escritorio

![windows systray](../../images/whale-icon-systray-windows.png)<!-- .element: class="plain"-->


^^^^^^

### Instalaci贸n Windows Server
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->
```PowerShell
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider
Restart-Computer -Force
```

notes:
Revisar la 
[documentaci贸n oficial](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment) 
de microsoft para la instalaci贸n de docker en Windows Server

^^^^^^

### Process Isolation Mode
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

* Modo de ejecuci贸n disponible a partir de Docker 18.09.1 y Windows 10 
* En versiones anteriores s贸lo era posible con Windows Server
* En este modo se pueden usar herramientas como Task Manager o Process Monitor para monitorizar los contenedores
* Restricci贸n en este modo: la versi贸n del kernel de imagen del contenedor debe coincidir con el kernel del host


notes: 

* Informaci贸n extra铆da del [siguiente art铆culo](https://stefanscherer.github.io/how-to-run-lightweight-windows-containers-on-windows-10/)

* Art铆culo al respecto en el [Blog de Microsoft](https://blogs.msdn.microsoft.com/freddyk/2019/01/13/process-isolation-for-containers-in-windows-10/)

^^^^^^

### Hyper-V Isolation Mode
<!-- .slide: data-background="../../images/windows.png" data-background-size="100vh" data-background-opacity="0.2"-->

* Los procesos del contenedor se ejecutan sobre un "hypervisor" m铆nimo que se levanta antes de crear el contenedor
* Esto permite:
  * Ejecutar distintos kernels de windows
  * Levantar contenedores Linux dentro de Windows (LCOW)
* Precio a pagar por tener que levantar un "hypervisor"
  * se tarda m谩s en levantar el contenedor
  * se consumen m谩s recursos

^^^^^^

### Windows + Linux containers

M谩s dificil ahora que LCOW ha sido abandonado.

notes:

Algunos ejemplos de c贸mo podr铆amos conseguirlo:
* https://tobiasfenster.io/running-linux-and-windows-containers-at-the-same-time-on-windows-10
* https://lippertmarkus.com/2021/09/04/containers-without-docker-desktop/
^^^^^^

### LCOW (Linux Containers On Windows)

鈿狅笍 [DEPRECATED](https://github.com/linuxkit/lcow) 鈿狅笍

* Disponible a partir de Windows 10 Professional, Windows 10 Enterprise o Windows Server 2019 **version 1809**
* Permite ejecutar contenedores windows y linux simult谩neamente
* Antes de LCOW, Docker Desktop for Windows s贸lo permite ejecutar contenedores o de windows ode linux, **pero no se pod铆an tener contenedores de de ambos sistemas corriendo a la vez**
* LCOW utiliza *Hyper-V Isolation mode*
* Esta funcionalidad est谩, a d铆a de hoy en modo experimental

notes:

Antes del desarrollo de la tecnolog铆a LCOW, los contenedores en windows ten铆an una limitaci贸n importante:
o ejecutabas contenedores en windows o los ejecutabas en Linux. Esta situaci贸n era bastante limitante ya que
si quer铆as desarrollar, por ejemplo, una app en ASP .NET que consum铆a una API desarrollada en node, 
no pod铆as levantar los contenedores de manera simult谩nea.

Para poder usar LCOW, seg煤n se indica en la [propia documentaci贸n del proyecto](https://github.com/linuxkit/lcow), necesitamos:
* Windows 10 Pro or Windows Server 2016 1709 o superior
* Activar las carater铆sticas Hyper-V y Container de Windows
* Docker for Windows versi贸n 18.02 o posterior
* Levantar ```dockerd``` en modo experimental (dentro de Docker Desktop ir a _Settings -> Daemon_ y activar 'experimental features')

Una vez hecho esto, podemos levantar un contenedor de linux usando el argumento --platform=linux:

```PowerShell
docker run --platform linux --rm -ti busybox sh
```

Para profundizar sobre este tema, pod茅is utilizar los siguientes enlaces:
* [repositorio LCOW en github](https://github.com/linuxkit/lcow)
* Documentaci贸n oficial sobre LCOW de Microsoft, [aqu铆](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/linux-containers) y [aqu铆](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-10-linux)
* [Post oficial en el blog de Docker](https://www.docker.com/blog/docker-for-windows-18-02-with-windows-10-fall-creators-update/)


