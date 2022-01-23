# _Rootless mode_

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Configurar el demonio `dockerd` para que no se ejecute como usuario `root`

## Introducción

_Rootless mode_ ejecuta `dockerd` y los contenedores dentro de un espacio de nombres de usuario del
núcleo de Linux. 

Para poder utilizar este modo, sólo se necesita activar el bit `SETUID` en los ejecutables
`newuidmap` and `newgidmap`. Estos comandos permiten a un mismo usuario utilizar múltiples
UIDs/GUIDs dentro del espacio de nombres.

Para probar este modo, utilizaremos un usuario sin privilegios, tampoco a través de `sudo`.
Para ello, crearemos un usuario `rootless`:

```shell
adduser rootless
Adding user `rootless' ...
Adding new group `rootless' (1000) ...
Adding new user `rootless' (1000) with group `rootless' ...
Creating home directory `/home/rootless' ...
Copying files from `/etc/skel' ...
New password:
Retype new password: 
passwd: password updated successfully
Changing the user information for rootless
Enter the new value, or press ENTER for the default
        Full Name []:
        Room Number []: 
        Work Phone []: 
        Home Phone []: 
        Other []: 
Is the information correct? [Y/n] Y
root@ubuntu:~/tests/0100-rootless-mode# su - rootless
```

A lo largo del taller, es indicará en el _prompt_ del comando el usuario que
está ejecutando cada comando.

## Requisitos previos

* Tener instalados los comandos `newuidmap` y `newgidmap` en la máquina
  ```shell
  (root) $ apt install uidmap
  ```
* Disponer de al menos de 65,536 UIDs/GIDs subordinados para el usuario.
  ```shell
  (rootless) $ id -u
  1000
  (rootless) $ whoami
  rootless
  (rootless) $ grep ^$(whoami): /etc/subuid
  rootless:100000:65536
  (rootless) $ grep ^$(whoami): /etc/subgid
  rootless:100000:65536

