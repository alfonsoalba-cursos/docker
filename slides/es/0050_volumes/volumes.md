### Volúmenes

![volúmenes](../../images/types-of-mounts-volume.png)

^^^^^^

### Volúmenes

Son el mecanismo recomendado y preferido para persistir datos en los contenedores

* No incrementan el tamaño del contenedor, cosa que sí ocurre si escribimos sobre el _container layer_
* El volumen existe siempre, no depende del ciclo de vida del contenedor

^^^^^^

#### ¿Porqué volúmenes en lugar de _bind mounts_?

* Es más fácil hacer copias de respaldo y recuperarlas
* Se pueden gestionar utilizando la línea de comandos o la API de docker
* Funcionan tanto en contenedores Linux como Windows
* Los _drivers_ nos permiten almacenar la información en hosts remotos, en proveedores cloud
  e incluso encriptar el contenido.

^^^^^^

### Uso: `-v` o `--mount`

Existen dos maneras de configurar los volúmenes al crear un contenedor:

* `-v` ó `--volume`
* `--mount`

notes:

Mi experiencia es que la syntaxis de `-v` es más cómoda para configuraciones sencillas.
Cuando la configuración del volumen es más compleja, la opción --mount es más clara.

^^^^^^

### Uso: `-v` o `--mount`

```shell
$ docker run -v [NOMBRE VOLUMEN]:[RUTA EN EL CONTENEDOR]:[OPCIONES]
```

```shell
$ docker run --rm -v nginx-data:/var/www/ nginx
```

^^^^^^

### Uso: `-v` o `--mount`

```shell
$ docker run --mount [key=value],...
```

```shell
$ docker run --rm --mount 'type=volume,src=nginx-data,dst=/var/www/' nginx
```

notes:

`--mount` acepta las siguientes opciones:

* `type` que puede ser `bind`, `volume`, or `tmpfs`
* `source`: para volúmenes, esta opción indica el nombre del volumen. Si no se pone nombre
  se crea un volume anónimo y es docker quién le asigna un nombre. Se puede usar `src` como alternativa.
* `destination` ruta dentro del contenedor en la que montar el volumen. Se puede usar `dst` o
  `target`.
* `readonly` una opción que, si está presente monta el _bind mount_ en modo solo lectura
* `volume-opt` opción que se puede especificar más de una vez y que permite pasarle opciones al
  driver que se esté utilizando

