### 💻 Ejercicio 💻

En la web hay varios cientos de miles de tutoriales sobre cómo crear nuestro
primer proyecto en rails.

En este caso, vamos a empezar a hacer nuestra primera app en rails siguiendo la 
[documentación oficial](https://guides.rubyonrails.org/getting_started.html)

Usando contenedores, es decir, sin instalar nada en vuestra máquina, realizad el 
[primer paso del tutorial de rails](https://guides.rubyonrails.org/getting_started.html#starting-up-the-web-server).

notes:

### ¿Se puede cambiar los puertos expuestos una vez creado el contenedor?

En la realización de este ejercicio, lo más probable es que cuando llegue el momento de levantar la aplicación en rails

```bash
> bin/rails serve
```

te percates de que para ver el contenido tienes que acceder al puerto 3000 del contenedor.

Esto es normal ya que, como os indiqué cuando empezamos el ejercicio, he buscado
una tecnología que no conozcáis de manera intencionada. El ejercicio está 
pensado para que esto ocurra.

Así que la siguiente pregunta es, si he creado el contenedor sin exponer ningún 
puerto... ¿Tengo manera de cambiar esa configuración a posteriori?

La respuesta es que a día de hoy [no es posible](https://stackoverflow.com/questions/19335444/how-do-i-assign-a-port-mapping-to-an-existing-docker-container/19417296#19417296)

¿Qué podemos hacer entonces? Tenemos varias opciones:

1. Crear una nueva imagen de nuestro contenedor usando `docker commit` y levantar
   un nuevo contenedor con ella.
1. Editar los ficheros de configuración del contenedor para modificar la configuración
   "a pelo" (ver por ejemplo [las diferentes respuestas a la pregunta anterior en stack overflow](https://stackoverflow.com/questions/19335444/how-do-i-assign-a-port-mapping-to-an-existing-docker-container/19417296#19417296) 
   o el resumen que se hace en [este artículo](https://mybrainimage.wordpress.com/2017/02/05/docker-change-port-mapping-for-an-existing-container/))

### ¿Se puede levantar el contenedor exponiendo el puerto 3000 y luego levantar la aplicación en el puerto 3000?

Sí, eso sí lo podemos hacer. Si levantas el contenedor exponiendo un puerto y luego 
intentas levantar la aplicación, **no podrás acceder desde el host**

Veamos un ejemplo:

```bash
> docker run --rm -p "8005:8005" -ti becorecode/curso-intro-docker-modulo-5 sh
~ $
```

Si intentamos acceder al puerto 8005 del host nos dirá que la página no existe.

Si ahora dentro de la shell, levantamos el servicio en el puerto 8005:

```bash
~ $ npm start -- --port=8005
```

y recargamos la página http://localhost:8005 en el host, sí que veremos las diapositivas.

En la realización del ejercicio, tendrás que hacer algo parecido para ver la app 
en rails.




