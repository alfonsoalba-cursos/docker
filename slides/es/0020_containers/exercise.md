### Ejercicio final

* Usando docker, ejecutar el siguiente script de ruby

```bash
puts "Bienvenido a Ruby!! #{RUBY_VERSION}"
```

* Pista: mirar la opción -e del comando ruby
* Pista: utilizar ruby:lastest como imagen para el contenedor

notes:

Solución

```bash
> docker run --rm ruby ruby -e 'puts "Bienvenido a Ruby #{RUBY_VERSION}"'
Unable to find image 'ruby:latest' locally
latest: Pulling from library/ruby
Digest: sha256:358f16e92d0f66599103318f7a8528d449b0973fd89e46a1a5c47cec7479f09b
Status: Downloaded newer image for ruby::latest
Bienvenido a Ruby 2.6.3
```
