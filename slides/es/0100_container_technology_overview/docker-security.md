### &#x1F512; Seguridad en docker 

* Seguridad del kernel y el soporte para namespaces y cgroups
* Vectores de ataque al demonio de Docker
* Configuración incorrecta de Docker, ya sea por defecto o por los usuarios
* Cómo afectan las características de seguridad del kernel de Linux (por ejemplo SELinux) a la interacción del kernel 
  con los contenedores

^^^^^^

### Seguridad del Kernel

```docker run``` crea un conjunto de namespaces y control groups sobre los que se ejecuta el contenedor

^^^^^^
#### Seguridad del Kernel

&#x1F512;

Desde el punto de vista de la seguridad, es crítico mantener el kernel del host actualizado.

Fallos de seguridad detectados en cualquier de estas dos funcionalidades
afectan al aislamiento de nuestros contenedores


^^^^^^

### Vectores de ataque al demonio de Docker


Para poder ejectuar contenedores en un host 

**este debe ejecutar el demonio ```dockerd```**

^^^^^^

**```dockerd``` necesita ejecutarse con permisos de root.**

Existe un modo ["Rootless"](https://github.com/docker/engine/blob/v19.03.0-rc3/docs/rootless.md) 
pero a día de hoy está todavía en modo experimentación.

^^^^^^

**Sólo los usuarios de confianza deben tener acceso administrativo al demonio '''dockerd'''**

notes:

Docker allows you to share a directory between the Docker host and a guest container; and it allows you to do so without limiting the access rights of the container. This means that you can start a container where the /host directory is the / directory on your host; and the container can alter your host filesystem without any restriction. This is similar to how virtualization systems allow filesystem resource sharing. Nothing prevents you from sharing your root filesystem (or even your root block device) with a virtual machine.

This has a strong security implication: for example, if you instrument Docker from a web server to provision containers through an API, you should be even more careful than usual with parameter checking, to make sure that a malicious user cannot pass crafted parameters causing Docker to create arbitrary containers.

^^^^^^

El endpoint de la API REST de Docker utiliza un socker UNIX en lugar un socket TCP ligado al interfaz 127.0.0.1 a partir de la versión 0.5.2 

¿Por qué? Un socket TCP es susceptible de sufrir ataques de tipo cross-site request forgery si da la casualidad de que estás ejecutando dockerd en la misma máquina que el navegador web.<!-- .element: class="fragment" data-fragment-index="1" -->

Además, al ser un socket UNIX, puedes limitar el acceso usando el sistema tradicional de permisos de UNIX.<!-- .element: class="fragment" data-fragment-index="2" -->


notes:
El socket UNIX es el que usa Docker CLI para comunicarse con ```dockerd```

^^^^^^

### ¿Necesitas exponer la API REST a través de HTTP?

* Protege el acceso con cortafuegos y VPN
* Es **obligatorio** el uso de [https y certificados](https://docs.docker.com/engine/security/https/)
* Como altenativa puedes utilizar túneles SSH

^^^^^^

### A ```dockerd``` le gusta estar solo...

Se recomienta que si un host va a ejecutar contenedores, este sólo corra el demonio

El resto de servicios deben ejecutarse como contenedores

Se pueden mantener servicios como SSH y herramientas administrativas y/o de supervisión de procesos como NRPE. Todo lo demás debería ejecutarse como un contenedor

^^^^^^

### ¿Necesitamos ejecutar los procesos dentro de un contenedor como root?

La respuesta es NO en un 99,99999999999999999999999% de las veces

...bueno, quizás esté exagerando un poco con los 9s<!-- .element: class="fragment" data-fragment-index="1" -->

^^^^^^
#### ¿Necesitamos ejecutar los procesos de un contenedor como root?

En la máquina host, **SÍ** habrá servicios que necesitemos ejecutar como root, por ejemplo SSH, ```cron```, módulos del kernel, herramientas de administración y gestión de red, logs...

^^^^^^

#### ¿Necesitamos ejecutar los procesos de un contenedor como root?

* No necesitamos acceder por ssh al contenedor. Accedemos al host por ssh y usando ```docker exec``` accedemos al contenedor
* Si la aplicación requiere el uso de ```cron``` este se puede ejecutar como un proceso de usuario personalizado para la aplicación en cuestión. **No se necesita un cron de sistema**
* La gestión del log del contenedor la hace normalmente ```dockerd``` del host
* La red la gestiona ```dockerd```
* No hace falta gestionar hardware ni dispositivos


^^^^^^
#### ¿Necesitamos ejecutar los procesos de un contenedor como root?

Si lo tenemos que hacer **podemos ejecutar nuestros contenedores con un usuario root muy "capado"**

* no puede montar de dispositivos (```mount```)
* no puede acceder a raw sockets (para evitar packet spoofing)
* no puede realizar operaciones sobre el sistema de ficheros
* no puede cargar módulos

^^^^^^
#### ¿Necesitamos ejecutar los procesos de un contenedor como root?

Así, incluso si un atacante obtiene permisos de root en el contenedor 

**no puede hacer casi nada**

^^^^^^

#### Ejecutar un contenedor sin ninguna capability

* A día de hoy, Docker no permite asignar y quitar "capabilites" a usuarios regulares, sólo se puede hacer a root

^^^^^^

### Vectores de ataque sobre las imágenes

Un atacante puede generar una imagen falsa e intentar colártela usando ```docker load```

Para hacerlo, el atacante genera una imagen falsa que genera una colisión: tiene el mismo checksum que la imagen original.

Para evitarlo, a partir de la versión 1.10.0 de docker, la imagen se almacena y se accede usando el checksum del contenido, lo que dificulta a un atacante causar una colisión

^^^^^^

### Algunos consejos de seguridad para nuestras imágenes

* Deshabilitar `setuid` dentro de la imagen

```Dockerfile
RUN find / -perm +6000 -type f -exec chmod a-s {} \;
```

^^^^^^

#### Algunos consejos de seguridad para nuestras imágenes

* No ejecutar los procesos como usuario root dentro de los contenedores

```Dockerfile
RUN groupadd -r thegroup && useradd -r -g thegroup theuser
USER theuser
```
^^^^^^

#### Algunos consejos de seguridad para nuestras imágenes

* No ejecutar contenedores con la opción `--privileged`
* Ejecutar un contenedor con la opción `--privileged` 
  **activa en nuestro contenedor todas las _capabilities_**
* Ejecutar los contenedores quitando todas las _capabilities_
  y activando solo aquellas que necesitemos

```bash
> docker run --cap-drop=ALL --cap-add=CAP_NET_ADMIN ...
```
^^^^^^
#### Algunos consejos de seguridad para nuestras imágenes

* Descargar imágenes por su checksum en lugar de por su tag:

```bash
> docker pull mysql@sha256:44b33224e3c406bf50b5a2ee4286ed0d7f2c5aec1f7fdb70291f7f7c570284dd
```
...esto descarga la imagen `mysql:5.7` pero verificando que el checksum
es el esperado

^^^^^^
#### Algunos consejos de seguridad para nuestras imágenes
* Otra forma de hacer es utilizar Docker Content Trust

```bash
> export DOCKER_CONTENT_TRUST=1
> docker pull mysql:5.7
Pull (1 of 1): mysql:5.7@sha256:44b33224e3c406bf50b5a2ee4286ed0d7f2c5aec1f7fdb70291f7f7c570284dd
```

Se encarga de obtener el checksum de la imagen por nosotros. 

^^^^^^
#### Algunos consejos de seguridad para nuestras imágenes
* Ejecutar contenedores en modo read-only

```bash
> docker run --read-only alpine touch x
touch: x: Read-only file system
```

* Montar volúmenes en modo read-only

```bash
> docker run -v $(pwd)/secrets:/secrets:ro alpine touch secrets/x
touch: secrets/x: Read-only file system
```

^^^^^^

### Herramientas de seguridad para docker

* [Docker Bench for Securiry](https://github.com/docker/docker-bench-security) 
  Script para testar multitud de buenas prácticas y configuraciones en producción
* [Clair](https://coreos.com/clair/docs/latest/) Análisis estático de vulnerabilidades
* [Cilium](https://github.com/cilium/cilium) Seguridad adicional de red 
  (Layer 7)
* [Anchore](https://github.com/anchore/anchore-engine) Análisis de imágenes
* [lynis](https://cisofy.com/lynis/) / [lynis-docker](https://cisofy.com/lynis/plugins/docker/)


^^^^^^

### Otras herramientas de seguridad del kernel

* Docker es compatible con TOMOYO, AppArmor, SELinux, GRSEC y herramientas similares
  * [Ejemplos](https://docs.docker.com/engine/security/apparmor/) de cómo ejecutar un contenedor con AppArmor
  * [RedHat](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/container_security_guide/docker_selinux_security_policy) incluye una política para SELinux para asegurar contenedores y máquinas virtuales

notes:

Enlace adicional: https://www.mankier.com/8/docker_selinux

^^^^^^

### Otras herramientas de seguridad del kernel

* A partir de Docker 1.10 ```dockerd``` soporta "User Namespaces"
* Esto permite mapear el usuario root dentro del contenedor a un usuario con id distinto de cero **fuera del contenedor**
* Así podemos mitigar ataques en los que el atacante consiga escapar del contenedor
* Más información:
  * [Configuración de ```dockerd```](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-user-namespace-options)
  * [Este post](https://integratedcode.us/2015/10/13/user-namespaces-have-arrived-in-docker/)


^^^^^^

### Recursos útiles

* [Documentación oficial de Docker](https://docs.docker.com/engine/security/security/)
* [Docker Labs sobre capabilities](https://github.com/docker/labs/tree/master/security/capabilities)
* [Charla de Jose Manuel Ortega](https://www.youtube.com/watch?v=nluTVEjycF0&feature=youtu.be)
* [10 Herramientas de seguridad sobre docker (post)](https://techbeacon.com/security/10-top-open-source-tools-docker-security)
* [Docker Security (Book)](https://www.oreilly.com/library/view/docker-security/9781492042297/)
* [Securing Docker (Book)](https://www.packtpub.com/eu/virtualization-and-cloud/securing-docker)