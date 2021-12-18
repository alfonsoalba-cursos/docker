### Definición de servicios

Podéis encontrar la especificación completa del fichero `docker-compose.yml`
en la [documentación oficial de Docker](https://docs.docker.com/compose/compose-file/)

^^^^^^
En las siguientes diapositivas nos centraremos la definición de:

* [`build`](/#docker-compose-reference-build)
* [`image`](/#docker-compose-reference-image)
* [Volúmenes](/#docker-compose-reference-volumes)
* [_bind mounts_](/#docker-compose-reference-bind-mounts)
* [Puertos](/#docker-compose-reference-ports)
* [Redes](/#docker-compose-reference-networks)
* [`command`](/#docker-compose-reference-command)
* [`entrypoint`](/#docker-compose-reference-entrypoint)
* [`environment`](/#docker-compose-reference-environment)

^^^^^^
<!-- .slide: id="docker-compose-reference-build"-->
### `build`

La sección `build` de un servicio nos permite definir cómo construir la imagen

```yaml
version: "3.7"
services:
  webapp:
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
      args:
        buildno: 1
```

notes:

En el ejemplo que hemos puesto, estamos definiendo cuál es el _build context_
así como el `Dockerfile` a utilizar. 

En la [documentación de `build`](https://docs.docker.com/compose/compose-file/#build) 
podemos encontrar todas las opciones que `docker-compose.yml` nos permite utilizar
para generar la imagen

^^^^^^
#### `build`

Una vez definido cómo construie el servicio, podemos generar la imagen
con el comando `docker-compose build`

```bash
> docker-compose build webapp
```


^^^^^^
<!-- .slide: id="docker-compose-reference-image"-->
### `image`

Especifica la imagen a utilizar en ese servicio:

```yaml
version: '3.7'

services:
   db:
     image: mysql:5.7
```

^^^^^^
<!-- .slide: id="docker-compose-reference-volumes"-->
### `volumes`

Esta sección se define a nivel global en el fichero y dentro de cada servicio

```yaml
version: '3.7'

services:
   db:
     image: mysql:5.7
     volumes:
       - mysql_data:/var/lib/mysql
     ...
      
   wordpress:
     image: wordpress:latest
     ...

volumes:
    mysql_data:
```

^^^^^^

#### `volumes`

La forma de definirlos dentro de un servicio es:

```yaml
services:
  webapp:
    volumes:
    - [nombre del volumen]:[punto de montaje]:[opciones]
```
[documentación de `volumes`](https://docs.docker.com/compose/compose-file/#volumes) 

^^^^^^
#### `volumes`

Si queremos compartir el volumen entre varios servicios, se debe definir en la
sección `volumes` del fichero

```yaml
services:
  webapp:
    volumes:
    - [nombre del volumen]:[punto de montaje]:[opciones]

volumes:
  [nombre del volumen]:
    [configuración]
```

^^^^^^
#### `volumes`

Sintaxis larga:

```yaml
version: "3.7"
services:
  web:
    image: nginx:alpine
    volumes:
      - type: volume
        source: mydata
        target: /data
        volume:
          nocopy: true
```

^^^^^^
### _bind mounts_
<!-- .slide: id="docker-compose-reference-bind-mounts"-->

Se definen también en la sección `volumes` del servicio

```yaml
services:
  webapp:
    volumes:
    - [ruta en el host]:[punto de montaje]:[opciones]
```

^^^^^^
#### _bind mounts_

Sintaxis larga:

```yaml
version: "3.7"
services:
  web:
    image: nginx:alpine
    volumes:
      - type: bind
        source: ./static
        target: /opt/app/static
```

^^^^^^
<!-- .slide: id="docker-compose-reference-ports"-->

### `ports`

Esta sección del servicio permite definir los puertos del contenedor

```yaml
version: "3.7"
services:
  web:
    image: nginx:alpine
    ports:
    - "8080:80"
```

Utiliza la mista syntaxis que la opción `-p` del comando `docker run`

notes:

Se recomienda utilizar siempre los puertos como cadenas de texto. El motivo es
que en un fichero yaml parsea números con el formato `yy:xx` como números
en base 60. Si se especifica un puerto en el contedenedor igual o inferior a 60
(por ejemplo 8080:60) se pueden obtener resultados erróneos.

^^^^^^

#### `ports`

Sintaxis larga:

```yaml
version: "3.7"
services:
  web:
    image: nginx:alpine
    ports:
      - target: 80
        published: 8080
        protocol: tcp
        mode: host
```

^^^^^^

#### `ports`

[Documentación de `ports`](https://docs.docker.com/compose/compose-file/#ports)

^^^^^^
<!-- .slide: id="docker-compose-reference-networks"-->
### `networks`

En la sección `networks` del fichero se definen las redes diponibles, que se
referencian posteriormente en la sección `networks` de cada servicio

```yaml
version: "3.7"
services:
  web:
    networks:
      hostnet: {}

networks:
  hostnet:
    external: true
    name: host
```

^^^^^^
#### `networks`

[Documentación de la sección `networks` del fichero](https://docs.docker.com/compose/compose-file/#network-configuration-reference)

[Documentación de la sección `networks` del servicio](https://docs.docker.com/compose/compose-file/#networks)

^^^^^^
<!-- .slide: id="docker-compose-reference-command"-->

### `command`

Permite sobreescribir el `CMD` definido en la imagen del servicio

```yaml
version: "3.7"
services:
  web:
    command: ["bundle", "exec", "rails", "-p", "3000"]
```

[Documentación de `command`](https://docs.docker.com/compose/compose-file/#command)


^^^^^^
<!-- .slide: id="docker-compose-reference-entrypoint"-->

### `entrypoint`

Permite sobreescribir el `ENTRYPOINT` definido en la imagen del servicio

```yaml
version: "3.7"
services:
  web:
    entrypoint: /app/entrypoint.sh
```

[Documentación de `entrypoint`](https://docs.docker.com/compose/compose-file/#entrypoint)

^^^^^^
<!-- .slide: id="docker-compose-reference-environment"-->

### `environment`

Permite definir variables de entorno

```yaml
version: '3.7'
services:
   db:
     image: mysql:5.7

     environment:
       MYSQL_ROOT_PASSWORD: wordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress
```

[Documentación de `environment`](https://docs.docker.com/compose/compose-file/#environment)
