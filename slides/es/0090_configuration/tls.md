### Ejemplo de configuración: TLS en Linux

Vamos a configurar el acceso remoto a un host en Linux que esté ejecutando `dockerd` 

notes:

Debemos asegurarnos de que el manager está fuera del swarm ya que en caso 
contrario lo que hagamos a continuación no funcionará.

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Usaremos como ejemplo la máquina `manager` que utilizamos en el módulo anterior
para hacer la práctica y ejercicios de docker swarm.

^^^^^^

#### Ejemplo de configuración: TLS en Linux

La CA y los certificados del cliente de docker:

```bash
manager > mkdir .docker
manager > docker run -e SSL_SUBJECT="manager" -v $(pwd)/.docker:/certs paulczar/omgwtfssl
```

[¿Qué es OMGWTFSSL?](https://hub.docker.com/r/paulczar/omgwtfssl/)

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Copiamos la parte pública de la CA al directorio `/etc/docker/ssl/ca.pem`

```bash
manager > cp ~/.docker/ca.pem /etc/docker/ssl/ca.pem
```

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Creamos los certificados para el servidor:

```bash
manager > docker run --rm -v /etc/docker/ssl:/server \
          -v $(pwd)/.docker:/certs \
          -e SSL_IP=127.0.0.1,192.168.43.230 \
          -e SSL_SUBJECT=manager \
          -e SSL_KEY=/server/key.pem \
          -e SSL_CERT=/server/cert.pem \ 
          paulczar/omgwtfssl
```
Este comando genera los certificados en la carpeta `/etc/docker/ssl` del host

notes:

Es importante utilizar la opción `SSL_SUBJECT`. Se ha intentado seguir este
procedimiento para acceder al servidor por IP y no he sido capaz.

Es probable que el problema esté en el uso del contenedor 
`paulczar/omgwtfssl` para generar los certificados. Para confirmarlo, 
podríamos generar los certificados directamente con OpenSSL... aunque esto
lo dejamos como ejercicio para el lector.🤷


^^^^^^

#### Ejemplo de configuración: TLS en Linux

Editamos el fichero de configuración de `dockerd` en `/etc/docker/daemon.json`

```json
{
  "debug": true,
  "tls": true,
  "tlscacert": "/etc/docker/ssl/ca.pem",
  "tlscert": "/etc/docker/ssl/cert.pem",
  "tlskey": "/etc/docker/ssl/key.pem",
  "tlsverify": true,
  "hosts": [
    "tcp://0.0.0.0:2376",
    "unix:///var/run/docker.sock"
  ]
}
```


^^^^^^

#### Ejemplo de configuración: TLS en Linux
 
En este fichero de configuración hemos definido que quetemos acceder a docker usando dos métodos:

* socket unix
* puerto tpc 2376 usando TLS

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Comprobamos que podemos conectarnos usando el socket unix:

```bash
manager > docker info
Containers: 6
 Running: 0
 Paused: 0
 Stopped: 6
Images: 2
Server Version: 18.09.8-ce
Storage Driver: overlay2
...
```

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Comprobamos que podemos conectarnos usando el puerto 2376:

```bash
manager > docker -H 127.0.0.1:2376 info
Error response from daemon: Client sent an HTTP request to an HTTPS server.
```

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Utilizamos variables de entorno para configurar el cliente de docker:
```bash
manager > export DOCKER_CERT_PATH=~/.docker
manager > export DOCKER_TLS_VERIFY=1 
manager > export DOCKER_HOST=manager:2376
manager > docker info
Containers: 6
 Running: 0
 Paused: 0
 Stopped: 6
Images: 2
Server Version: 18.09.8-ce
Storage Driver: overlay2
...
```

notes:

Más adelante, dentro de esta misma sección, nos contectaremos pasando 
al cliente todos estos valores como argumentos en lugar de utilizando
variables de entorno

^^^^^^

#### Ejemplo de configuración: TLS en Linux

¿Y si quieremos conectarnos desde mi máquina...?

Editamos el fichero `/etc/hosts` y añadimos la siguiente línea:

```
192.168.43.230  manager
```

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Esta línea nos permitirá usar `manager` como nombre del host, por ejemplo:

```bash
> ping manager
ping -c 2 manager
PING manager (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: seq=0 ttl=64 time=0.039 ms
64 bytes from 127.0.0.1: seq=1 ttl=64 time=0.063 ms

--- manager ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.039/0.051/0.063 ms
```


notes:

Para conectarnos desde nuestra máquina necesitaremos:

* Los certificados de cliente que generamos en el `manager` (los 
  transferiremos usando scp)
* Poder resolver el nombre `manager` y que resuelva a la dirección IP
  del `manager``
* Configurar el cliente de nuestra máquina para que acceda al 
  `dockerd`del manager usando TLS

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Copiamos los certificados del cliente a la carpeta `certs_manager`

```bash
> mkdir certs_manager
> scp root@192.168.43.230:.docker/cert.pem certs_manager
> scp root@192.168.43.230:.docker/key.pem certs_manager
> scp root@192.168.43.230:.docker/ca.pem certs_manager
```

notes:

Usando la CA y su clave privada, podríamos generar nuevos certificados 
para este cliente.

^^^^^^

#### Ejemplo de configuración: TLS en Linux

Nos conectamos al demonio del `manager`:

```bash
> docker -H manager:2376 \
         --tls 
        --tlscacert=certs_manager/ca.pem 
        --tlscert=certs_manager/cert.pem 
        --tlskey=certs_manager/key.pem 
        info
Client:
 Debug Mode: false

Server:
 Containers: 6
  Running: 0
  Paused: 0
  Stopped: 6
 Images: 2
 Server Version: 18.09.8-ce
```
😎🤩

