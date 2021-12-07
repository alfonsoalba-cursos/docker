### Ejecutar comandos en un contenedor

* El comando para ejecutar comandos en un contenedor es `docker container exec` (o `docker exec`)
* Para poder ejectuar un comando en un contenedor **este debe estar levantado**
* Documentación del comando:
  * [docker container exec](https://docs.docker.com/engine/reference/commandline/container_exec/)
  * [`docker exec`](https://docs.docker.com/engine/reference/commandline/exec/)

notes:

Sí, son el mismo comando y hacen lo mismo. Las páginas de documentación son ligeramnente diferentes y por eso os facilito
el enlace a ambas.

^^^^^^

### 💻 Práctica 💻

* Levantar el contenedor con las diapositivas del curso
* Listar el contenido de la carpeta `slides`

```bash
  > docker run --rm -p "8002:8002" --name modulo2 becorecode/curso-intro-docker-modulo-2
  > docker exec modulo2 ls
  Dockerfile
  LICENSE
  README.md
  bower.json
  css
  ...
```

notes:

Lo prometido es deuda. Os dije que veríamos diferentes opciones del comando `docker container create` y/o `docker run`y aquí tenéis una nueva:
`--name`. Esta opción nos permite ponerle un nombre al contenedor para refererirnos a él, asi no tenemos que utilizar su ID.

En las siguientes diapositivas utilizaré el nombre el lugar del ID.

^^^^^^

### 💻 Ejercicio 💻

* ¿Cuál es la carpeta dentro del contenedor en la que se encuentran las diapositivas?
* ¿Con qué usuario se está ejecutando el proceso dentro del contenedor?
* Ejecuta una shell de unix dentro del contenedor

notes:

Usando los siguientes comandos podemos dar respuesta a estas preguntas:

```bash
> docker exec modulo2 pwd
```
 nos muestra que la carpeta es `/home/node`

```bash
> docker exec modulo2 ps -uxa
```
nos muestra que el usuario es `node`. También podríamos obtener esta información mirando el fichero `Dockerfile`, aunque esto lo veremos más adelante en el curso.

El siguiente comando nos permite ejecutar una shell:
```bash
> docker exec modulo2 bash
```

^^^^^^

##### Práctica: hagamos el cabra 🐐

⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

**CUIDADO** 

* LA SIGUIENTE PRÁCTICA ES PELIGROSA.
* SI NO ESTÁS SEGURO DE LO QUE ESTÁS HACIENDO, NO LO HAGAS
* SI NO ESTÁS EN UNA MÁQUINA QUE PUEDAS RECUPERAR, NO LO HAGAS.
* LOS SIGUIENTES COMANDOS MAL EJECUTADOS PUEDEN HACER QUE PIERDAS INFORMACIÓN 
  VALIOSA DE TU MÁQUINA

⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

^^^^^^

### Práctica: hagamos el cabra 🐐

* Vuelve a levantar el contenedor si por un casual lo has parado:

```bash
  > docker run --rm -p "8002:8002" --name modulo2 becorecode/curso-intro-docker-modulo-2
```

* 🤯 Intenta borrar todos los ficheros del contenedor: `rm -r /`
* ⛔ No has podido... menos mal 
* Mirando la documentación de `docker exec` encuentra la opción que te permitiría acceder como root al contenedor
* Bien... ahora **borra todos los ficheros del contenedor** 🤯🤯🤯🤯

^^^^^^

### Práctica: hagamos el cabra 🐐🐐
* Si detienes el contenedor con `docker container stop` y lo vuelves a levantar con `docker container start` ¿estarán los ficheros dentro?
* Si borras el contenedor con `docker container rm` y creas uno nuevo con el mismo nombre (modulo2) ¿estárán los ficheros dentro?

Pruebalo y verifica si tus respuestas son correctas

^^^^^^

### ⚠️ Importante ⚠️

**✅ Los contenedores persisten los datos mientras existen.**

**✅ Si se borra un contenedor y se vuelve a crear, los datos dentro del contenedor se pierden.**

notes:

Imaginaos la siguiente situación:
* Tenéis una aplicación web y guardáis los ficheros del usuario dentro del contenedor
* De repente viene un pico de tráfico y levantáis otro contenedor para absorverlo
* Ahora tenéis las fotos repartidas en dos contenedores
* Cuando pasa el pico, paráis uno de los contenedores porque ya no lo no necesitáis ¿qué pasó con las fotos que se subieron a ese contenedor? 
  ¡dejáis de tener acceso a ellas!
* Dado que ese contenedor no se está usando, alguien o "algo" puede decidir borrar ¡acabáis de perder las fotos!

Los contenedores están pensados para efímeros. Los orquetadores de contenedores como
kubernetes o docker swarm, levanta, paran, borran y recrean los contenedores según se necesita. Pueden moverlos a su antojo entre diferentes máquinas si lo creen conveniente para optimizar los recursos. Los contenedores deben diseñarse para que no sean persistentes ya que el orquestador debe tener la capacidad de **borrarlos** y volverlos a crear a su antojo.

¿Qué pasa si necesitamos persistencia? Como ocurre en el ejemplo que acabamos de poner. También necesitaríamos persistencia para la base de datos MySQL que pusimos de ejemplo [al principio de este módulo](#/what-is-a-container).
En este caso debemos usar volúmenes, que veremos más adelante en el curso.
