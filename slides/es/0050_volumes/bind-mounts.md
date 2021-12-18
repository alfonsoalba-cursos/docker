### _bind mounts_

![bind mounts](../../images/types-of-mounts-bind.png)<!-- .element: class="plain"-->

Montamos un directorio del host para poder acceder a él dentro del contenedor.


^^^^^^

### Uso: `-v` o `--mount`

```bash
> docker run -v [RUTA EN EL HOST]:[RUTA EN EL CONTENEDOR]:[OPCIONES]
> docker run --mount [key=value],...
```


notes:

`--v` acepta las situientes opciones:

* `ro`, `consistent`, `delegated`, `cached`, `z` y `Z`

`--mount` acepta las siguientes opciones:

* `type` que será `bind` en el caso que nos ocupa
* `source`: ruta al fichero o directorio del host que queramos hacer visible dentro
  del contenedor.
* `destination` ruta dentro del contenedor en la que montar el volumen. Se puede usar `dst` o
  `target`.
* `readonly` una opción que, si está presente monta el _bind mount_ en modo solo lectura
* `bind-propagation` configuración del 
  [`bind-progation`](https://docs.docker.com/storage/bind-mounts/#configure-bind-propagation)
* `consistency` que puede tomar los valores `consistent`, `delegated` o `cached`. 
  Sólo aplicable en OSX. En el resto de plataformas se ignora
* **No soporta las opciones `z`y `Z` para modificar las etiquetas `SELinux`**

^^^^^^

### Uso: `-v` o `--mount`

Si hacemos un _bind mount_ de un fichero o directorio con `-v` y este no existe en 
el host, **este se crea siempre como un directorio**

Si hacemos un _bind mount_ de un fichero o directorio con `--mount` y este no existe en 
el host, **se genera un error**

^^^^^^

### 💻 Práctica 2 💻 ️

Utilizando volúmenes, vamos a editar las diapositivas del módulo en caliente.

* Lo primero que haremos será extraer las diapositivas del contendor

```bash 
> docker run --rm -d --name auxcontainer -p "8005:8005" becorecode/curso-intro-docker-modulo-5
> docker container cp auxcontainer:/home/node/slides .
> docker container stop auxcontainer
```

^^^^^^

#### 💻 Práctica 2 (cont.) 💻 ️

* Levantamos un contenedor usando un _bind mount_ para ver las diapositivas del host
  en la carpeta /home/node/slides del contenedor

```bash 
> docker run --rm 
    -d 
    --name practica_2_modulo_5 
    --mount "type=bind,src=$(pwd)/slides,dst=/home/node/slides"
    -p "8005:8005" becorecode/curso-intro-docker-modulo-5
```
^^^^^^

#### 💻 Práctica 2 (cont.) 💻 ️

* Abre tu editor de Markdown favorito
* Edita las diapositivas
* Recarga el navegador para observar los cambios

^^^^^^

### _bind mounts_

Si hacemos un _bind mount_ de fichero o directorio del host en un punto de montaje
del contenedor, **el contenido de ese punto de montaje quedará oculto**

^^^^^^

### 💻 Práctica 3 💻 ️

Vamos a hacer una copia de seguridad de nuestro contenedor. 

Aunque yo voy a hacer una copia seguridad de mis diapositivas, **sugiero que 
vosotros hagáis una copia de la app en rails que habéis empezado a hacer**

notes:

Esta práctica está inspirada en [esta sección](https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes) 
de la documentación de Docker.

^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Creamos un contenedor con las diapositivas:

```bash
docker run --rm 
    -d 
    --name practica_3_modulo_5 
    -p "8005:8005" becorecode/curso-intro-docker-modulo-5
```

^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Creamos un contenedor con las diapositivas y las montamos en un volumen que llamaremos
  `backup_modulo_5`

```bash
docker run --rm  \
    -d \
    --name practica_3_modulo_5 \
    --mount "type=volume,src=backup_modulo_5,dst=/home/node/slides" \
    -p "8005:8005" becorecode/curso-intro-docker-modulo-5
```

^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Ejecutamos el siguiente comando de docker para hacer el backup:

```bash 
> docker run --rm -d \
      --mount "type=volume,src=backup_modulo_5,dst=/home/node/slides" \
      --mount "type=bind,src=$(pwd),dst=/backup" \
      ubuntu tar cfpj /backup/slides.tar.bz2 /home/node/slides
```

Tras ejecutarlo, tendremos en nuestra carpeta una copia de las diapositivas


^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Podemos usar la opción `--volumes-from`

```bash 
> docker run --rm -d \
      --volumes-from practica_3_modulo_5  \
      --mount "type=bind,src=$(pwd),dst=/backup" \
      ubuntu tar cfpj /backup/slides.tar.bz2 /home/node/slides
```

notes:

Esta opción utiliza los mismos volúmenes que el contenedor indicado. Nos permite
no tener que duplicar la configuración del punto de montaje al crear el contenedor.

^^^^^^

### Sobre SELinux

Si `dockerd` se ejecuta sobre un sistema con SELinux, puede darse el caso de
que los contenedores no tengan permiso para acceder a los _bind mounts_

Las opciones `z` y `Z` le indiquen a `dockerd` que añada las etiquetas de `selinux` 
apropiadas a los ficheros en el volumen cuando se arranque el contenedor

[Info](https://docs.docker.com/storage/bind-mounts/#configure-the-selinux-label)

