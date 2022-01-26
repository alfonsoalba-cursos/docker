### Recursos

Podemos limitar los siguientes recursos utilizados por un contenedor:

* Memoria
* CPU
* Ancho de banda I/O

[Documentación de docker sobre limitación de recursos en tiempo de ejecución](https://docs.docker.com/engine/reference/run/#runtime-constraints-on-resources)

^^^^^^

#### Limitación de memoria `--memory` y `--memory-swap`

| --memory | --memory-swap |
| -------- | ------------- |
| inf | inf |

El contenedor puede usar tanta memoria como necesite.

```shell
$ docker container run --rm -p "8002:80" kubernetescourse/slides-docker
```

notes:

La cantidad de swap que el contenedor usará será `memory - memory-swap`.


^^^^^^

#### Limitación de memoria `--memory` y `--memory-swap`

| --memory | --memory-swap |
| -------- | ------------- |
| L | -1 |

El contenedor tiene un límite de memoria L y puede usar tanta swap como necesite

(simpre que el uso de swap esté activo)

```shell
$ docker container run  --memory 25M --memory-swap -1 --rm -p "8002:80" kubernetescourse/slides-docker
```

notes:

En el comando de ejemplo, ponemos un límite de memora de 25MB y tanta memoria swap como necesite.


^^^^^^

#### Limitación de memoria `--memory` y `--memory-swap`

| --memory | --memory-swap |
| -------- | ------------- |
| L | 2*L |

Si sólo se especifica el parámetro `--memory`, se utilizará el doble de memoria especificada como swap

```shell
$ docker container run  --memory 25M --rm -p "8002:80" kubernetescourse/slides-docker
```

notes:

En el ejemplo, el contenedor tendrá un límite de 25MB de memoria y 25MB de swap.


^^^^^^

#### Limitación de memoria `--memory` y `--memory-swap`

| --memory | --memory-swap |
| -------- | ------------- |
| L | S (L<=S) |

Se limita tanto la swap como la memoria a los valores especificados

```shell
$ docker container run  --memory 25M --memory-swap 35M --rm -p "8002:80" kubernetescourse/slides-docker
```

notes:

En el ejemplo, el contenedor tendrá un límite de 25MB de memoria y 10MB de swap.

^^^^^^

#### Limitación de memoria `--memory` y `--memory-swap`

[`Your kernel does not support cgroup swap limit capabilities`](https://docs.docker.com/engine/install/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities)

Warning que sale en Debian/Ubuntu: swap desactivada por defecto en los cgroups.

Se puede ignorar si no queremos utilizar estas _capabilities_ del kernel

Se puede activar en el gestor de arranque `grub` usando

```text
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"

```

^^^^^^

#### Limitación de memoria `--memory-reservation`

Límite blando de memoria que facilita la tarea de reservar memoria entre los contenedores.

```shell
$ docker container run  --memory 250M --memory-reservation 500M --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor podrá usar hasta 500M de memoria. 

Si docker detecta que empieza a faltar memoria en el sistema, entonces limitará la memoria a 250M

^^^^^^

#### Limitación de memoria `--memory-reservation`

`memory-reservation <= memory`

Si lo hacemos mayor, el valor de `--memory` tendrá preferencia

^^^^^^

#### Limitación de memoria `--oom-kill-disable`

Evita que un contenedor reciba la señal `OOM` del kernel

**Siempre que activemos esta opción, utilizar `--memory` para limitar la memoria**

notes:

Si no lo hacemos, el sistema operativo no podrá matar el contenedor y, si se queda sin memoria,
empezará a eliminar procesos del sistema

^^^^^^

#### Limitación de memoria `--kernel-memory`

La memoria del kernel incluye:
* stack pages
* slab pages
* sockets
* tcp

Esta memoria no se puede pasar a la swap

Limitando el `kernel-memory` de los contenedores, podemos evitar que ciertos procesos se
lancen si el uso de memoria del kernel es alto

^^^^^^

#### Limitación de memoria `--kernel-memory`

```shell
$ docker container run  --memory 500M --kernel-memory 50M --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor usará 500M de memoria. De estos 500M, un máximo de 50M se podrán usar
para la memoria del kernel

^^^^^^

#### Limitación de memoria `--kernel-memory`

```shell
$ docker container run  --kernel-memory 50M --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor usará toda la memoria que necesite. Dispondrá de un máximo de 50M 
para la memoria del kernel

^^^^^^

#### Limitación de memoria `--memory-swappiness`

Porcentage de memoria del contenedor que se puede pasar a swap

Valor entre 0 y 100

^^^^^^

#### Limitación de CPU `--cpu-shares`

El valor por defecto es de `1024`

Todos los contenedores reciben la misma proporción de ciclos de procesador

Podemos reducir esta proporción usando `--cpu-shares`

**La proporción solo se aplica cuando se ejecutan procesos que usan intensivamente la CPU**

Si el sistema tiene suficiente CPU, no se aplican límites.

^^^^^^

#### Limitación de CPU `--cpu-shares`

* `C1` -> 1024
* `C2` -> 512
* `C3` -> 512

Si los procesos en los contenedores intentan usar el 100% de la CPU,
el primero recibirá el 50% y los otros dos el 25% cada uno

^^^^^^

#### Limitación de CPU `--cpu-shares`

* `C1` -> 1024
* `C2` -> 512
* `C3` -> 512
* `C4` -> 1024

`C1` y `C4` recibirán el 33% de CPU (1024/3072) y `C2` y `C3` recibirán un 
16% (512/3072)

^^^^^^

#### Limitación de CPU `--cpu-period` y `--cpu-quota`

Permiten configurar el uso de 
[_CPU CFS (Completely Fair Scheduler)_](https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt)


```shell
$ docker container run  --cpu-period=50000 --cpu-quota=25000 --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor recibirá un 50%  (25000/50000) de CPU cada 50ms

notes:

`cpu-period` y `cpu-quota` se miden en microsegundos.

^^^^^^

#### Limitación de CPU `--cpu-period` y `--cpu-quota`

Permiten configurar el uso de 
[_CPU CFS (Completely Fair Scheduler)_](https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt)


```shell
$ docker container run  --cpu-period=500000 --cpu-quota=1000000 --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor recibirá un 2 CPUs cada 500ms


^^^^^^

#### Limitación de CPU `--cpus`

Permite asignar un límite de CPUs usando porcentages en lugar de usando `--cpu-period` y `--cpu-quota`

```shell
$ docker container run  --cpus 0.5 --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor utilizará un 50% de una CPU

^^^^^^

#### Limitación de CPU `--cpuset-cpus`

Nos permiten seleccionar en qué CPU se ejecuta el contenedor

```shell
$ docker container run  --cpuset-cpus="1,3" --rm -p "8002:80" kubernetescourse/slides-docker
```

El contenedor se ejecuta en las CPUs 1 y 3


^^^^^^

#### Limitación de CPU `--blkio-weight`

Controla la proporción de ancho de banda IO que recibe cada contenedor

Valor entre 10 y 1000. El valor por defecto es 500

^^^^^^

#### Limitación de CPU `--blkio-weight`

```shell
$ docker run -it --name c1 --blkio-weight 300 ubuntu:14.04 /bin/bash
$ docker run -it --name c2 --blkio-weight 600 ubuntu:14.04 /bin/bash
```

Si dentro de estos contenedores ejecutamos un

```shell
$ time dd if=/mnt/zerofile of=test.out bs=1M count=1024 oflag=direct
```

El primer contenedor recibirá la mitad de ancho de banda IO que el segundo