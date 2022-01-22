# Métricas con Prometheus

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Configurar el demonio `dockerd` para que exporte métricas y leerlas utilizando Prometheus.

## Máquinas virtuales

Si dispones de dos máquinas virtuales, puedes configurar `dockerd` en una de ellas
y desde la otra, leer las métricas con Prometheus.

Si sólo dispones de una máquina, no hay problema: levanta los dos contenedores en el 
mismo host de docker. En este taller usaré dos máquinas diferentes.

## Configuración de `dockerd`: `máquina docker`

La primera de las máquinas virtuales, a la que me referiré como `máquina docker`, es en la que 
cambiaremos la configuración de `dockerd`. 

Para poder acceder a las métricas desde otros hosts, debemos exponer las métricas en la IP 
pública de la `máquina docker`. Usamos el comando `ip` para averiguar la dirección:

```shell
docker $ ip add | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
    inet 93.93.115.41/32 scope global dynamic ens6
    inet6 fe80::1:d9ff:fe32:baa4/64 scope link
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
    inet6 fe80::42:3ff:fe8d:aeab/64 scope link
    inet 192.168.16.1/20 brd 192.168.31.255 scope global br-a90f36c60157
    inet6 fe80::42:cfff:fe2c:5103/64 scope link
    inet 172.18.0.1/16 brd 172.18.255.255 scope global br-56974db5a103
    inet6 fe80::42:f9ff:fe09:29ef/64 scope link
```

En nuestro caso, la dirección IP es `93.93.115.41`.

Editar el fichero `/etc/docker/daemon.json` y añadir las 
siguientes opciones:

```json
{
  "metrics-addr" : "93.93.115.41:9323",
  "experimental" : true
}
```

Reiniciar docker:

```shell
docker $ systemctl docker restart
```

Podemos comprobar que las métricas están activas usando `curl`:

```shell
docker $ curl http://93.93.115.41:9323/metrics
...
...
# HELP swarm_store_write_tx_latency_seconds Raft store write tx latency.
# TYPE swarm_store_write_tx_latency_seconds histogram
swarm_store_write_tx_latency_seconds_bucket{le="0.005"} 0
swarm_store_write_tx_latency_seconds_bucket{le="0.01"} 0
swarm_store_write_tx_latency_seconds_bucket{le="0.025"} 0
swarm_store_write_tx_latency_seconds_bucket{le="0.05"} 0
swarm_store_write_tx_latency_seconds_bucket{le="0.1"} 0
swarm_store_write_tx_latency_seconds_bucket{le="0.25"} 0
swarm_store_write_tx_latency_seconds_bucket{le="0.5"} 0
swarm_store_write_tx_latency_seconds_bucket{le="1"} 0
swarm_store_write_tx_latency_seconds_bucket{le="2.5"} 0
swarm_store_write_tx_latency_seconds_bucket{le="5"} 0
swarm_store_write_tx_latency_seconds_bucket{le="10"} 0
swarm_store_write_tx_latency_seconds_bucket{le="+Inf"} 0
swarm_store_write_tx_latency_seconds_sum 0
swarm_store_write_tx_latency_seconds_count 0
```

## Accediendo a las métricas: `máquina métricas`

La segunda máquina, a la que me referiré como `máquina métricas`, es la que utilizaremos
para desplegar Prometheus como un contenedor y leer las métricas.

Esta máquina requiere tener 
[docker instalado](https://docker-course.alfonsoalba.com/slides/es/0010_introduccion/index.html#/4). Si
no lo está, instalalo.

Una vez docker está instalado, creamos un 
[fichero de configuración](./prometheus.yml) para Prometheus. Antes de continuar, revisa la dirección IP
del `job_name: docker` y pon la dirección de tu `máquina docker`.

Levantamos un contenedor a partir de la imagen de Prometheus:

```shell
metricas$ docker run \
--rm \
--name 0090-prometheus \
--mount type=bind,src=$(pwd)/prometheus.yml,dst=/etc/prometheus/prometheus.yml \
-p 9090:9090 \
prom/prometheus
```

Si apuntamos nuestro navegador a `http://localhost:9090` accederemos a la interfaz web de Prometheus.

## Usando las métricas

Acceder a la web de Prometheus. Configurar un gráfico para ver la métrica
`engine_daemon_container_states_containers`.

Parar y levantar la aplicación Rails que creamos en el taller 
[Aplicación Rails con `docker compose`](../../0070-docker-compose/aplicacion-rails-con-compose/README_es.md).
Al levantar y parar la aplicación, observaremos los cambios en la gráfica.

## Seguridad

Hemos exportado las métricas a través de la IP pública. Recuerda proteger el acceso a ese puerto y la información
que muestra cuando lo hagas en producción. Usa cortafuegos, exportalo únicamente a través de IPs de servicio, VPN, etc.

## Limpieza

En la `máquina métricas`, para el contenedor de Prometheus y borrarlo si no lo has levantado con la opción `--rm`:

```shell
metricas $ docker container rm 0090-prometheus
```

En la `máquina docker`, edita el fichero `/etc/docker/daemon.json` y cambia la dirección IP a
`127.0.0.1` para dejar de exportar las métricas.