### Networking en docker

El sistema de red de docker está basado en un sistema de drivers que se pueden
usar y configurar en los contenedores

^^^^^^

### Networking en docker

Los drivers que docker incluye por defecto son

* `bridge` -> contenedores independientes que necesitan comunicarse entre sí
* `host` -> Elimina el aislamiento en la red: el contenedor usa la red del host directamente
* `overlay` -> comunicación entre dos instancias `dockerd` y comunicación entre servicios swarm
* `macvlan` -> Asigan una dirección MAC al contenedor: el contenedor aparece en la red como un dispositivo físico
* `none` -> Desabilita la red


