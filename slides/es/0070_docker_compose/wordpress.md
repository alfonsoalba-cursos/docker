### 💻️ Práctica: levantar un wordpress ️️💻️

notes:

En esta práctica, vamos a levantar una página en wordpress utilizando 
docker-compose para ilustrar cómo se utiliza.

^^^^^^

#### 💻️ Práctica: levantar un wordpress ️️💻️

En una terminal, crea una carpeta que llamaremos `wordpress-compose` y
accede a ella:

```bash
> mkdir wordpress-compose
> cd wordpress-compose

wordpress-compose >
```

^^^^^^

#### 💻️ Práctica: levantar un wordpress ️️💻️

Crear un fichero `docker-compose.yml` con el siguiente contenido:

```yaml
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

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8080:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
volumes:
    mysql_data: {}
```

^^^^^^

#### 💻️ Práctica: levantar un wordpress ️️💻️

Levanta los contenedores:

```bash
wordpress-compose > docker-compose up
```

^^^^^^

#### 💻️ Práctica: levantar un wordpress ️️💻️

Accede a `localhost:8080` y termina la instalación.


^^^^^^

#### 💻️ Práctica: levantar un wordpress ️️💻️

¡Disfruta de tu nueva web en wordpress!


