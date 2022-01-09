### _bind mounts_

![bind mounts](../../images/types-of-mounts-bind.png)<!-- .element: class="plain"-->

Montamos un directorio del host para poder acceder a él dentro del contenedor.


^^^^^^

### Uso: `-v` o `--mount`

```shell
$ docker run -v [RUTA EN EL HOST]:[RUTA EN EL CONTENEDOR]:[OPCIONES]
$ docker run --mount [key=value],...
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
la imagen, **este se crea siempre como un directorio**

Si hacemos un _bind mount_ de un fichero o directorio con `--mount` y este no existe en 
el host, **se genera un error**

^^^^^^

### 💻 Práctica 2 💻 ️

Utilizando volúmenes, vamos a editar las diapositivas del módulo en caliente.

* Lo primero que haremos será extraer las diapositivas del contendor

```shell 
$ mkdir ~/diapositivas-curso-docker
$ cd ~/diapositivas-curso-docker
$ docker run --rm -d --name auxcontainer -p "8005:80" kubernetescourse/slides-docker
$ docker container cp auxcontainer:/usr/share/nginx/html .
$ docker container stop auxcontainer

```

notes:

El contenedor se borrará, ya que hemos usado la opción `--rm`. Puedes comprobarlo
usando `docker ps -a`.

Al ejecutar este comando, se creará la carpeta `~/diapositivas-curso-docker/html`
en cuyo interior podréis encontrar las diapositivas.

^^^^^^

#### 💻 Práctica 2 (cont.) 💻 ️

* Levantamos un contenedor usando un _bind mount_ para ver las diapositivas del host
  en la carpeta `/usr/share/nginx/html` del contenedor

```shell 
$ docker run --rm \
-d \
--name practica_2_modulo_5 \
--mount "type=bind,src=$(pwd)/html,dst=/usr/share/nginx/html" \
-p "8005:80" kubernetescourse/slides-docker
```
^^^^^^

#### 💻 Práctica 2 (cont.) 💻 ️

* Abre tu editor de Markdown favorito
* Edita las diapositivas (por ejemplo, el fichero `index.html`)
* Apunta el navegador a la URL `http://localhost:8005` y podrás ver los cambios
  que hagas a las diapositivas recargando el navegador

notes:

En este ejemplo, estamos también comprobando que, como diremos en las siguientes
diapositivas, un punto de montaje de un _bind volume_ oculta el contenido 
de ese punto de montaje. Es decir, lo que hubiese en la imagen no se puede ya que
en esa carpeta veremos el contenido del _bind volume_.

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

Combinaremos el uso de volúmenes con `_bind mounts_` en un mismo contenedor.

^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Creamos un contenedor con las diapositivas y las montamos en un volumen que llamaremos
  `backup_modulo_5`

```shell
$ docker run --rm  \
-d \
--name practica_3_modulo_5 \
--mount "type=volume,src=backup_modulo_5,dst=/usr/share/nginx/html" \
-p "8005:80" kubernetescourse/slides-docker
```

notes:

Al igual que nos ocurrió en el ejemplo anterior, como el volumen `backup_modulo_5` está vacío,
el contenido de la carpeta `/usr/share/nginx/html` que está en la imagen,
se copiará al volumen.

^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Ejecutamos el siguiente comando de docker para hacer el backup:

```shell 
$ docker run --rm -d \
      --mount "type=volume,src=backup_modulo_5,dst=/usr/share/nginx/html" \
      --mount "type=bind,src=$(pwd),dst=/backup" \
      ubuntu tar cfpj /backup/slides.tar.bz2 /usr/share/nginx/html
```

Tras ejecutarlo, tendremos en nuestra carpeta local una copia de las diapositivas


^^^^^^

#### 💻 Práctica 3 (cont.) 💻 ️

* Podemos usar la opción `--volumes-from`

```shell 
$ docker run --rm -d \
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

[Bind mounts: Configure the selinux label](https://docs.docker.com/storage/bind-mounts/#configure-the-selinux-label)

