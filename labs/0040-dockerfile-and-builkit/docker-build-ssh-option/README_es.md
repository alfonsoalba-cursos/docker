# Opción `docker build --sh`

Todos los comandos están ejecutados utilizando esta carpeta como ruta de trabajo.

## Objetivo

Aprender el funcionamiento de la opción `--ssh` del comando `docker buildx build`.
Para ello, buscamos poder incluir dentro de nuestra imagen el contenido de un
repositorio privado alojado en GitHub.

## El repositorio

Crear un repositorio privado en GitHub, GitLab, Bitbucket o cualquier otro servidor
de git que permita el uso de claves privadas SSH. Si no tienes ningún repositorio
privado, crea uno dentro del servidor de git. Después, crear un fichero `main.c`
con el siguiente contenido:

```c
// Simple C program to display "Hello World"
  
// Header file for input output functions
#include <stdio.h>
  
// main function -
// where the execution of program begins
int main()
{
  
    // prints hello world
    printf("Hello World");
  
    return 0;
}
```

Yo utilizaré el repositorio privado `git@github.com:alfonsoalba-cursos/a-simple-private-repository.git`.

## La clave privada

Si tienes una clave privada configurada para acceder a tu repositorio, puedes pasar 
al siguiente paso. En caso contrario, sigue estos pasos para crear y configurar el
acceso ssh al repositorio remoto.

Crear una clave, protegiéndola con la _passphrase_ `dockerlabs` (o alguna otra que te
sea sencillo recordar):

```shell
$ ssh-keygen -t ed25519 -C "dockerlabs"                     
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/aalba/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/aalba/.ssh/id_ed25519
Your public key has been saved in /home/aalba/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:w4jYubuejXdnr2WIVvPMeHngLlXub0HwQ5XDEBi6/7Q dockerlabs
The key's randomart image is:
+--[ED25519 256]--+
|           .oo+ +|
|          .. . = |
|         .    + .|
|   o o o  .   .+ |
|  . + . S.o .o. .|
|     .   +.O.o.. |
|    .   o ooXo. .|
|     =... +=o.o .|
|   .*o.. o.+oE o.|
+----[SHA256]-----+
```

