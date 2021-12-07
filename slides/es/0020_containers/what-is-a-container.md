## ¿Qué es un contenedor?

notes:

Esta es una pregunta tan frecuente que hasta Docker tiene [una landing page específica](https://www.docker.com/resources/what-container) para responderla

^^^^^^

Definición que da docker

**A standardized unit of software**

^^^^^^

<img src="../../images/container-what-is-container.png" alt="Qué es un contenedor" class="r-stretch">

notes:

Un contenedor es una software empaquetado en unidades estandarizadas para desarrollo y despliegue en producción.

Un contenedor empaqueta un determinado código y todas sus dependencias **de manera que la aplicación se ejecuta correctamente en diferentes entornos de ejecución** (por ejemplo: mi máquina en desarrollo y el servidor en Linux)

^^^^^^

### Un ejemplo más concreto

<img src="../../images/container-what-is-container-2.png" alt="Qué es un contenedor" class="r-stretch">

notes:

Supongamos que tenemos una aplicación [LAMP](https://es.wikipedia.org/wiki/LAMP). 

Esta aplicación utiliza:
* MySQL versión 8
* PHP versión 7.3.10
* Apache 2.4.41
* redis 5.0.5
 
^^^^^^

¿Cómo haríamos el desarrollo de manera "tradicional"?

<img src="../../images/lamp-development-1.jpg" alt="desarrollo web tradicional" class="r-stretch">

notes:

* Instalaríamos en nuestra máquina las librerías y dependencias.
* Instalaríamos en el servidor las librerías y dependencias
* Desarrollaríamos un sistema de despliegue X, usando jenkins o algún otro sistema de Integración contínua

Ahora bien ¿qué ocurre si el equipo crece?

^^^^^^
...el equipo empieza a crecer. 

<img src="../../images/lamp-development-2.jpg" alt="desarrollo web tradicional" class="r-stretch">

notes:

Si el equipo empieza a crecer la cosa se complica. Ahora tendremos tres personas desarrollando más el servidor en producción. 

* ¿Qué ocurre si necesitamos actualizar las librerías y dependencias?
* ¿Cómo mantenemos todos los equipos al día, tanto los de desarrollo como los de produción?
* ¿Qué ocurre si ahora cada uno quiere desarrollar en su propio sistema operativo?

^^^^^^
...el equipo sigue creciendo... 

<img src="../../images/lamp-development-3.jpg" alt="desarrollo web tradicional" class="r-stretch">

notes:

El equipo sigue creciendo y entra en juego la gestión de las personas...

* Unos quieren trabajar en ubuntu y otros en FreeBSD. Está el que no sabe linux y quiere windows y el que si le quitas el Mac le dan ataques de ansiedad...
* Se empieza a perder tiempo precioso en la gestión de todas estas librerías
* Empiezan a escucharse "En mi máquina funciona"

^^^^^^

...el equipo sigue creciendo... 

<img src="../../images/lamp-development-4.jpg" alt="desarrollo web tradicional" class="r-stretch">

notes:

🔥🔥🔥🔥🔥🔥🔥

^^^^^^

Y cuando pensábamos que la cosa no podía ir peor...

<img src="../../images/lamp-development-5.jpg" alt="desarrollo web tradicional" class="r-stretch">

^^^^^^

👱🔫

^^^^^^

### Posibles soluciones

* Herramientas como [Vagrant](https://www.vagrantup.com/) o [Puppet](https://puppet.com/)
* Virtualización
* Containers

^^^^^^

<img src="../../images/container-what-is-container-2.png" alt="Qué es un contenedor" class="r-stretch">

^^^^^^

* Cada contenedor encapsula software y todas sus dependencias
* El contenedor se puede replicar de forma exacta en cualquier máquina
* Pueden coexistir diferentes versiones del mismo software ya que cada una de ellas está aislada del resto
* Se pueden desplegar en casi cualquier máquina (Linux, Windows, Windows 10 y Windows Server 2016) en máquinas virtuales y en la nube (todos los proveedores de cloud los soportan)

^^^^^^
Otro entorno en el que Docker brilla: Microservicios

<img src="../../images/microservices.jpg" alt="Qué es un contenedor" class="r-stretch">

notes:

Un entorno en el que Docker brilla es en aplicaciones distribuidas a través de [Microservicios](https://microservices.io/)

Si un desarrollador está trabajando en una fracción de los microservicios, puede descargarse únicamente los contenedores correspondientes a esos servicios.

Además, lo normal es que cada uno de estos microservicios tengan sus propias dependencias. Por ejemplo, uno puede estar programado en Java 7 y otro en Java 10. Si eso es así, **el desarrollador necesitará configurar diferentes entornos java en su máquina para poder trabajar.**

Incluso diferentes microservicios pueden estar programados en lenguajes diferentes, conviviendo en un mismo sistema distribuido lengajes y tecnologías como Java, .NET, node, python, go, erlang, etc...

El uso de contenedores en un entorno de estas caraterísticas hace al equipo muy productivo, no solo en el desarrollo sino también en la automatización de los procesos de despliegue.

^^^^^^

Una nota personal... recordad que no es oro todo lo que reluce 

<img src="../../images/before-after-devops.jpg_large" alt="before after devops" class="r-stretch">

[https://twitter.com/turnoff_us/status/917564505416073216](https://twitter.com/turnoff_us/status/917564505416073216)<!-- .element: class="text-small"-->

notes:

Docker efectivamente resuelve estos problemas, al menos esta es mi experiencia personal.

Trabajando en varios proyectos de forma simultánea, algunos de ellos con versiones antiguas con varios años de antiguedad y ya sin soporte (por ejemplo php 5.2), he decir que docker nos ha ayudado bastante a gestionar los entornos de manera muy efectiva.

Aún así, introducir docker añade un nivel de complejidad adicional al proceso de desarrollo y despliegue. 

Durante la instalación hemos comentado varios problemas a los que nos hemos tenido que enfrentar, especialmente fuera de entornos Linux.

Por ello, el equipo debe valorar adecuadamente qué gana a cambio de esta complejidad añadida.

^^^^^^

* Se añade complejidad al proceso de desarrollo (esto lo iremos comentado a lo largo del resto de módulos, prácticas y ejercicios.
* Ojo con Docker for Mac y Docker for Windows y sus problemas de rendimiento ([aquí un ejemplo](https://www.google.com/search?q=docker+performance+in+osx&oq=docker+performance+in+osx&aqs=chrome..69i57j0.6298j0j4&sourceid=chrome&ie=UTF-8))
* El programador debe aprender una nueva tecnología para poder incorporarse al equipo

