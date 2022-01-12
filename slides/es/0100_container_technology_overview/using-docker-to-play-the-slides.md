Antes de empezar vamos a ver un ejemplo de para qué sirve Docker.

Vamos a descargarnos las diapositivas de este módulo y servirlas en local (cada uno en su máquina)

```shell
$ docker run --rm --name slides -p 8080:80 kubernetes/slides-docker
```

^^^^^^

...y accedemos a las diapositivas

```shell
$ curl http://localhost:8000
```

No ha sido necesario instalar nada en nuestra máquina 

&#x1F9DE; &#x1F60E;