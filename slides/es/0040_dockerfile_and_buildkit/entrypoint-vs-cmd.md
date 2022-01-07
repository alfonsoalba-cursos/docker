### `ENTRYPOINT` vs `CMD`

Ambas instrucciones se utilizan para determinar el comando a ejecutar por defecto
cuando se levanta un contenedor que utiliza esta imagen.

¿Cuándo usar uno y cuándo el otro?

notes:

* [Documentación para `ENTRYPOINT`](https://docs.docker.com/engine/reference/builder/#entrypoint)
* [Documentación para `CMD`](https://docs.docker.com/engine/reference/builder/#cmd)

^^^^^^

### `ENTRYPOINT`

**Usar `ENTRYPOINT` cuando queremos que nuestro contenedor se utilice como si fuese un comando
al que pasas argumentos**

^^^^^^

### `ENTRYPOINT`

El comando `docker run <image> [ARGUMENTOS]` pasa todos los argumentos que se escriban en la 
línea de comandos y los agrega como argumentos del comando definido en `ENTRYPOINT`


^^^^^^

### `ENTRYPOINT`

```Dockerfile
FROM alpine:latest
ENTRYPOINT ["ls"]
```

Construimos la imagen:

```bash
> docker build -t='mils' .
```

^^^^^^
### `ENTRYPOINT`

Usamos la imagen como si fuese un comando al que pasamos argumentos:

```bash
> docker run --rm misls -l
```

notes:

Como se explica en la documentación de ambas instrucciones, cuando se usan de forma
conjunta, la instrucción `CMD` se puede usar para pasar parámetros por defecto al comando 
definido en `ENTRYPOINT`

Veamos un ejemplo:

```Dockerfile
FROM alpine:latest
ENTRYPOINT ["ls"]
CMD ["-a"]
```

Si contruimos esta imagen 

```bash
> docker build -t="mils" .
```

Y llamamos la ejecutamos:

```bash
> docker run --rm mils
```

Al utilizar `CDM`, el comando que se ejecutará será `ls -a`.

Cualquier parámetro que pasemos como argumento de `docker run` o `docker create`
sobreescribirá los que aparecen en `CMD` y se pasarán como argumento del
comando definido en `ENTRYPOINT`

Por ejemplo:

```bash
> docker run --rm mils -l /proc
```

En este caso, el argumento `-l proc` que pasamos a través de la línea de comandos
sobreescribirá el `-a` definido en la instrucción `CMD` de la imagen. 

^^^^^^

### `ENTRYPOINT` vs `CMD`

Ambos comandos aceptan dos formas de pasar los argumentos:

* _exec form_: `ENTRYPOINT ["ejecutable", "parametro1", "parametro2", ...]`
* _shell form_: `ENTRYPOINT ejecutable parametro1 parametro2`

^^^^^^

### `ENTRYPOINT` vs `CMD`

¿Qué diferencia hay entre ellas?

Si se define el comando en formato _shell_ 
**este se ejecuta como un submando de `/bin/sh -c`**

Si se difine el comando en formato _exec_ **este se ejecuta directamente, sin shell intermedia**

^^^^^^
### `ENTRYPOINT` vs `CMD`

Si mirasemos los procesos

```bash
# shell form
PID  name
 1   /bin/sh -c
 2   \__ nginx -g "daemon off"
```

```bash
# exec form
PID  name
 1   nginx -g "daemon off"
```

^^^^^^

### _shell_ vs _exec_

_shell_ tiene la ventaja de que disponemos de una shell para ejecutar el comando
y podríamos hacer cosas como `CMD ls $HOME`.

La consecuencia de usar _shell_ es que el proceso 1 de nuestro contenedor no será 
el comando sino la shell, como vimos en la diapositiva anterior

Cuando mandamos señales al contenedor, será la shell quién las reciba, no el contenedor.

^^^^^^

### _shell_ vs _exec_

Docker recomienda en su documentación el uso de _exec_

notes:

Cuando se usa _exec_, los parámetros se parsean como un array JSON. Eso significa
que los elementos del array deberán is entre comillas dobles:


```Dockerfile
CMD ["nginx", "-g", "daemon off"]
```
