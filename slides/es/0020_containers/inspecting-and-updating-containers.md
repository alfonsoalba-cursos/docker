### Actualizando parámetros de un contenedor

El comando [`docker container inspect`]() nos da información detallada de un contenedor

```bash
> docker container inspect [CONTAINER ID OR NAME]
```

^^^^^^

### 💻 Práctica 💻

* Crea el contenedor correspondiente a este módulo del curso (si no lo has creado)

```bash
> docker container run --rm --name modulo2 -d becorecode/curso-intro-docker-modulo-2
```

* Muesta toda la información del contenedor usando 

```bash
> docker container inspect [CONTAINER ID OR NAME]
```

notes:

Al ejecutar el comando [`docker container inpect`](https://docs.docker.com/engine/reference/commandline/container_inspect/)

```bash
> docker container stats modulo2


[
    {
        "Id": "3d7388b598a29079acf363775db061489099e0dc0d954c56ad8e08edf121515f",
        "Created": "2019-10-06T07:58:49.734142Z",
        "Path": "docker-entrypoint.sh",
        "Args": [
            "npm",
            "start",
            "--",
            "--port=${APP_PORT}"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 97327,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2019-10-06T07:58:50.123289Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:16eac7f82f2a82ca2c9ddd5de3de04ef095702c0b9ce270b753cb5aea96aed5d",
        "ResolvConfPath": "/var/lib/docker/containers/3d7388b598a29079acf363775db061489099e0dc0d954c56ad8e08edf121515f/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/3d7388b598a29079acf363775db061489099e0dc0d954c56ad8e08edf121515f/hostname",
        "HostsPath": "/var/lib/docker/containers/3d7388b598a29079acf363775db061489099e0dc0d954c56ad8e08edf121515f/hosts",
        "LogPath": "/var/lib/docker/containers/3d7388b598a29079acf363775db061489099e0dc0d954c56ad8e08edf121515f/3d7388b598a29079acf363775db061489099e0dc0d954c56ad8e08edf121515f-json.log",
        "Name": "/modulo2",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": true,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Capabilities": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/9ae489ee50197cde1fd75be8e88060fd5f9f0461e63e3a77d2af20c09eabf54b-init/diff:/var/lib/docker/overlay2/aed8695b4a92cd955ef1b523ca3145096bea026516e259b2f936e6fef87b4610/diff:/var/lib/docker/overlay2/fcc06b38d219faae623c88c28398c0044caecb0bc5236e414b5042a490da6c9f/diff:/var/lib/docker/overlay2/71ac683ce4fff8e8020cab8cac58eb5f4f4f7b8e3bec189e83b56d680e58b82a/diff:/var/lib/docker/overlay2/a2869cfdc1475f6089cf70455477f71b65981fcc8d71b701bfe4069594a4a6a8/diff:/var/lib/docker/overlay2/564068f51088adeefac42ec28c5d6be2512d05fb876b07b389d3c6ebe29a5ed3/diff:/var/lib/docker/overlay2/b8c610e70e89aba0a508166e08d428445679cf5841306be6be7bd6bfb702872c/diff",
                "MergedDir": "/var/lib/docker/overlay2/9ae489ee50197cde1fd75be8e88060fd5f9f0461e63e3a77d2af20c09eabf54b/merged",
                "UpperDir": "/var/lib/docker/overlay2/9ae489ee50197cde1fd75be8e88060fd5f9f0461e63e3a77d2af20c09eabf54b/diff",
                "WorkDir": "/var/lib/docker/overlay2/9ae489ee50197cde1fd75be8e88060fd5f9f0461e63e3a77d2af20c09eabf54b/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "3d7388b598a2",
            "Domainname": "",
            "User": "node",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "8002/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NODE_VERSION=10.16.3",
                "YARN_VERSION=1.17.3",
                "APP_PATH=/home/node",
                "APP_PORT=8002"
            ],
            "Cmd": [
                "npm",
                "start",
                "--",
                "--port=${APP_PORT}"
            ],
            "Image": "becorecode/curso-intro-docker-modulo-2",
            "Volumes": null,
            "WorkingDir": "/home/node",
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "com.becorecode.author": "Alfonso Alba García",
                "com.becorecode.author_email": "hola@becorecode.com"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "c6db179c75b9aa50bc759e6184c25cb9b671659300559cce0f73cd78c3832fc2",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "8002/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/c6db179c75b9",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "2f9449ed43c92d0445ae10c7e1d3eb417d742dcc8e277461b0d968834a12f0f5",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "a6650bf208dfb1a8cd02099d92f8783c7be5f0c971f6b8b6439763a25f641d26",
                    "EndpointID": "2f9449ed43c92d0445ae10c7e1d3eb417d742dcc8e277461b0d968834a12f0f5",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

De toda la información que nos da el comando `docker container inspect`, voy a destacar la siguiente:

* En la sección `Config`, podemos encontrar algunas respuestas a preguntas que nos hemos planteado ya, como por ejemplo
  * con qué usuario se está ejecutando el proceso del contenedor
  * qué comando se ejecuta al levantarlo
  * Qué variables de entorno se han definido al ejecutar el comando
  * Qué imagen está usando el contenedor
  * Cuál es el _working directory_ por defecto
* En la sección `State` vemos que el estado del contenedor es `running`
* En la sección `NetworkSettings` vemos la configuración del contenedor como por ejemplo su dirección IP o la dirección MAC de su interfaz de red

^^^^^^

### Actualizar los parámetros del contenedor

* Muchos de estos valores se pueden configurar a la hora de crear el contenedor con el comando `docker container run` o `docker contaniner create`
* En la documentación de estos comandos tenéis todas las opciones disponibles ([aquí](https://docs.docker.com/engine/reference/commandline/container_run/) y [aquí](https://docs.docker.com/engine/reference/commandline/container_create/))
* Vamos a ver cómo se pueden manipular estos parámetros una vez creado el contenedor

^^^^^^

### 💻 Práctica 💻

* Vamos a usar un comando nuevo, [`docker container stats`](https://docs.docker.com/engine/reference/commandline/container_stats/)
  para ver cuánta memoria consume nuestro contenedor
* Levantamos el contenedor si no lo tenemos levantado **sin usar la opción `--rm`**

```bash
> docker container run --name modulo2 -p "8002:8002" -d becorecode/curso-intro-docker-modulo-2
```

^^^^^^

#### 💻 Práctica (cont.) 💻

* Vemos cuánta memoria consume el contenedor

```bash
> docker container stats modulo2

CONTAINER ID  NAME     CPU %  MEM USAGE / LIMIT     MEM %   NET I/O     BLOCK I/O   PIDS
3d7388b598a2  modulo2  1.71%  89.73MiB / 8.752GiB   1.00%   1.68kB / 0B 0B / 4.1kB  22
```
 * Vemos que este contenedor consume unos 90MiB de memoria

^^^^^^

#### 💻 Práctica (cont.)  💻

* Paramos el contenedor

```bash
> docker container stop modulo2
```

* Limitamos la memoria del contenedor a unos 50MiB

```bash
> docker container update --memory 524288000 --memory-swap 0 modulo2
```

* Intentar iniciar el contenedor

```bash
> docker container start modulo2
> docker container list
```

* ...el contenedor no está porque no tiene memoria para ejecutarse

notes:

Para ver que el motivo por el que el contenedor no se ha ejecutado, debemos mirar el log de `dockerd`.

[La documentación de docker](https://docs.docker.com/config/daemon/#read-the-logs) nos indica dónde podemos localizar el log en cada plataforma.

En OSX, yo uso el siguiente comando:

```bash
log stream --predicate 'eventMessage contains "docker"'
```


Observaremos un error parecido al siguiente:

```
2019-10-06 12:57:33.928398+0200 0x1f0f     Default     0x0                  737    0    com.docker.hyperkit: [47517.500417] Task in /docker/3536ff965e8d1a2c6f4448b08dd2e1d59e1008ac1bf2d53ff46cb05da5563f29 killed as a result of limit of /docker/3536ff965e8d1a2c6f4448b08dd2e1d59e1008ac1bf2d53ff46cb05da5563f29
2019-10-06 12:57:33.938064+0200 0x1f0f     Default     0x0                  737    0    com.docker.hyperkit: [47517.508260] Memory cgroup stats for /docker/3536ff965e8d1a2c6f4448b08dd2e1d59e1008ac1bf2d53ff46cb05da5563f29: cache:0KB rss:46952KB rss_huge:0KB shmem:0KB mapped_file:0KB dirty:0KB writeback:0KB swap:0KB inactive_anon:23552KB active_anon:23388KB inactive_file:0KB active_file:0KB unevictable:0KB
```

^^^^^^

Más información sobre configuración de memoria, CPU y GPU en los contenedores:

[Runtime options with Memory, CPUs, and GPUs](https://docs.docker.com/config/containers/resource_constraints/)

En este enlace se explica una buena cantidad de las opciones que se muestran en `docker container create`