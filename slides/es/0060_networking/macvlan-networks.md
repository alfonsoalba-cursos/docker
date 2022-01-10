### macvlan networks

Cierto tipo de aplicaciones, pueden necesitar estar directamente conectadas a una
interfaz de red

Por ejemplo, imagina que estáis desarrollando una aplicación de monitorización 
de tráfico de red

^^^^^^

### Requisitos

* La mayoría de proveedores cloud bloquean este tipo de redes. Para poder configurarla
  es necesario en muchos casos tener acceso físico al equipo
* Sólo funciona en Linux
* Necesita como mínimo la versión 3.9 del kernel de Linux, aunque se recomienda 
  la versión 4.0 o superior

notes:

No vamos a entrar en más detalles sobre este tipo de red ya que cubre una necesidad
muy específica.

Me vale con que por el momento sepáis que existe de forma que si algún día llegáis 
a necesitarla, podáis profundizar en su uso.

Documentación en docker sobre este tipo de redes:
* [Redes macvlan](https://docs.docker.com/network/macvlan/)
* [Tutorial](https://docs.docker.com/network/macvlan/) Yo he seguido este tutorial
  en Docker for Mac, aunque luego no fui capaz de alcanzar con un ping desde el host la interfaz
  de red que creé en el tutorial


^^^^^^

### Para terminar...

Os dejo un enlace al artículo 
[Exploring Scalable, Portable Docker Swarm Container Networks](https://docs.mirantis.com/containers/v3.0/dockeree-ref-arch/networking/scalable-container-networks.html) 
que trata en profundidad sobre la arquitectura de red en contenedores

