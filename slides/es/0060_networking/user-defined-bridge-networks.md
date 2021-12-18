### Bridge network: definida por usuario

Vamos a crear un _bridge_ definido por usuario:

```bash
> docker network create mi-red
```

Este comando permite especificar la subred, el rango de direcciones IP, la puerta
de enlace y otras opciones ([ver documentación de 
`docker network create`](https://docs.docker.com/engine/reference/commandline/network_create/#specify-advanced-options))

^^^^^^
#### Bridge network: definida por usuario

<img src="../../images/user-defined-bridge.png" alt="user defined bridge" class="plain r-stretch">

^^^^^^

#### Bridge network: definida por usuario

**redes _bridge_ definidas por el usuario proveen un aislamiento mayor que la red _bridge_ por defecto**

^^^^^^

#### Bridge network: definida por usuario

**Mejor aislamiento**

Todos los contenedores conectados un mismo _bridge_ pueden comunicarse entre sí sin restricciones por cualquier puerto
<!-- .element: class="fragment" data-fragment-index="0" -->


Calquier contenedor que no esté contectado al _bridge_ no puede comunicarse con 
ningún contenedor dentro del _bridge_
<!-- .element: class="fragment" data-fragment-index="1" -->

No se expone por defecto ningún puerto del _bridge_ al host
<!-- .element: class="fragment" data-fragment-index="2" -->

^^^^^^

#### Bridge network: definida por usuario

**Provee resolución de nombres de forma automática entre contenedores**

Los contenedores de un mismo bridge pueden resolverse usando el nombre

Si se utiliza el _brige_ por defecto, es necesario:
* usar las IPs de los contenedores
* utilizar la [opción `--link`](https://docs.docker.com/network/links/) 
  que Docker considera obsoleta
* Manipulas las entradas de `/etc/hosts` de los contenedores

notes:

Si utilizamos el _bridge_ por defecto, tendríamos que, de forma manual, encontrar
la manera de que los contenedores se puedan encontrar entre sí. Se podría hacer de
tres maneras:

* La primera es usar las dirección IP de los contenedores, lo que implica usar
  direcciones fijas y saber qué IP va asociada a qué contenedor
* La segunda es usar la [opción `--link`](https://docs.docker.com/network/links/) 
  del comando `docker run`. No entraré en detalle en ella ya que, como he indicado
  en la diapositiva, esta opción se considera deprecated. Aunque nos puede hacer
  el apaño en un momento dado, no se recomienda su uso.
* La tercera consiste en añadir las entradas necesarias en el fichero `/etc/hosts` de los
  contenedores. Esto se puede hacer con la opción 
  [`--add-host`](https://docs.docker.com/engine/reference/run/#network-settings)
  del comando `docker run`

En cualquiera de los tres casos, esto supone una gestión manual de la configuración
de red. Si tienes pocos contenedores, te puedes apañar. Pero en sistemas que escalen
este camino es inviable.

^^^^^^

#### Bridge network: definida por usuario

**Los contenedores se pueden sacar y meter en _bridges_ de manera dinámica**

Sin embargo, para sacar un contenedor del _bridge_ por defecto, es necesario
parar el contenedor

^^^^^^

#### Bridge network: definida por usuario

**Cada _bridge_ definido utiliza su propia configuración**

Todos los contenedores conectados al bridge estándar comparten la configuración 
de red (MTU, reglas `iptables`, etc.)

^^^^^^

### 💻️ Práctica 2: _bridge_ network 💻️

Veamos qué redes tenemos disponibles en docker

```bash
> docker network ls

NETWORK ID          NAME    DRIVER              SCOPE
26507b0d9a52        bridge  bridge              local
7e63dc96ca93        host    host                local
4f9fd21d2de7        none    null                local
```

^^^^^^
#### 💻️ Práctica 2: _bridge_ network 💻️

* Creamos una red `ubuntu-net`

```bash
> docker network create --driver bridge ubuntu-net
```

notes:

En las diapositivas, usaremos la imagen de ubuntu, que no tiene el comando ping
instalado.

Podriamos crear, antes de empezar, una imagen `ubuntu-with-net` usando
este Dockerfile

```Dockerfile
FROM ubuntu
RUN apt update -y && apt install -y iputils-ping
```

y usarlo en la práctica

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

```bash
> docker network ls
NETWORK ID          NAME                                  DRIVER              SCOPE
4574b18c2631        bridge                                bridge              local
7e63dc96ca93        host                                  host                local
4f9fd21d2de7        none                                  null                local
868e6336aa0f        ubuntu-net                            bridge              local
```

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

```bash
docker inspect ubuntu-net
[
    {
        "Name": "ubuntu-net",
        "Id": "868e6336aa0f9434ea29e61c8117673be01e89327ddc282932ab68a2fab21181",
        "Created": "2019-10-09T16:24:48.27933418Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.22.0.0/16",
                    "Gateway": "172.22.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

notes:
Con el comando inspect podemos ver la dirección IP del bridge (rango de red) 
así como confirmar que no tiene contenedores.

Si lo comparamos con el _bridge_ por defecto, veremos que el gateway es diferente

```bash
> docker inspect ubuntu-net

[
    {
        "Name": "ubuntu-net",
        "Id": "868e6336aa0f9434ea29e61c8117673be01e89327ddc282932ab68a2fab21181",
        "Created": "2019-10-09T16:24:48.27933418Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.22.0.0/16",
                    "Gateway": "172.22.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```


^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* Vamos a crear ahora varios contenedores conectados entre sí:

```bash
> docker run -dit --name ubuntu1 --network ubuntu-net ubuntu bash
> docker run -dit --name ubuntu2 --network ubuntu-net ubuntu bash
> docker run -dit --name ubuntu3 ubuntu bash
> docker run -dit --name ubuntu4 --network ubuntu-net ubuntu bash
> docker network connect bridge ubuntu4
```

notes:

Levantamos los contenedores `ubuntu1`, `ubuntu2` y `ubuntu4` conectados
a la red `ubuntu-net``

Levantamos el contenedor `ubuntu3` conectado al _bridge_ por defecto

Conectamos a posteriori el contenedor `ubuntu4` al bridge por defecto usando el
comando `docker network connect`


^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

```bash
docker container ls -f name=ubuntu* 
CONTAINER ID        IMAGE   COMMAND  CREATED        STATUS        PORTS  NAMES
9184fb2b86d5        ubuntu  "bash"   2 minutes ago  Up 2 minutes         ubuntu4
127573d33dd7        ubuntu  "bash"   3 minutes ago  Up 3 minutes         ubuntu3
3df1e39cd371        ubuntu  "bash"   3 minutes ago  Up 3 minutes         ubuntu2
0cdd2bb8dc03        ubuntu  "bash"   3 minutes ago  Up 3 minutes         ubuntu1
```

notes:

Listamos los contenedores que acabamos de crear usando un filtro del comando
`docker container ls`


^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* Si miramos ahora los detalles del _bridge_ por defecto, veremos dos contenedores
  conectados

* Si miramos los detalles del _bridge_ `ubuntu-net` veremos los tres contenedores conectados


```bash
> docker network inspect bridge
...
> docker network inspect ubuntu-net
...
```

notes:

Adjunto la salida de los comando en mi máquina para aquellos que no dispongan de 
una máquina en la que ejecutar los comandos:

#### Default bridge
```bash

docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "4574b18c2631cdcbdf1f7b844eed19e4cd32039c229d57c83cb6933321aafe99",
        "Created": "2019-10-15T15:26:16.101049936Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "127573d33dd78ce5c293bdb33240c312e8d95804ffc0ed7c61590f9d52ff1011": {
                "Name": "ubuntu3",
                "EndpointID": "94f24cd858ba037a1ad8d61e9fab99ecda1357d1cb55a8edbfd9666c93a33ae6",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            },
            "9184fb2b86d5a8ad5653cf79b9b2e85c866389e03f3a4a0b79ae0d4c742ec637": {
                "Name": "ubuntu4",
                "EndpointID": "e633fa6f369df242e70797b826c6c90572fe63edf195063383e77aaa91725549",
                "MacAddress": "02:42:ac:11:00:04",
                "IPv4Address": "172.17.0.4/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

#### `ubuntu-net` bridge

```bash
docker network inspect ubuntu-net
[
    {
        "Name": "ubuntu-net",
        "Id": "868e6336aa0f9434ea29e61c8117673be01e89327ddc282932ab68a2fab21181",
        "Created": "2019-10-15T20:24:48.27933418Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.22.0.0/16",
                    "Gateway": "172.22.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "0cdd2bb8dc039828ef6f1282cecb47f13d2320804d8e750e07553759f8df81db": {
                "Name": "ubuntu1",
                "EndpointID": "c84145c1ab8f9ed2d3eb36244f50b51e5baf4ddd4efd598bd8e5597b9f3fad5e",
                "MacAddress": "02:42:ac:16:00:02",
                "IPv4Address": "172.22.0.2/16",
                "IPv6Address": ""
            },
            "3df1e39cd371d886c127ec8d7c13370a62d6c9f85f488ddda4fee7e02214e66c": {
                "Name": "ubuntu2",
                "EndpointID": "84ab08114d247055d05e0035505ee8a52e9c82db9f325b162f0865ac54102b36",
                "MacAddress": "02:42:ac:16:00:03",
                "IPv4Address": "172.22.0.3/16",
                "IPv6Address": ""
            },
            "9184fb2b86d5a8ad5653cf79b9b2e85c866389e03f3a4a0b79ae0d4c742ec637": {
                "Name": "ubuntu4",
                "EndpointID": "06e4af611ff29dfe9a08f7ce0ed0d03316a41940d8969431c419f0d4fe0df8fd",
                "MacAddress": "02:42:ac:16:00:04",
                "IPv4Address": "172.22.0.4/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* Los contenedores de la red `ubuntu-net` pueden comunicarse por IP o por nombre
  entre sí

```bash
root@0cdd2bb8dc03:> docker container attach ubuntu1

ping -c 2 ubuntu2
PING ubuntu2 (172.22.0.3) 56(84) bytes of data.
64 bytes from ubuntu2.ubuntu-net (172.22.0.3): icmp_seq=1 ttl=64 time=0.150 ms
64 bytes from ubuntu2.ubuntu-net (172.22.0.3): icmp_seq=2 ttl=64 time=0.081 ms

--- ubuntu2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.081/0.115/0.150/0.036 ms
```


notes:

Recuerda que para poder hacer ping, tendrás que instalar el paquete 
`apt update && apt install iputils-ping`

Podemos entrar en el resto de contenedores de este bridge y hacer ping entre
ellos.

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* Los contenedores de la red `bridge` NO pueden comunicarse ni por IP ni por nombre
  con los de la red `ubuntu-net`

```bash
> docker container attach ubuntu3
root@127573d33dd7:> ping -c 2 ubuntu4
ping: ubuntu4: Name or service not known

root@127573d33dd7:ping -c 2 172.17.0.4
PING 172.17.0.4 (172.17.0.4) 56(84) bytes of data.
64 bytes from 172.17.0.4: icmp_seq=1 ttl=64 time=1.97 ms
64 bytes from 172.17.0.4: icmp_seq=2 ttl=64 time=0.079 ms

--- 172.17.0.4 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.079/1.027/1.975/0.948 ms

```

notes:

En el _bridge_ por defecto, podemos hacer ping directamente a la IP, pero no
podemos usar el nombre.

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* Desde los contenedores de la red `ubuntu-net` NO podemos llegar a los contenedores
  del _bridge_ por defecto

```bash
> docker attach ubuntu1
root@0cdd2bb8dc03:> ping -c 2 ubuntu3
ping: ubuntu3: Name or service not known

root@0cdd2bb8dc03:> ping -c 2 172.17.0.3
PING 172.17.0.3 (172.17.0.3) 56(84) bytes of data.

--- 172.17.0.3 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1018ms
```

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* El contenedor `ubuntu4` está conectado a `bridge` y a `ubuntu-net`
  por lo que deberíamos poder hacer ping a todos los contenedores

```bash
> docker attach ubuntu4
root@9184fb2b86d5:> ping -c 2 ubuntu1
...
```

^^^^^^

#### 💻️ Práctica 2: _bridge_ network 💻️

* Todos los contenedores deberían tener acceso a internet. Para probarlo:

```bash
> docker attach ubuntu1
ping -c 2 www.google.com
```

notes:

Puede ser que en Docker for Mac, este último ping no funcione, 
[ver este issue en github](https://github.com/docker/for-mac/issues/57).

como se indica ahí, probar a reiniciar la máquina. Si sigue sin funcionar,
se puede comprobar la conectividad de una forma alternariva, por ejemplo usando
curl:

```bash
> docker attach ubuntu1
root@127573d33dd7:> apt install -y curl
root@127573d33dd7:> curl https://www.google.com
``` 
