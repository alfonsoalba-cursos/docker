### `RUN`: Ejecutando comandos

_shell form_
```Dockerfile
RUN <command>
```

_command form_
```Dockerfile
RUN ["executable", "param1", "param2"]
```

notes:

Esta instrucción ejecutar los comandos especificados en una nueva capa situada sobre la 
imagen actual y después consolida (commit) el resultado. La imagen resultante se
utilizará en el siguiente paso del fichero `Dockerfile`

^^^^^^

### `RUN`: Ejecutando comandos

Si se usa _shell form_ no dependemos de la existencia de una shell como `/bin/sh`
para ejecutar los comandos. A cambio, **no se pueden usar variables como $HOME 
ya que no existe shell**

notes:

Algunas notas sobre _shell form_:

* Se pueden ejecutar comandos en varias líneas separándolas con `\``

```Dockerfile
RUN source $HOME/.bashrc; \
echo $HOME
```

* Se puede cambiar la shell por defecto (`/bin/sh -c` en linux y `cmd /S /C` en
  windows):
  * Usando la instrucción `SHELL`
  * Usando `RUN ["/bin/bash", "command"]`

^^^^^^

### 💻️ Ejercicio ️️💻️

* En el módulo anterior, creamos un contenedor con nuestra aplicación en rails ¿te acuerdas?
* Si quisiese crear una app en rails nueva ¿qué tendrías que hacer?
* Crea un `Dockerfile` para evitarlo

notes:

Pues básicamente, cada vez que quieras crear una app en rails, tienes que hacer los mismos pasos:

* Crear un contenedor basado en ruby

```bash
> docker run --name my_rails_app ruby bash
```

* Instalar rails

```bash
> root 167ab4cd> gem install rails
```

Crea una image para evitar tener que hacer esto cada vez.

^^^^^^

### 💻️ Ejercicio (extra) ️️💻️

* Sube tu `Dockerfile` a un repositorio en github
* Crea un repositorio en Docker Hub y conectalo con github
* Verifica que al hacer push al repositorio en github, tu imagen se actualiza
  en Docker Hub
