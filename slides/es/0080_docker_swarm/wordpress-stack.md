### 💻️ Práctica 2: Wordpress stack

Objetivo: levantar _swarm_ utilizando un stack

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

Cuando docker se ejecuta en modo swarm, podemos utilizar un 
[`stack`](https://docs.docker.com/engine/swarm/stack-deploy/)
para desplegar una aplicación completa a partir de un fichero Compose

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

El comando 
[`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/)
lee un fichero Compose (versión 3.0 o superior) y levanta los **servicios**
definidos en el fichero

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

Definición de servicios para nuestra aplicación worpress

```yml
version: '3.7'

services:
   db:
     image: mysql:5.7
     volumes:
       - mysql_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: wordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress
     deploy:
       replicas: 1
       mode: replicated
       placement:
         constraints:
           - "node.hostname==worker1"
   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8081:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
     deploy:
       replicas: 2
       mode: replicated
volumes:
    mysql_data: {}
```

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

```bash
manager > docker stack deploy -c docker-compose.yml worpress
Ignoring unsupported options: restart

Creating network worpress_default
Creating service worpress_db
Creating service worpress_wordpress
```

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

Utilizamos el comando 
[`docker stack ls`](https://docs.docker.com/engine/reference/commandline/stack_ls/)
para ver el los stacks que tenemos levantados

```bash
manager > docker stack ls
NAME                SERVICES            ORCHESTRATOR
worpress            2                   Swarm
```

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

Vemos qué contenedores están implicados en el stack utilizando el comando
[docker stack ps](https://docs.docker.com/engine/reference/commandline/stack_ps/)

```bash
manager > docker stack ps worpress
ID                  NAME                   IMAGE               NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
3i53499xvcn2        worpress_wordpress.1   wordpress:latest    worker2             Running             Running 5 minutes ago
go6ki3ihjmqu        worpress_db.1          mysql:5.7           worker1             Running             Running 5 minutes ago
lrmu1iixgcc1        worpress_wordpress.2   wordpress:latest    worker1             Running             Running 4 minutes ago
```

^^^^^^

#### 💻️ Práctica 2: Wordpress stack

Con el comando 
[`docker stack services`](https://docs.docker.com/engine/reference/commandline/stack_services/)
podemos listar los servicios definidos en el stack

```bash
 manager > docker stack services worpress
ID                  NAME                 MODE                REPLICAS            IMAGE               PORTS
nk74xcyowrl1        worpress_db          replicated          1/1                 mysql:5.7
uz6xdiibtjha        worpress_wordpress   replicated          2/2                 wordpress:latest    *:8081->80/tcp
```