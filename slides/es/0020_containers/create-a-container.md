### Crear un contenedor

```bash
docker run becorecode/curso-intro-docker-modulo-2
```

* Este comando crea (y ejecuta) un contenedor 
* Documentación del comando:
  * [Referencia](https://docs.docker.com/engine/reference/run/)
  * [`docker run`](https://docs.docker.com/engine/reference/commandline/run/)

notes:

Empezamos creando nuestro segundo contenedor (el primero fue el contenedor `hello world`) que creamos en el módulo anterior.

La pega que tiene este contenedor es que aunque se está ejecutando, **no podemos ver las diapositivas**

**Para parar el contenedor pulsar CTRL + c en Windows y Linux o CMD + c en Mac.**

Antes de seguir: si accedemos a la documentación de `docker run` o `docker-compose` veréis un montón de opciones.
Veremos las más utilizadas durante el curso aunque **no entraremos en detalles de todas ellas**. No es el objetivo
del curso y para eso está la documentación. En este curso nos vamos a centrar en entender cómo 
funcionan los contenedores para que cuando reviséis por vuestra cuenta las opciones en la documentación, podáis
revisarlo y entenderlo por vosotros mismos.

^^^^^^

...`docker run` tiene truco **en realidad se están ejecutando dos comandos:**

```bash
> docker create becorecode/curso-intro-docker-modulo-2
4c1253a2ec05ea37a296ac2761d83661cb15b81171aa99c0114d9cc0acf38d1c

> docker start 4c1253a2ec05ea37a296ac2761d83661cb15b81171aa99c0114d9cc0acf38d1c
```

notes:

**Recordatorio: para parar el contenedor pulsar CTRL + c en Windows y Linux o CMD + c en Mac.**

^^^^^^

[`docker create`](https://docs.docker.com/engine/reference/commandline/create/) "crea" un contenedor

[`docker start`]() "crea" un contenedor

notes:

¿qué significa crear un contenedor? Entraremos en más detalles en otros módulos que veremos más avanzado 
el curso. De momento,y aunque ahora os suene a chino, lo que este comando hace es crear una nueva capa 
con permiso de escritura sobre la imagen seleccionada y prepara el contenedor para ejecutar el comando 
de inicio. Este comando devuelve el ID del contenedor

`docker start` lanza el contenedor ejectuando el comando de inicio del mismo

^^^^^^

Esto es mu bonico 🌹<br/> pero ¿de qué me sirve si no puedo ver las diapositivas? 🤷

...continuemos profundizando un poco más en los contenedores.<!-- .element: class="plain fragment" style="height: 70vh" data-fragment-index="1" -->

notes:
