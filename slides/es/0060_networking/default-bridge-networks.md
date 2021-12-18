### bridge networks

Docker utiliza un _bridge_ por software que permite a todos los contenedores conectados a ese _bridge_ comunicarse entre sí

Los contenedores conectados a ese _bridge_ quedan aislados del resto de
contenedores y del host: pueden comunicarse entre sí pero el resto de contenedores no pueden comunicarse con ellos

El driver _bridge_ de docker funciona instalando las reglas necesarias en el 
host que permiten este aislamiento

^^^^^^

### bridge networks

Las redes que usan este driver se utilizan para **contenedores que están en el 
mismo host**

Si los contenedores están en diferentes hosts, debemos utilizar una red con el 
driver _overlay_

^^^^^^

### bridge networks

Dos tipos de redes bridge en docker:

* red _bridge_ por defecto (_default bridge_)
* red _bridge_ definidas por el usuario (_user-defined bridge_)

^^^^^^

### bridge networks: _default bridge_

Se considera una característica _legacy_ de docker 

A día de hoy y **no se recomienda su uso**

Cuando se levanta `dockerd`, se crea esta red _bridge_ por defecto y cualquier 
contenedor que creemos se conectará a ella por defecto (a no ser que especifiquemos lo contrario)

notes:

En las siguientes diapositivas, crearemos un red _bridge_ definida por nosotros
y comentaremos las limitaciones que tiene la red _bridge_ por defecto

^^^^^^

### 💻️ Práctica 1: default bridge network 💻️

Veamos qué redes tenemos disponibles en docker

```bash
> docker network ls

NETWORK ID          NAME    DRIVER              SCOPE
26507b0d9a52        bridge  bridge              local
7e63dc96ca93        host    host                local
4f9fd21d2de7        none    null                local
```

notes:

Aquí vemos la red _bridge_ por defecto, la red _host_ que hemos mencionado 
en al empezar este módulo y que nos permite conectar el contenedor a la red
del host, y la red _none_

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️


* Lanzamos dos contenedores ubuntu:

```bash
> docker run -dit --name ubuntu1 ubuntu bash
> docker run -dit --name ubuntu2 ubuntu bash
```

* Como no le hemos indicado parámetro `--network` ambos contenedores se están
conectando a la red _bridge_ por defecto

notes:

Las opciones -d y -ti ya deberían ser familiares para todos a estas alturas:
* `-ti` abre el contenedor en modo interactivo y conectado a una TTY
* `-d` lo lanza en segundo plano

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️


* Vamos a inspeccionar la red _bridge_ por defecto:

```bash
> docker network inspect bridge
[
    {
      ...
        "Containers": {
            "1b81e2ec6893368e859148ba76493689ad62554db03297b6258768f4e1ebbfe2": {
                "Name": "ubuntu2",
                "EndpointID": "dad754408e282a7a151410ad99286519fe4999ac64b44a66d7276755d068895d",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            },
            "b6d3d38fd938a614e945feacb03093aa7b61919f79f7face6a2a1689185cbd3e": {
                "Name": "ubuntu1",
                "EndpointID": "2e0beb913cf74ad354d7ce05033ff6c67ac4a373da4bc669d210d1f6d51bd67e",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            }
        },    
      ...  
    }  
]
```

notes:

En la sección "Containers" podremos ver los dos contenedores que acabamos de 
conectar.

Entre otra información, podemos ver la dirección de red asignada a los contenedores.

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️

* Nos conectamos al primer contenedor

```bash
> docker attach ubuntu1
root@b6d3d38fd938 > ip addr

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
3: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN group default qlen 1000
    link/tunnel6 :: brd ::
12: eth0@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```

notes:

La imagen docker de ubuntu no incluye los comandos `ip` ni `ping`. Para instalarlo:

```bash 
> apt update
> apt install iproute2 iputils-ping
```

El resultado del comando `ip addr` nos da la ip del contenedor.

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️

* verificamos que tenemos salida a internet:

```bash
root@b6d3d38fd938 > ping -c 2 google.com
```

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️

* Mirando la salida del comando `docker network inspect bridge`, averiguamos
  la IP del segundo contenedor

* Hacemos un ping para comprobar que podemos llegar a él:

```bash
root@b6d3d38fd938 > ping -c 2 172.17.0.3
```

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️

* Si ahora intentamos hacer ping a `ubuntu2` usando el nombre, no podemos

```bash
root@b6d3d38fd938 > ping ubuntu2
ping: ubuntu2: Name or service not known
```

^^^^^^

#### 💻️ Práctica 1: default bridge network (cont.) 💻️

* Desconectate del contenedor usando `CTRL + p` y luego `CTRL + q`

* Para los contenedores `ubuntu1` y `ubuntu2` y elimínalos

```bash
> docker container stop ubuntu1 ubuntu2
> docker container rm ubuntu1 ubuntu2
```
