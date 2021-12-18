### Application Isolation

Separación de un programa o el stack de una aplicación del resto de procesos en ejecución

^^^^^^

### ¿Cómo lo podemos conseguir?

* Utilizando una máquina diferente &#x1F926; <!-- .element: class="fragment" data-fragment-index="1" -->
* En linux, usando chroot <!-- .element: class="fragment" data-fragment-index="2" -->
* Utilizando una máquina virtual <!-- .element: class="fragment" data-fragment-index="3" -->
* Utilizando contenedores <!-- .element: class="fragment" data-fragment-index="4" -->
* Otras tecnologías <!-- .element: class="fragment" data-fragment-index="5" -->
  * [Jails de BSD](https://www.freebsd.org/doc/handbook/jails.html) <!-- .element: class="fragment" data-fragment-index="5" -->
  * [Solaris Zones](https://docs.oracle.com/cd/E37929_01/html/E36580/zonesoverview.html)<!-- .element: class="fragment" data-fragment-index="6" -->
^^^^^^

<img alt="Containers vs Virtual Machines" src="../../images/containers_vs_virtual_machines.png"  class="r-stretch" />

<small>[_Fuente: Blog de docker_](https://blog.docker.com/2018/08/containers-replacing-virtual-machines/)</small>

notes:

[https://devopsbootcamp.osuosl.org/application-isolation.html](https://devopsbootcamp.osuosl.org/application-isolation.html)

Virtual Machines are programs that act like (or emulate) another computer (Also called a “guest”) that’s running on your physical computer (The “host”). This is useful because a VM completely isolates programs running from the host computer.

Here is a demonstration showing the processes inside of a VM versus a host OS

<pre>
[vm] # ps aux
USER PID %CPU %MEM    VSZ   RSS TTY STAT START   TIME COMMAND
root   1  0.0  0.6 110564  3164 ?   Ss    2015  11:17 /lib/systemd/systemd --system --deserialize 15
root   2  0.0  0.0      0     0 ?   S     2015   0:00 [kthreadd]
root   3  0.0  0.0      0     0 ?   S     2015   3:55 [ksoftirqd/0]
root   5  0.0  0.0      0     0 ?   S<    2015   0:00 [kworker/0:0H]
[... 120+ more lines ...]

[host] # ps aux
USER  PID %CPU %MEM    VSZ   RSS TTY STAT START   TIME COMMAND
root    1  0.0  0.1 200328  5208 ?   Ss   Aug25   0:44 /sbin/init
root    2  0.0  0.0      0     0 ?   S    Aug25   0:00 [kthreadd]
root    3  0.0  0.0      0     0 ?   S    Aug25   0:05 [ksoftirqd/0]
root    5  0.0  0.0      0     0 ?   S<   Aug25   0:00 [kworker/0:0H]
[... 240+ more lines ...]

</pre>
 
### OS Emulation

Let’s talk about that emulation problem. Imagine you are running a computer that has an X86_64 CPU on it. You want to emulate a computer with an ARM5 CPU. The emulated operating system makes system calls to the ‘hardware’ it thinks it is running on. The host operating system translates those system calls into real system calls on the actual hardware. This translation is cost intensive and usually slow, but it’s gotten a lot better over the decades. When emulating a separate CPU architecture, optimizations usually have to be made for the emulated OS to be usable.

When you are emulating an X86_64 VM on an X86_64 piece of hardware, an optimization that can be made in which the host OS passes the system calls directly to the hardware without having to translate anything. This is done by a hypervisor which enforces certain security protocols so the two operating systems (host and guest) are still isolated, but things go much faster.


^^^^^^

El comando ps en un sistema virtualizado

```shell
[vm] # ps aux
USER PID %CPU %MEM    VSZ   RSS TTY STAT START   TIME COMMAND
root   1  0.0  0.6 110564  3164 ?   Ss    2015  11:17 /lib/systemd/systemd --system --deserialize 15
root   2  0.0  0.0      0     0 ?   S     2015   0:00 [kthreadd]
root   3  0.0  0.0      0     0 ?   S     2015   3:55 [ksoftirqd/0]
root   5  0.0  0.0      0     0 ?   S<    2015   0:00 [kworker/0:0H]
[... 120+ more lines ...]

[host] # ps aux
USER  PID %CPU %MEM    VSZ   RSS TTY STAT START   TIME COMMAND
root    1  0.0  0.1 200328  5208 ?   Ss   Aug25   0:44 /sbin/init
root    2  0.0  0.0      0     0 ?   S    Aug25   0:00 [kthreadd]
root    3  0.0  0.0      0     0 ?   S    Aug25   0:05 [ksoftirqd/0]
root    5  0.0  0.0      0     0 ?   S<   Aug25   0:00 [kworker/0:0H]
[... 240+ more lines ...]
```

^^^^^^

El comando ps en un contenedor

```shell
[container] $ ps aux
PID   USER     TIME   COMMAND
1     root     0:00   sh
6     root     0:00   ps aux
```

^^^^^^

En lugar de emular el _guest SO_, un contenerdor usa el mismo kernel que el host pero de 
alguna manera "miente" al proceso que se ejecuta en el contenedor y le hace creer que es la 
única aplicación que se está ejecutando en ese SO.

notes:

[https://devopsbootcamp.osuosl.org/application-isolation.html#containers](https://devopsbootcamp.osuosl.org/application-isolation.html#containers)

Containers approach application isolation from a different angle. Instead of emulating the guest OS, containers use the same kernel as the host but lie to the guest process and tell it that it’s the only application running on that OS. Containers bypass the emulation problem by avoiding emulation altogether. They run on the same hardware as the host OS but with a thin layer of separation.

Containers have very become popular recently, but their underlying technologies aren’t new. Many application developers and system administrators have begun migrating toward using Containers over VMs as they tend to be more performant, but the industry as a whole is waiting for them to get a bit more battle-tested.

Here is the previous demonstration in a container:

<pre>
[container] $ ps aux
PID   USER     TIME   COMMAND
1     root     0:00   sh
6     root     0:00   ps aux
</pre>

As you can see, instead of emulating an entire OS (running 100+ processes), the container is told that it’s processes (sh and ps in this case) are the only one in this environment. In theory this prevents a malicious attack from inside the container from invading the host OS.

^^^^^^

#### Control Groups

¿Qué herramientas nos da el Kernel de Linux para aislar los procesos?

* Control Groups ([cgroups](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/resource_management_guide/index)) 
  encargados de limitar los recursos utilizados por los procesos

notes:
[https://devopsbootcamp.osuosl.org/application-isolation.html#container-technologies](https://devopsbootcamp.osuosl.org/application-isolation.html#container-technologies)

CGroups
A Linux kernel-level technology that name-spaces processes. It performs many functions, but it’s used by container engines to convince a process that it’s running in its own environment. This is what isolates a process from other processes, if they think they’re the only thing running they can’t tamper with the host OS.

#### Control Groups

* Limitan los recursos utilizados por los procesos
* Realizan algunas tareas de control de acceso, por ejemplo a dispositivos (devices)
* Congelado (freezing) de grupos de procesos

^^^^^^

#### Namespaces

* Kernel [namespaces](http://man7.org/linux/man-pages/man7/namespaces.7.html) 
  *Son los encargados del aislamiento del contenedor*

Los procesos que se ejecutan dentro del namespace de un contenedor *no pueden ver ni afectar* los procesos
de otros contenedores o del host


^^^^^^

#### Namespaces

* PID namespace para aislamiento de procesos 
* NET namespace para gestión de interfaces de red
* IPC namespace para gestión del acceso a recursos IPC
* MNT namespace para gestión de puntos de montaje
* UTS namespace para gestión de nombres de host (hostname)
* User namespace para gestión de usuarios y UIDs

^^^^^^

### Linux Kernel Capabilities (```libcap```)

Los ["capabilities"](http://man7.org/linux/man-pages/man7/capabilities.7.html) 
del kernel de Linux convierten el problema binario “root/non-root” 
en un sistema de control de acceso mucho más fino

Por ejemplo: si le damos al usuario ```apache``` el "capability" ```net_bind_service``` ya no necesita ejecutarse como root

notes:

Antes de las "capabilities" sólo se podía acceder como root o como usuario. Por ejemplo,
un servicio web se ejecuta como root, abre el puerto 80 (que es privilegiado) para escuchar en él
y "suelta" los privilegios de root para ejecutarse como un usuario del sistema.

Sólo necesita ser root para abrir el puerto 80 que es un puerto privilegiado

El comando sudo nos permite hacer cosas como root pero de nuevo una vez sudo nos da acceso, ejecutamos
el comando que sea como root, es decir, pasamos de no ser root a serlo para ejecutar sólo un comando.
Con las capabilities, levantamos el servidor web sin necesidad de ser root en ningún momento.




