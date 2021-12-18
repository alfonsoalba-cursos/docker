### 💻️ Ejercicio 💻️

Accede a tu app en rails usando un reverse proxy

Algunas pistas:

* Necesitarás dos contenedores que puedan comunicarse entre sí
* Si usas el _bridge_ por defecto te va a resultar un poco más complicado
* En las notas del profesor tienes una configuración básica de nginx
  actuando como reverse proxy

notes:

A continuación un ejemplo de configuración básica de nginx trabajando como reverse proxy:

```nginx
upstream app {
    # Path to Puma SOCK file, as defined previously
    server http://url.com fail_timeout=0;
}

server {
    listen 80;
    server_name localhost;

    root /home/deploy/appname/public;

    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://app;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
```

### 💻️ Ejercicio, para nota 💻️

Configura el acceso SSL en nginx con un certificado autofirmado a través de 
la URL https://www.alfonso.com
