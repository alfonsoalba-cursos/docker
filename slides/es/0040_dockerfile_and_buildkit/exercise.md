^^^^^^

### 💻️ Laboratorio ️️💻️

* En el módulo anterior, creamos un contenedor con nuestra aplicación en rails ¿te acuerdas?
* Si quisieses crear una app en rails nueva ¿qué tendrías que hacer?
* Crea un `Dockerfile` para evitarlo
* Sube la imagen a tu cuenta de Docker Hub y pidele a algún commpañero que la ejecute en un
  contenedor

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
