### Docker Flavours
馃崷

^^^^^^

### 馃崷Docker flavours 馃崷

![Docker flavours](../../images/docker-flavours.png)<!-- .element: class="plain" -->

Fuente: [Documentaci贸n de Docker](https://docs.docker.com/get-docker/)

notes:

En el a帽o 2021, Docker pas贸 a un modelo de suscripci贸n en un intento de monetizar
su producto estrella: Docker for Desktop.

A finales de 2021, se sabe que se est谩 desarrollando una versi贸n para Linux de
la aplicaci贸n Docker for Descktop:
* https://www.docker.com/blog/accelerating-new-features-in-docker-desktop/
* Se puede acceder a ella a trav茅s del 
  [Docker Developer Preview Program](https://www.docker.com/community/get-involved/developer-preview)

^^^^^^

### Docker Engine - CE
* Es la que vamos a instalar para el curso
* Tiene tres canales:
  * Stable
  * Test
  * Nightly
* Se mantiene en repositorios p煤blicos

^^^^^^
### Docker Engine - CE

* Versionado: ```YY.mm.<patch>```
  * ```YY.mm``` corresponden al a帽o y mes de la versi贸n a partir de la versi贸n ```18.09```
  * **No sigue [versionado sem谩ntico](https://semver.org/)**
  * La cadencia de versiones es aproximadamente de 6 meses
  * ```patch``` puede incluir informaci贸n adicional como beta, RC, etc.

^^^^^^

### Docker Engine - CE

[Modelo de suscripci贸n](https://www.docker.com/pricing)

* Diversos planes (free, personal, pro, business)
* Entre 0$ y 21$ al mes por usuario
* Integrado con [hub.docker.com](https://hub.docker.com)


^^^^^^
### (antiguo) Docker Enterprise

Actualmente [Mirantis Kubernetes Engine](https://www.mirantis.com/software/mirantis-kubernetes-engine/)
* Gesti贸n de clusters
* Integraci贸n con centros de datos y nubes p煤blicas y privadas
* Soporte para Kubernetes y Swarm, tanto en Windows como en Linux
* _Enterprise ready_: Role based access control, seguridad integrada, est谩ndares de arquitectura, _compliance_
