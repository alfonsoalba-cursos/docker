### 💻️ Práctica 1: Wordpress Swarm

Objetivo: levantar _swarm_ con MySQL y Wordpress

notes:

En esta práctica levantaremos un wordpress utilizando los comandos de docker
swarm descritos en la [sección CLI](/#cli)

^^^^^^

#### 💻️ Práctica 1: Wordpress Swarm

Requisitos previos:

* Crear tres máquinas virtuales con tu distribución de Linux favorita (Alpine Linux)
* Estas tres máquinas deben tener los siguientes requisitos y paquetes instalados:
  * Kernel 4 o 5 (soporte para docker)
  * Docker correctamente instalado
  * Acceso por ssh para poder ejecutar comandos en las diferentes máquinas
  * Red común que permita a las tres máquinas virtuales verse entre sí

notes:

Para el curso, utilizaremos tres máquinas virutales corriendo sobre VMWare Fusion
sobre un MacBook Pro de 2014.

Los pasos para realizar la instalación de docker fueron:
* Descargar la imagen iso de Alpine Linux
* Crear tres máquinas virtules con los los siguientes nombres y direcciones IP:
  * `192.168.1.200` -> `manager`
  * `192.168.1.201` -> `worker1`
  * `192.168.1.202` -> `worker2`
* Activar el acceso ssh por contraseña para root, editando el fichero 
  `/etc/ssh/sshd_config` y activando la opción `PermitRootLogin yes`
  * Aunque esta configuración es insegura y nada recomendable en producción, 
    es lo más rápido y efectivo para hacer prácticas en laboratorio
* Instalar docker
  * Editar el fichero `/etc/apk/repositories`
  * Activar el respositorio community
  * `apk update`
  * `apk add docker`
  * `service docker start`
  * `rc-update add docker boot`
  * Para poder levantar el servicio `docker`, puede ser necesario que añadas la 
    siguiente línea al fichero `/etc/fstab`
     ```
     cgroup    /sys/fs/cgroup   cgroup  defaults 0 0
     ```


^^^^^^

#### 💻️ Práctica 1: Crear el manager

* Acceder a la máquina `manager`
* Iniciar el _swarm_ con el comando 
  [`docker swarm init`](https://docs.docker.com/engine/reference/commandline/swarm_init/)

```bash
manager > docker swarm init --advertise-addr 192.168.1.200 --availability drain

Swarm initialized: current node (f47rcyq97vpxlqx0vz0oyx4p4) 
is now a manager.

To add a worker to this swarm, run the following command:

docker swarm join --token SWMTKN-1-4hns... 192.168.1.200:2377

To add a manager to this swarm, run 
'docker swarm join-token manager' and follow the instructions.
```

^^^^^^

#### 💻️ Práctica 1: Crear el manager

* La opción 
  [`--advertise-addr`](https://docs.docker.com/engine/reference/commandline/swarm_init/#--advertise-addr) 
  Especifica la dirección IP que se publicará para que otros nodos del cluster
  accedan a la API o a la red `overlay`
  * Si sólo se dispone de una dirección IP, se puede omitir
  * Si hay más de una dirección IP, el uso de la opción es obligatorio
* La opción [`--availability drain`](https://docs.docker.com/engine/reference/commandline/swarm_init/#--availability) 
  indica que el _manager_ no actuará como worker
  (ver [aquí más información al respecto](https://docs.docker.com/engine/swarm/admin_guide/#run-manager-only-nodes))


^^^^^^

#### 💻️ Práctica 1: Crear los workers

* Acceder a la máquina `worker1`
* Añadir el worker al _swarm_ utilizando el comando 
  [`docker swarm join`](https://docs.docker.com/engine/reference/commandline/swarm_join/)

```bash
worker1 > docker swarm join --token SWMTKN-1-4hns... 192.168.1.200:2377
This node joined a swarm as a worker
```

* Repetir el procedimiento en el `worker2`

^^^^^^
#### 💻️ Práctica 1: Crear los workers

* Cuando creamos el _swarm_ se generan dos tokens para poder añadir nuevos nodos
  * un token para añadir _workers_
  * un token para apadir _managers_
* El comando [`docker swarm join-token`](https://docs.docker.com/engine/reference/commandline/swarm_join-token/) 
  nos facilita los tokens necesarios
  para añadir un nodo con cada uno de los roles  

^^^^^^

#### 💻️ Práctica 1: Estado del _swarm_

* En el manager, utilizamos el comando `docker node ls` para ver los nodos disponibles
  en el cluster

```bash
manager:~# docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
f47rcyq97vpxlqx0vz0oyx4p4 *   manager             Ready               Drain               Leader              18.09.8-ce
kc9floqdevu23w60fz786w5br     worker1             Ready               Active                                  18.09.8-ce
wiw0imkq8e4vyr4q5w2sia7cc     worker2             Ready               Active                                  18.09.8-ce
```

notes:

Notar el estado `drain` del manager.

^^^^^^

#### 💻️ Práctica 1: Estado del _swarm_

```bash
manager > docker info

...
Swarm: active
 NodeID: f47rcyq97vpxlqx0vz0oyx4p4
 Is Manager: true
 ClusterID: xjs6l10trsfowvgt8yu5u9phd
 Managers: 1
 Nodes: 3
 Default Address Pool: 10.0.0.0/8
 SubnetSize: 24
 Orchestration:
  Task History Retention Limit: 5
 Raft:
  Snapshot Interval: 10000
  Number of Old Snapshots to Retain: 0
  Heartbeat Tick: 1
  Election Tick: 10
 Dispatcher:
  Heartbeat Period: 5 seconds
 CA Configuration:
  Expiry Duration: 3 months
  Force Rotate: 0
 Autolock Managers: false
 Root Rotation In Progress: false
 Node Address: 192.168.1.200
 Manager Addresses:
  192.168.1.200:2377
...  
```

notes:

El propio comando `docker info` nos dará información del _swarm_

^^^^^^
#### 💻️ Práctica 1: Levantar el servicio MySQL

* Creamos la red `worpress` con el driver `overlay`

```bash
manager > docker network create --driver overlay wordpress
```

^^^^^^
#### 💻️ Práctica 1: Levantar el servicio MySQL

* Una vez tenemos el cluster levantado, procedemos a levantar los servicios
* Empezamos por MySql:
```bash
manager > docker service create \
          --mount type=volume,src=mysql_data,dst=/var/lib/mysql \
          -e MYSQL_ROOT_PASSWORD=wordpress \
          -e MYSQL_DATABASE=wordpress \
          -e MYSQL_USER=wordpress \
          -e MYSQL_PASSWORD=wordpress \
          --network wordpress \
          --name db \
          mysql:5.7
svhelz725p0d7fg09j2xjxe6e
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged
```
^^^^^^

#### 💻️ Práctica 1: Levantar el servicio MySQL

* Con el comando [`docker service ls`](https://docs.docker.com/engine/reference/commandline/service_ls/)
  podemos ver si el servicio está levantado

```bash
manager > docker service ls
ID           NAME  MODE        REPLICAS  IMAGE      PORTS
svhelz725p0d db    replicated  1/1       mysql:5.7
```

^^^^^^

#### 💻️ Práctica 1: Levantar el servicio MySQL

* Con el comando [`docker service ps db`](https://docs.docker.com/engine/reference/commandline/service_ps/)
  podemos ver en qué worker se está ejecutando

```bash
manager > docker service ps db
ID           NAME  IMAGE     NODE     DESIRED STATE  CURRENT STATE           ERROR  PORTS
e8p4jr4ynrit db.1  mysql:5.7 worker1  Running        Running 5 minutes ago
```

^^^^^^

#### 💻️ Práctica 1: Levantar el servicio Wordpress

```bash
manager > docker service create \
          -e WORDPRESS_DB_USER=wordpress \
          -e WORDPRESS_DB_NAME=wordpress \
          -e WORDPRESS_DB_PASSWORD=wordpress \
          -e WORDPRESS_DB_HOST=db:3306 \
          -p "8081:80" \
          --name wordpress \
          --replicas 1 \
          --mode replicated \
          --network wordpress \
          wordpress
svhelz725p0d7fg09j2xjxe6e
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged
```

^^^^^^
#### 💻️ Práctica 1: Levantar el servicio Wordpress

```bash
manager > docker service ls
ID           NAME      MODE        REPLICAS  IMAGE             PORTS
svhelz725p0d db        replicated  1/1       mysql:5.7
or5qlpbxilgr wordpress replicated  2/2       wordpress:latest  *:8081->80/tcp
```

^^^^^^

#### 💻️ Práctica 1: Comprobar que funciona

Accede a `localhost:8081`, deberías ver la interfaz de instalación de wordpress

¡¡Instalalo!!

^^^^^^
#### 💻️ Práctica 1: El problema de la base de datos

Ejecuta el comando `docker service ps db` y averigua en qué worker se está 
ejecutando la base de datos

```bash
docker service ps db
ID           NAME  IMAGE      NODE     DESIRED STATE   CURRENT STATE
lxc674i08m3f db.1  mysql:5.7  worker2  Running         Running less than a second ago
```

^^^^^^
#### 💻️ Práctica 1: El problema de la base de datos

Accede al otro _worker_ (en nuestro caso, el _worker1_) y verifica con el comando
`docker volume ls` que no existe un volumen llamado `mysql_data`.

Si existe elimínalo con `docker volume rm mysql_data`

Reinicia el `worker2`

Pasados unos segundos, los contenedores deberían reiniciarse en el _worker1_

^^^^^^
#### 💻️ Práctica 1: El problema de la base de datos

Vuelve a acceder a `localhost:8081`...

¡¡Nos vuelve a pedir que instalemos 😱!!

^^^^^^
#### 💻️ Práctica 1: El problema de la base de datos

¿Qué ha pasado?

1. Cuando hicimos la instalación, los datos de la base de datos quedaron
   en un volumen en `worker2`
1. Al apagar `worker2`, los contenedores se replicaron en `worker1` **pero los volúmenes no se movieron**
1. Se creó un nuevo volumen en `worker1` y se recreó una base de datos vacía

^^^^^^
#### 💻️ Práctica 1: El problema de la base de datos

¿posibles soluciones?

* Que la base de datos se levante siempre en el mismo worker, en este caso 
  en el `worker2`
* Volver a levantar `worker2` y ejecutar los siguientes comandos  

```bash
manager > docker service rm db
manager > docker service create \
          --mount type=volume,src=mysql_data,dst=/var/lib/mysql \
          -e MYSQL_ROOT_PASSWORD=wordpress \
          -e MYSQL_DATABASE=wordpress \
          -e MYSQL_USER=wordpress \
          -e MYSQL_PASSWORD=wordpress \
          --constraint "node.hostname==worker2" \
          --network wordpress \
          --name db \
          mysql:5.7
```  

notes:

Estos comandos borran el servicio db y lo vuelven a crear. Al hacerlo,
y si el `worker2` está levantado, el servicio db se levanta en `worker2`
y recuperamos automáticamente la web anterior.

^^^^^^
#### 💻️ Práctica 1: El problema de la base de datos

¿posibles soluciones?

* Utilizar un sistema distribuido de ficheros y poner los volúmenes de docker
  en ese sistema para que estén accesibles desde cualquier nodo
* Utilizar un sistema de ficheros en red (NFS, ICFS, etc) y utilizar un _bind mount_