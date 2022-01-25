# Limitar memoria y CPU

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Ilustrar las opciones de `docker run` / `docker create` para limitar los recursos utilizados
por los contenedores

## La imagen

Utilizaremos una aplicación node de ejemplo que tomaremos del catálogo disponible
en Dokcer Hub: (https://hub.docker.com/r/bitnami/node-example/#!)[https://hub.docker.com/r/bitnami/node-example/#!]

## El contenedor

Ejecutamos un contenedor con esta imagen sin ningún limite de recursos:

```shell
$ docker run --rm -d --name nodeapp -p 3000:3000 bitnami/node-example:0.0.1
```

Si miramos la salida de `docker stats`:

```shell
CONTAINER ID   NAME             CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O     PIDS
6817bc5e0542   nodeapp          0.00%     52.78MiB / 3.812GiB   1.35%     586B / 0B         0B / 0B       17
```

## Limitar la memoria

Utilizaremos el comando `docker update` para limitar la memoria:

```shell
$ docker container update --memory 25M --memory-swap -1 nodeapp
```

Si miramos de nuevo la salida de `docker stats`:

```shell
CONTAINER ID   NAME             CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O     PIDS
6817bc5e0542   nodeapp          0.00%     24.98MiB / 25MiB      99.92%    866B / 0B         0B / 0B       17
```

También podemos usar `docker inspect`:

```shell
$ docker container inspect nodeapp --format '{{json .HostConfig.Memory}} {{json .HostConfig.MemorySwap}}'
```

Este contenedor funciona correctamente si limitamos la memoria a 25M.

## Limitar CPU

Veamos cuánto tiempo tarda en responder el contenedor a una petición web:

```shell
$  time curl localhost:3000
<!DOCTYPE html><html><head><title>Express</title><link rel="stylesheet" href="/stylesheets/style.css"></head><body><h1>Express</h1><p>Welcome to Express</p></body></html>
real    0m0.093s
user    0m0.000s
sys     0m0.010s
```

Limitemos la CPU a una fracción muy pequeña:

```shell
$ docker container update --cpu-period 50000 --cpu-quota 1000 nodeapp
```

Veremos cómo el tiempo de respuesta aumenta considerablemente:

```shell
$ time curl localhost:3000
<!DOCTYPE html><html><head><title>Express</title><link rel="stylesheet" href="/stylesheets/style.css"></head><body><h1>Express</h1><p>Welcome to Express</p></body></html>
real    0m21.273s
user    0m0.009s
sys     0m0.004s
```