Antes de empezar vamos a ver un ejemplo de para qué sirve Docker.

Vamos a descargarnos las diapositivas de este módulo y servirlas en local (cada uno en su máquina)

^^^^^^
Empezamos clonando el repositorio con las diapositivas:

<pre><code>

# git clone https://github.com/Be-Core-Code/curso-intro-docker-modulo-10.git

</code></pre>


^^^^^^

Instalamos las dependencias:

<pre><code>

# docker-compose run --rm node npm install

</code></pre>

^^^^^^

Levantamos el contenedor...

<pre><code>

# docker-compose up

</code></pre>

^^^^^^

...y accedemos a las diapositivas

<pre><code>

# curl http://localhost:8000

</code></pre>

&#x1F60E;
 
^^^^^^

* No ha sido necesario instalar nada en nuestra máquina &#x1F9DE;
* Podéis trabajar sobre el código: 
  * por ejemplo, editar una diapositiva, hacer un commit y hacer push a un repositorio (...que no sea el mío porque no tenéis permiso &#x1F6AB;)