A parte de estos requisitos genéricos, 
[cada distrubución](https://docs.docker.com/engine/security/rootless/#distribution-specific-hint)
tiene sus propias limitaciones y/o paquetes a instalar. Por ejemplo, en Debian 10, debido a la
versión del Kernel utilizada (4.9) no se puede utilizar el sistema de ficheros `overlay2` en
_Rootless mode_

Para Ubuntu, realizaremos las siguientes operaciones:

```shell
(root) $ install -y dbus-user-session
```

Como se mencionó en las diapositivas, acuerdate de revisar las 
[limitaciones del _Rootles mode_](https://docs.docker.com/engine/security/rootless/#known-limitations)
antes de activarlo.


## Instalación

Los paquetes de instalación de docker incluyen un script para activar este modo de operación.

Para poder realizar la instalación, debemos abrir una sesión ssh para el usuario `rootless` en otra
terminal ([más información aquí](https://unix.stackexchange.com/a/657714/394180)). **No sirve con 
utilizar `su - rootless`** (ver un poco más abajo el mensaje si no podemos configurar `systemd` con nuestro usuario)


```shell
(rootless) $ dockerd-rootless-setuptool.sh install

[INFO] Creating /home/rootless/.config/systemd/user/docker.service
[INFO] starting systemd service docker.service
+ systemctl --user start docker.service
+ sleep 3
+ systemctl --user --no-pager --full status docker.service
* docker.service - Docker Application Container Engine (Rootless)
     Loaded: loaded (/home/rootless/.config/systemd/user/docker.service; disabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-01-23 07:28:11 UTC; 3s ago
       Docs: https://docs.docker.com/go/rootless/
   Main PID: 212455 (rootlesskit)
     CGroup: /user.slice/user-1000.slice/user@1000.service/docker.service
             |-212455 rootlesskit --net=slirp4netns --mtu=65520 --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --disable-host-loopback --port-driver=builtin --copy-up=/etc --copy-up=/run --propagation=rslave /usr/bin/dockerd-rootless.sh 
             |-212466 /proc/self/exe --net=slirp4netns --mtu=65520 --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --disable-host-loopback --port-driver=builtin --copy-up=/etc --copy-up=/run --propagation=rslave /usr/bin/dockerd-rootless.sh
             |-212485 slirp4netns --mtu 65520 -r 3 --disable-host-loopback --enable-sandbox --enable-seccomp 212466 tap0  
             |-212492 dockerd
             `-212509 containerd --config /run/user/1000/docker/containerd/containerd.toml --log-level info

Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.851834974Z" level=warning msg="Your kernel does not support CPU realtime scheduler"
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.851840622Z" level=warning msg="Your kernel does not support cgroup blkio weight"
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.851845803Z" level=warning msg="Your kernel does not support cgroup blkio weight_device"
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.852001163Z" level=info msg="Loading containers: start."
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.933220887Z" level=info msg="Default bridge (docker0) is assigned with an IP address 172.17.0.0/16. Daemon option --bip can be used to set a preferred IP address"     
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.965338487Z" level=info msg="Loading containers: done."
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.973444140Z" level=warning msg="Not using native diff for overlay2, this may cause degraded performance for building images: running in a user namespace" storage-driver=overlay2
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.973585438Z" level=info msg="Docker daemon" commit=459d0df graphdriver(s)=overlay2 version=20.10.12
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.973632422Z" level=info msg="Daemon has completed initialization"
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.988456156Z" level=info msg="API listen on /run/user/1000/docker.sock"
+ DOCKER_HOST=unix:///run/user/1000/docker.sock /usr/bin/docker version
Client: Docker Engine - Community
 Version:           20.10.12
 API version:       1.41
 Go version:        go1.16.12
 Git commit:        e91ed57
 Built:             Mon Dec 13 11:45:33 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.12
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.12
  Git commit:       459d0df
  Built:            Mon Dec 13 11:43:42 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.12
  GitCommit:        7b11cfaabd73bb80907dd23182b9347b4245eb5d
 runc:
  Version:          1.0.2
  GitCommit:        v1.0.2-0-g52b36a2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
+ systemctl --user enable docker.service
Created symlink /home/rootless/.config/systemd/user/default.target.wants/docker.service -> /home/rootless/.config/systemd/user/docker.service.
[INFO] Installed docker.service successfully.
[INFO] To control docker.service, run: `systemctl --user (start|stop|restart) docker.service`
[INFO] To run docker.service on system startup, run: `sudo loginctl enable-linger rootless`

[INFO] Creating CLI context "rootless"
Successfully created context "rootless"

[INFO] Make sure the following environment variables are set (or add them to ~/.bashrc):

export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
```

Las dos líneas del final son importantes. Ejecutamos los siguientes comandos:

```shell
(rootless) $ export PATH=/usr/bin:$PATH
(rootless) $ export DOCKER_HOST=unix:///run/user/1000/docker.sock
(rootless) $ echo 'export PATH=/usr/bin:$PATH' >> ~/.bashrc 
(rootless) $ echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >>  ~/.bashrc
```

Si miramos los procesos del usuario `roiotless` veremos como `dockerd` se está utilizando como
usuario `rootless` en lugar de `root`:

```shell
(rootless) $ ps uxf

USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
rootless  211954  0.0  0.1  13936  6076 ?        S    07:20   0:00 sshd: rootless@pts/1
rootless  211955  0.0  0.1  11704  5176 pts/1    Ss   07:20   0:00  \_ -bash
rootless  212743  0.0  0.0  12136  3300 pts/1    R+   07:35   0:00      \_ ps uxf
rootless  211869  0.0  0.2  21432 10852 ?        Ss   07:20   0:00 /lib/systemd/systemd --user
rootless  211870  0.0  0.1 169536  4264 ?        S    07:20   0:00  \_ (sd-pam)
rootless  212455  0.0  0.2 1231584 11028 ?       Ssl  07:28   0:00  \_ rootlesskit --net=slirp4netns --mtu=65520 --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --disable-host-loopback --port-driver=builtin --copy-up=/etc --copy-up=/run --propagation=rslave /usr/bin/dockerd-rootless.sh
rootless  212466  0.0  0.2 1231248 10860 ?       Sl   07:28   0:00      \_ /proc/self/exe --net=slirp4netns --mtu=65520 --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --disable-host-loopback --port-driver=builtin --copy-up=/etc --copy-up=/run --propagation=rslave /usr/bin/dockerd-rootless.sh
rootless  212492  0.0  1.9 1605100 77684 ?       Sl   07:28   0:00      |   \_ dockerd
rootless  212509  0.4  1.0 1567040 42272 ?       Ssl  07:28   0:01      |       \_ containerd --config /run/user/1000/docker/containerd/containerd.toml --log-level info
rootless  212485  0.0  0.0   4824  3056 ?        S    07:28   0:00      \_ slirp4netns --mtu 65520 -r 3 --disable-host-loopback --enable-sandbox --enable-seccomp 212466 tap0
```

<details>
  <summary>dockerd-rootless-setuptool.sh install (no se detecta systemd)</summary>
  <code>
  [INFO] systemd not detected, dockerd-rootless.sh needs to be started manually:

  PATH=/usr/bin:/sbin:/usr/sbin:$PATH dockerd-rootless.sh

  [INFO] Creating CLI context "rootless"
  Successfully created context "rootless"

  [INFO] Make sure the following environment variables are set (or add them to ~/.bashrc):

  WARNING: systemd not found. You have to remove XDG_RUNTIME_DIR manually on every logout.
  export XDG_RUNTIME_DIR=/home/rootless/.docker/run
  export PATH=/usr/bin:$PATH
  export DOCKER_HOST=unix:///home/rootless/.docker/run/docker.sock
  </code>
</details>

## `systemctl`

Al ejecutar `systemctl` como usuario `rootless`, debemos usar la opción `--user`. Si no lo hacemos:

```shell
(rootless) $ systemctl status docker
* docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-01-22 09:11:44 UTC; 22h ago
TriggeredBy: * docker.socket
       Docs: https://docs.docker.com
   Main PID: 205618 (dockerd)
      Tasks: 16
     Memory: 38.6M
     CGroup: /system.slice/docker.service
             `-205618 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Warning: some journal files were not opened due to insufficient permissions.
```

Si usamos `--user`:

```shell
(rootless) $ systemctl --user status docker
* docker.service - Docker Application Container Engine (Rootless)
     Loaded: loaded (/home/rootless/.config/systemd/user/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-01-23 07:28:11 UTC; 13min ago
       Docs: https://docs.docker.com/go/rootless/
   Main PID: 212455 (rootlesskit)
     CGroup: /user.slice/user-1000.slice/user@1000.service/docker.service
             |-212455 rootlesskit --net=slirp4netns --mtu=65520 --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --disabl>
             |-212466 /proc/self/exe --net=slirp4netns --mtu=65520 --slirp4netns-sandbox=auto --slirp4netns-seccomp=auto --dis>
             |-212485 slirp4netns --mtu 65520 -r 3 --disable-host-loopback --enable-sandbox --enable-seccomp 212466 tap0       
             |-212492 dockerd
             `-212509 containerd --config /run/user/1000/docker/containerd/containerd.toml --log-level info

Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.851834974Z" level=warning msg="Your kernel does >
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.851840622Z" level=warning msg="Your kernel does >
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.851845803Z" level=warning msg="Your kernel does >
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.852001163Z" level=info msg="Loading containers: >
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.933220887Z" level=info msg="Default bridge (dock>
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.965338487Z" level=info msg="Loading containers: >
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.973444140Z" level=warning msg="Not using native >
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.973585438Z" level=info msg="Docker daemon" commi>
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.973632422Z" level=info msg="Daemon has completed>
Jan 23 07:28:11 ubuntu dockerd-rootless.sh[212492]: time="2022-01-23T07:28:11.988456156Z" level=info msg="API listen on /run/u>

```

En ubuntu 20.04 los siguientes comandos no hacen falta, pero en otras distribuciones sí que pueden ser necesarios.
Con ellos se consigue que docker se levante usando _Rootless mode_ al reinicio del sistema:

```shell
(rootless) $ systemctl --user enable docker
(root) $ loginctl enable-linger rootless
```

## Rutas

La ruta al socket está en la carpeta `$XDG_RUNTIME_DIR/docker.sock` (`$XDG_RUNTIME_DIR` suele ser `/run/user/$UID`):

```shell
(rootless) $ echo $XDG_RUNTIME_DIR
/run/user/1000
(rootless) $ ls -l $XDG_RUNTIME_DIR
srw-rw-rw- 1 rootless rootless   0 Jan 23 07:48 bus
drwx-----T 5 rootless rootless 120 Jan 23 07:48 docker
-rw-r--r-T 1 rootless rootless   4 Jan 23 07:48 docker.pid
srw-rw---T 1 rootless   100997   0 Jan 23 07:48 docker.sock
drwx------ 2 rootless rootless 140 Jan 23 07:48 gnupg
d--------- 3 rootless rootless 160 Jan 23 07:48 inaccessible
srw-rw-rw- 1 rootless rootless   0 Jan 23 07:48 pk-debconf-socket
srw-rw-rw- 1 rootless rootless   0 Jan 23 07:48 snapd-session-agent.socket
drwxr-xr-x 3 rootless rootless 100 Jan 23 07:49 systemd
```

La carpeta de datos está en `~/.local/share/docker`. **Esta carpeta no debe ser un volumen NFS.**

El fichero de configuración de `dockerd` está en `~/.config/docker`

## Configuración del cliente

Para usar el cliente tenemos dos opciones. De nuevo, en Ubuntu 20.04 no es necesario hacer nada ya que se
utiliza la primera de ellas.

La primera opción es fijar la variable `$DOCKER_HOST` (que en Ubuntu 20.04 ya lo está `echo $DOCKER_HOST`):
```shell
$ export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
$ docker run -d -p 8080:80 nginx
```

La segunda opción el utilizar contextos:

```shell
(rootless) $ docker context ls
NAME        DESCRIPTION                               DOCKER ENDPOINT                     KUBERNETES ENDPOINT   ORCHESTRATOR
default *   Current DOCKER_HOST based configuration   unix:///run/user/1000/docker.sock                         swarm
rootless    Rootless mode                             unix:///run/user/1000/docker.sock
Warning: DOCKER_HOST environment variable overrides the active context. To use a context, either set the global --context flag, or unset DOCKER_HOST environment variable.
```

Si quisiésemos utilizar `docker context` en Ubuntu 20.04, tendríamos que desactivar la variable `DOCKER_HOST`.

## La carpeta de datos

Cuando activamos _Rootless mode_, la carpeta de datos del demonio `dockerd` cambia. Podemos verificarlo
listando las imágenes que tenemos en el sistema:

```shell
(rootless) $ docker image ls -a
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

No vemos ninguna de las imágenes de los talleres anteriores.

```shell
(rootless) $ du -sh  ~/.local/share/docker
328K    /home/rootless/.local/share/docker

(rootless) $ docker image pull ruby:3.0
3.0: Pulling from library/ruby
0e29546d541c: Pull complete
9b829c73b52b: Pull complete 
cb5b7ae36172: Pull complete
6494e4811622: Pull complete
6f9f74896dfa: Pull complete
8692434624fe: Pull complete
9aa12acbe04d: Pull complete 
98d26be0b9cb: Pull complete
Digest: sha256:f6c236c1474acd83216ccacbaf7019778cbaea73c8048652087a4b64a862af63
Status: Downloaded newer image for ruby:3.0
docker.io/library/ruby:3.0

(rootless) $ du -sh  ~/.local/share/docker
(...varios errores de permisos...)
916M    /home/rootless/.local/share/docker

(rootless) $ docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ruby         3.0       16a2037fa72d   4 weeks ago   882MB
```


## Limpieza

Como usuario `rootless`, desinstalamos el _Rootless mode_:

```shell
(rootless) $ dockerd-rootless-setuptool.sh uninstall
```


