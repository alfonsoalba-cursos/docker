### Perfiles

Permiten seleccionar qué servicios vamos a levantar (por ejemplo al ejecutar
`docker compose up`)

Útil para depuración o poder trabajar con diferentes entornos

^^^^^^

### Perfiles

```yaml [4,10,11]
services:
  frontend:
    image: frontend
    profiles: ["frontend"]

  phpmyadmin:
    image: phpmyadmin
    depends_on:
      - db
    profiles:
      - debug

  backend:
    image: backend

  db:
    image: mysql
```

^^^^^^

### Perfiles

Si un servicio no se le asigna un perfil **se levantará siempre**

^^^^^^

### Perfiles

Siguiendo con el ejemplo anterior, normalmente trabajamos usando solo el servicio
`frontend`

```shell
$ docker-compose --profile debug up
$ COMPOSE_PROFILES=debug docker-compose up
```

^^^^^^

### Perfiles

Cuando necesitemos acceder a `PHPMyAdmin` activamos el perfil `debug`

```shell
$ docker-compose --profile frontend --profile debug up
$ COMPOSE_PROFILES=frontend,debug docker-compose up
```

^^^^^^

### Perfiles

```yaml

services:
  backend:
    image: backend

  db:
    image: mysql

  db-migrations:
    image: backend
    command: myapp migrate
    depends_on:
      - db
    profiles:
      - tools
```

`docker-compose up -d` levantará `web` y `db`

`docker-compose run db-migrations` levanrá `db` y activará el perfil `tools`

^^^^^^

##### Perfiles

```yaml
services:
  web:
    image: web
  mock-backend:
    image: backend
    profiles: ["dev"]
    depends_on: ["db"]
  db:
    image: mysql
    profiles: ["dev"]
  phpmyadmin:
    image: phpmyadmin
    profiles: ["debug"]
    depends_on: ["db"]
```

`docker-compose up -d` levantará el servicio `web`.

`docker-compose up -d mock-backend` levantará `mock-backend` y `db` al activar
el perfil `dev`

`docker-compose up phpmyadmin` fallará porque el perfil `dev` no está activado

notes:

Al levantar el servicio `phpmyadmin` se activa el perfil `debug`, pero no se activa
el perfil de las dependencias. En este caso, no se activa el perfil `dev` a pesar de que
el servicio `phpmyadmin` depende de `db`. 

Soluciones:
* incluir el servicio `db` en el perfil `debug`
  ```yaml
  db:
    image: mysql
    profiles: ["debug", "dev"]
  ```
* activar explícitamente el perfil `dev`
  ```shell
  $ docker-compose --profile dev up phpmyadmin
  $ COMPOSE_PROFILES=dev docker-compose up phpmyadmin  
  ```
