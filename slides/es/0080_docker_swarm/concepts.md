### [¿Qué es Docker Swarm?](https://docs.docker.com/engine/swarm/)

Un _swarm_ es un cluster de hosts de docker en los que se pueden desplegar servicios.

^^^^^^

#### ¿Qué es Docker Swarm?

Viene incluido en docker desde la versión 1.12.

Para instalar, configurar y gestionar los _swarms_ utilizamos el mismo cliente
que hemos utilizado hasta ahora

^^^^^^

#### [¿Qué es Docker Swarm? Tipos de nodos](https://docs.docker.com/engine/swarm/key-concepts/)

* _Manager_: 
  * encargado de organizar y despachar los diferentes trabajos del _swarm_ en
    forma de tareas (_Tasks_)
  * responsable de montorizar el cluster y mantenerlo activo
  * Se puede tener más de uno. En ese caso, necogiarán entre ellos cuál 
    actuará como _leader_
* _Worker_: ejecuta las tareas que despacha el _Manager_

^^^^^^

#### ¿Qué es Docker Swarm? Tipos de nodos

* Por defecto, tanto los nodos de tipo _Manager_ como los de tipo _Worker_ ejecutarán
  tareas
* Podemos configurar el _Manager_ para que sólo gestione el _swarm_ y no ejecute tareas

^^^^^^

#### ¿Qué es Docker Swarm? Servicios y Tareas

Un **servicio** (_service_) es la definición de las **tareas** (_task_) que deben
ejecutarse en un nodo

Para especificar un **servicio** se debe definir la imagen y el comando a ejecutar
por los contenedores que se creen a partir de ella

^^^^^^

#### ¿Qué es Docker Swarm? Servicios y Tareas

Modos de ejecución de los servicios:

* _Replicated services_ el _manager_ distribuye replicas de las tareas entre los 
  _workers_ según el parámetro _scale_ especificado
* _Global services_ el _manager_ distribuye una tarea en cada _worker_ del cluster

^^^^^^

#### ¿Qué es Docker Swarm? Servicios y Tareas

Una **tarea** incluye un contenedor de docker y los comando a ejecutar dentro del
contenedor

Es la unidad atómica de _scheduling_ del cluster 

Una vez una tarea se ha asignado a un nodo, esta no se puede mover a otro: sólo puede
ejecutarse o fallar

^^^^^^

#### ¿Qué es Docker Swarm? Balanceo de carga

Docker Swarm se encarga de balancear la carga entre los _workers_ del cluster

<img alt="ingress load balancing" src="../../images/ingress-load-balancing.png" class="r-stretch"/>


notes:

El _manager_ puede publicar un puerto y asignarlo a un servicio. Una vez publicado
se puede acceder a ese servicio a través de cualquier nodo del cluster.

Si se intenta a acceder a un servicio en un nodo que no tiene un contenedor
levantado, el nodo enrutará la petición a otro que sí lo tenga en ejecución.

^^^^^^

#### ¿Qué es Docker Swarm? DNS

Al igual que ocurría con `dockerd`, _swarm_ disponde un DNS interno que permite
encontrar los servicios usando su nombre


^^^^^^

#### ¿Qué es Docker Swarm? Documentación

* [Swarm mode overview](https://docs.docker.com/engine/swarm/)
* [Swarm mode key concepts](https://docs.docker.com/engine/swarm/key-concepts/)
