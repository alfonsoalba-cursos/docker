### host networking

Si usas la red `host` al crear un contenedor, **la red del contenedor utiliza
la red del host directamente**

No se crea un stack de red aislado para el contenedor

El contenedor comparte **el _networking namespace_ del kernel del host**


^^^^^^

### host networking

**No funciona en Docker for Mac ni en Docker for Windows**

[Documentación](https://docs.docker.com/network/host/)

[Tutorial](https://docs.docker.com/network/network-tutorial-host/)

^^^^^^

### 💻️ Práctica 3: `host` network 💻️

Esta práctica la realizaré sobre una máquin virtual con Linux instalado.

Vamos a instalar un servidor web en el puerto 9090 del host.

* Me conecto a la máquina por SSH

```bash
> ssh mimaquinavirtual.com
mimaquinavirtual:> 
```

* Esta máquina virtual ya tiene docker instalado

^^^^^^

#### 💻️ Práctica 3: `host` network 💻️

* Abrimos el puerto 80 del cortafuegos

```bash
mimaquinavirtual:> sudo ufw allow 80
mimaquinavirtual:> sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
7022                       ALLOW       Anywhere
80                       ALLOW       Anywhere
7022 (v6)                  ALLOW       Anywhere (v6)
80 (v6)                  ALLOW       Anywhere (v6)
```

^^^^^^

#### 💻️ Práctica 3: `host` network 💻️

* Levantamos el contenedor usando la red del host

```bash
> docker container run --detach --network host dockersamples/101-tutorial
```

Accedemos usando el navegador a mimaquinavirtual:80 para ver el tutorial.

notes:

Una vez terminada la práctica:

* Parar el contenedor
* Borrar el contenedor
* Borrar la imagen
* Cerrar los puertos