Subir la clave pública tu servidor de Git:
* [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
* [GitLab](https://docs.gitlab.com/ee/ssh/)
* [Bitbucket](https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/)

Confirmar que podemos clonar el repositorio utilizando la clave privada:

```shell
$ git clone -c core.sshCommand="/usr/bin/ssh -i /home/aalba/.ssh/dockerlabs" git@github.com:alfonsoalba-cursos/a-simple-private-repository.git
Cloning into 'a-simple-private-repository'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (8/8), done.
Receiving objects: 100% (9/9), done.
remote: Total 9 (delta 0), reused 0 (delta 0), pack-reused 
```

## El fichero `Dockerfile`

Crearemos un fichero `Dockerfile` con dos etapas:
* Clonado y compilación del programa en `c`
* Generación de la imagen para ejecutarlo

Podéis [ver el fichero `Dockerfile` aqui](./Dockerfile). Utilizaremos la opción `--build-arg` para pasarle 
al constructor la URL del repositorio que contiene el código.

## Ejecutar el agente ssh

Vamos a comprobar si tenemos un agente en ejecución en nuestra máquina. Para ello ejecutamos:

```shell
$ pidof ssh-agent
```

Si no tenemos un agente ssh activo, lo creamos:

```shell
$ ssh-agent
SSH_AUTH_SOCK=/tmp/ssh-2wA6Od2uoEJu/agent.54538; export SSH_AUTH_SOCK;
SSH_AGENT_PID=54539; export SSH_AGENT_PID;
echo Agent pid 54539;

$ SSH_AUTH_SOCK=/tmp/ssh-2wA6Od2uoEJu/agent.54538; export SSH_AUTH_SOCK;
$ SSH_AGENT_PID=54539; export SSH_AGENT_PID;
```

## Añadir la clave privada al agente

Añadimos la clave privada al agente:

```shell
$ ssh-add ~/.ssh/dockerlabs
Enter passphrase for /Users/aalba/.ssh/dockerlabs:
Identity added: /Users/aalba/.ssh/dockerlabs (dockerlabs)
```

## Construimos la imagen

Ejecutamos el siguiente comando para crear la imagen:

```shell
$ buildx build --ssh default -t dockerlabs/ssh-option .
```

Una vez creada la imagen, comprobamos que se ejecuta correctamente:

```shell
$ docker run --rm -ti --name ssh-option dockerlabs/ssh-option
Hello World (from the private repository alfonsoalba-cursos/a-simple-private-repository)
```

## Uso de la opción `id`

En los siguientes pasos, vamos a ilustrar cómo funciona la opción `id` dentro de menos
`--ssh`.

Vamos a intentar construir la imagen pasando la clave privada concreta que queremos utilizar (utilizamos la opción `--no-cache` para que construya la imagen de nuevo):

```shell
$ docker buildx build --ssh dockerlabs=~/.ssh/dockerlabs -t dockerlabs/ssh-option --no-cache .
error: failed to parse /home/aalba/.ssh/dockerlabs: ssh: this private key is passphrase protected
```

Eliminemos temporalmente la protección con contraseña de nuestra clave privada poniendo
una contraseña en blanco:

```shell
$ ssh-keygen -p -f ~/.ssh/dockerlabs
Enter old passphrase:
Key has comment 'dockerlabs'
Enter new passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved with the new passphrase.
```

Volvamos a ejecutar el comando:

```shell
docker buildx build --ssh dockerlabs=~/.ssh/dockerlabs -t dockerlabs/ssh-option --no-cache .
[+] Building 16.6s (11/14)
 => [internal] load build definition from Dockerfile                                                                                             0.0s
 => => transferring dockerfile: 432B                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => => transferring context: 2B                                                                                                                  0.0s
 => resolve image config for docker.io/docker/dockerfile:1                                                                                       0.6s
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1357b3b2                  0.0s
 => [internal] load build definition from Dockerfile                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => [internal] load metadata for docker.io/library/ubuntu:latest                                                                                 0.0s
 => CACHED [build 1/6] FROM docker.io/library/ubuntu:latest                                                                                      0.0s
 => [build 2/6] RUN apt update && apt install -y openssh-client git gcc                                                                         14.0s
 => [build 3/6] RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan -t ecdsa github.com >> ~/.ssh/known_hosts                                             0.8s
 => ERROR [build 4/6] RUN --mount=type=ssh git clone git@github.com:alfonsoalba-cursos/a-simple-private-repository.git /app                      1.0s
------
 > [build 4/6] RUN --mount=type=ssh git clone git@github.com:alfonsoalba-cursos/a-simple-private-repository.git /app:
#11 0.293 Cloning into '/app'...
#11 0.712 Warning: Permanently added the ECDSA host key for IP address '140.82.121.3' to the list of known hosts.
#11 0.984 git@github.com: Permission denied (publickey).
#11 0.985 fatal: Could not read from remote repository.
#11 0.985
#11 0.985 Please make sure you have the correct access rights
#11 0.985 and the repository exists.
------
error: failed to solve: executor failed running [/bin/sh -c git clone git@github.com:alfonsoalba-cursos/a-simple-private-repository.git /app]: exit code: 128
```


¡La construcción falla! El motivo es porque tenemos que decirle a la instrucción 
`RUN` de nuestro `Dockerfile` que utilice el id `dockerlabs`: `RUN --mount=type=ssh,id=dockerlabs`.


Modificamos el fichero Dockerfile y creamos uno nuevo que llamaremos [`Dockerfile_with_id`](./Dockerfile_with_id) en el que introdicimos esta
modificación. Construimos la imagen con este fichero:

```shell
docker buildx build --ssh dockerlabs=~/.ssh/dockerlabs -t dockerlabs/ssh-option -f Dockerfile_with_id --no-cache .
[+] Building 18.6s (15/15) FINISHED
 => [internal] load build definition from Dockerfile_with_id                                                                                     0.0s
 => => transferring dockerfile: 454B                                                                                                             0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => => transferring context: 2B                                                                                                                  0.0s
 => resolve image config for docker.io/docker/dockerfile:1                                                                                       1.1s
 => CACHED docker-image://docker.io/docker/dockerfile:1@sha256:42399d4635eddd7a9b8a24be879d2f9a930d0ed040a61324cfdf59ef1357b3b2                  0.0s
 => [internal] load .dockerignore                                                                                                                0.0s
 => [internal] load build definition from Dockerfile_with_id                                                                                     0.0s
 => [internal] load metadata for docker.io/library/ubuntu:latest                                                                                 0.0s
 => CACHED [build 1/6] FROM docker.io/library/ubuntu:latest                                                                                      0.0s
 => [build 2/6] RUN apt update && apt install -y openssh-client git gcc                                                                         13.9s
 => [build 3/6] RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan -t ecdsa github.com >> ~/.ssh/known_hosts                                             0.9s
 => [build 4/6] RUN --mount=type=ssh,id=dockerlabs git clone git@github.com:alfonsoalba-cursos/a-simple-private-repository.git /app              1.8s
 => [build 5/6] WORKDIR /app                                                                                                                     0.1s
 => [build 6/6] RUN gcc main.c                                                                                                                   0.3s
 => [stage-1 2/2] COPY --from=build /app /                                                                                                       0.1s
 => exporting to image                                                                                                                           0.0s
 => => exporting layers                                                                                                                          0.0s
 => => writing image sha256:1e95c835a665490f98b38a50674466d62335431eeae160ec43d25016827c3b04                                                     0.0s
 => => naming to docker.io/dockerlabs/ssh-option
```

La imagen se construye correcamente. La volvemos a probar ejecutandola de nuevo:


```shell
$ docker run --rm -ti --name ssh-option dockerlabs/ssh-option
Hello World (from the private repository alfonsoalba-cursos/a-simple-private-repository)
```


## Limpieza

Borramos la imagen y el contenedor (si no lo hemos ejecutado con la opción `--rm`)

```shell
$ docker image rm dockerlabs/ssh-option
$ docker container rm ssh-option
```