[Choose the -v or --mount flag](https://docs.docker.com/storage/volumes/choose-the--v-or---mount-flag)

^^^^^^

### Comandos para la gestión de volúmenes

* Crear un volumen

```shell
$ docker volume create [NOMBRE]
```

notes:

[Más información: Create and manage volumes](https://docs.docker.com/storage/volumes/create-and-manage-volumes)


^^^^^^

### Comandos para la gestión de volúmenes

* Ver todos los volúmenes

```shell
$ docker volume ls
```

^^^^^^

### Comandos para la gestión de volúmenes

* Ver los detalles de un volumen

```shell
$ docker volume inspect [NOMBRE]
```

^^^^^^

### Comandos para la gestión de volúmenes

* Borrar un volumen

```shell
$ docker volume rm [NOMBRE]
```

No se puede borrar un volumen que está vinculado a un contenedor

^^^^^^

### Comandos para la gestión de volúmenes

* Borrar todos los volúmenes que no se están usando

```shell
$ docker volume prune
```

^^^^^^

### 💻 Práctica 1 💻 ️

Extraer las dipositivas del curso para poder reutilizarlas en otros contenedores

* Creamos el volumen `diapositivas_docker`

```shell
$ docker volume create diapositivas_docker
```

* Creamos un nuevo contenedor a partir de la imagen original utilizando 
  el volumen que acabamos de crear:

```shell
$ docker run -p "8005:80" \
         -d \
         --name practica_modulo_5 \
         --mount "type=volume,src=diapositivas_docker,dst=/usr/share/nginx/html" \
         kubernetescourse/slides-docker
```

notes:

Esto crea un contenedor, habilita el puerto 8005 del host para ver las diapositivas
y monta el volumen `diapositivas_docker` en la carpeta `/usr/share/nginx/html`
del contenedor

Podemos verificar que todo funciona abriendo el navegador y accediendo a `localhost:8005`

Dado que el volumen `diapositivas_docker` está vacío y la carpeta 
`/usr/share/nginx/html` del contenedor no, **este comando copia los ficheros y carpetas
de `/usr/share/nginx/html` al volumen**


Si entramos en el contenedor con `bash` podemos ver el volumen con el comando `mount`

```shell

$ docker exec -ti practica_modulo_5 bash

root@027de5e91568:/ mount 

overlay on / type overlay (rw,relatime,lowerdir=/var/lib/docker/overlay2/l/2BDNRDYZY3ITVTK2IGZQCI7E7U:/var/lib/docker/overlay2/l/CWYHBB2EXYNIHOEZRYW6QLHKDI:/var/lib/docker/overlay2/l/7RJKVQQEHTX47SGRLOJLUXP7KD:/var/lib/docker/overlay2/l/LD5TNCKOUSQSCBAEAS5VA52JAH:/var/lib/docker/overlay2/l/2OLDCTDK7OB3Z6IRL5XPCC7VST:/var/lib/docker/overlay2/l/EZPIWNACSHJOME2W67MV6CY2F4:/var/lib/docker/overlay2/l/7HBGN6BWQFUWHT64IJXJELZWXP:/var/lib/docker/overlay2/l/DOF2O65WYXP4IIPZJKHPBDM7IJ,upperdir=/var/lib/docker/overlay2/7fbbdaf35efeb2ed2fc5f5420934790d56e05895318d495c230b6a63e7315446/diff,workdir=/var/lib/docker/overlay2/7fbbdaf35efeb2ed2fc5f5420934790d56e05895318d495c230b6a63e7315446/work,xino=off)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev type tmpfs (rw,nosuid,size=65536k,mode=755)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=666)
sysfs on /sys type sysfs (ro,nosuid,nodev,noexec,relatime)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (ro,nosuid,nodev,noexec,relatime,xattr,name=systemd)
cgroup on /sys/fs/cgroup/devices type cgroup (ro,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (ro,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/cpuset type cgroup (ro,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (ro,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (ro,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/memory type cgroup (ro,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/blkio type cgroup (ro,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/rdma type cgroup (ro,nosuid,nodev,noexec,relatime,rdma)
cgroup on /sys/fs/cgroup/pids type cgroup (ro,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/perf_event type cgroup (ro,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/freezer type cgroup (ro,nosuid,nodev,noexec,relatime,freezer)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime)
shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime,size=65536k)
/dev/vda1 on /etc/resolv.conf type ext4 (rw,relatime,errors=remount-ro)
/dev/vda1 on /etc/hostname type ext4 (rw,relatime,errors=remount-ro)
/dev/vda1 on /etc/hosts type ext4 (rw,relatime,errors=remount-ro)
────────────
/dev/vda1 on /usr/share/nginx/html type ext4 (rw,relatime,errors=remount-ro)
────────────
proc on /proc/bus type proc (ro,nosuid,nodev,noexec,relatime)
proc on /proc/fs type proc (ro,nosuid,nodev,noexec,relatime)
proc on /proc/irq type proc (ro,nosuid,nodev,noexec,relatime)
proc on /proc/sys type proc (ro,nosuid,nodev,noexec,relatime)
proc on /proc/sysrq-trigger type proc (ro,nosuid,nodev,noexec,relatime)
tmpfs on /proc/acpi type tmpfs (ro,relatime)
tmpfs on /proc/kcore type tmpfs (rw,nosuid,size=65536k,mode=755)
tmpfs on /proc/keys type tmpfs (rw,nosuid,size=65536k,mode=755)
tmpfs on /proc/timer_list type tmpfs (rw,nosuid,size=65536k,mode=755)
tmpfs on /proc/sched_debug type tmpfs (rw,nosuid,size=65536k,mode=755)
tmpfs on /proc/scsi type tmpfs (ro,relatime)
tmpfs on /sys/firmware type tmpfs (ro,relatime)
```
^^^^^^

#### 💻 Práctica 1 (cont.) 💻 ️

* Si inspeccionamos el volumen:

```shell
$ docker volume inspect diapositivas_docker
[
    {
        "CreatedAt": "2019-10-13T10:48:42Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/diapositivas_docker/_data",
        "Name": "diapositivas_docker",
        "Options": {},
        "Scope": "local"
    }
]
```

notes:

Si estáis en una máquina Linux, podéis ver el contenido del contenedor en la carpeta
`/var/lib/docker/volumes/diapositivas_docker/_data`

Podemos ver el volumen que está usando el contenedor utilizando `docker container inspect`

```shell
$ docker container inspect practica_modulo_5 --format '{{json .Mounts}}'
```

Mirando el contenido de la carpeta `/var/lib/docker/volumes/diapositivas_docker/_data`
vemos cómo el volumen que estaba vacío se ha llenado con el contenido de la imagen.

^^^^^^

#### 💻 Práctica 1 (cont.) 💻 ️

* Ahora creamos un contenedor (usando la imagen de `ubuntu`) y vamos 
a ver las diapositivas desde ese otro contenedor:

```shell
$ docker run --rm -ti \
         --name practica_modulo_5_segundo_contenedor \
         --mount "type=volume,src=diapositivas_docker,dst=/mnt/slides" \
         ubuntu:latest \
         bash   
root@965d5e539caa:/ ls
50x.html  README.md  dist  examples     images      js                 package.json
LICENSE   css        es    gulpfile.js  index.html  package-lock.json  plugin
```

^^^^^^

#### 💻 Práctica 1 (cont.) 💻 ️

* Creamos una nueva diapositiva desde el contenedor 
  `practica_modulo_5_segundo_contenedor`

```shell
root@965d5e539caa:/ echo "### Nueva diapositiva" > /mnt/slides/es/0050_volumes/nueva_diapositiva.md
```

* Si volvemos al contenedor `practica_modulo_5` y listamos la carpeta
  `/usr/share/nginx/html/slides/es/0050_volumes`, veremos el nuevo fichero

```shell
$ docker exec -ti practica_modulo_5 bash
root@027de5e91568:/ ls /usr/share/nginx/html/es/0050_volumes/nueva_diapositiva.md 
/usr/share/nginx/html/es/0050_volumes/nueva_diapositiva.md
```

^^^^^^

### Volúmenes anónimos

Podemos crear un volumen anónimo de la siguiente manera:

```shell
$ docker run --rm -v /test -v data:/data ubuntu top
```

* Se crea un volumen anónimo y se monta en `/test` dentro del contenedor
* Se crea un volumen `data` y se monta en la carpeta `/data` dentro del contenedor

notes:

Al parar el contenedor, la opción `--rm` hace que se borre tanto el contenedor
como el volumen anónimo. El volumen `data` no se borra y podremos verlo
usando el comando `doker volume ls`

Si entramos en el contenedor con `bash` podemos ver el volumen con el comando `mount`

^^^^^^

### Limpieza

Usando los comandos `docker ps`, `docker stop` y  `docker rm`, eliminar los contenedores
y volúmenes que hemos utilizado en esta sección

```shell
$ docker container stop practica_modulo_5
$ docker conatiner rm practica_modulo_5
$ volume rm diapositivas_docker
```
