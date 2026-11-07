# Viernes de Bioinformática

**Fecha:** 13 de noviembre de 2026  
**Curso:** Bioinformática reproducible con R: *Del código al contenedor*

## Introducción

Este repositorio contiene el material práctico del curso **Bioinformática reproducible con R: Del código al contenedor**.

El objetivo es recorrer progresivamente diferentes niveles de reproducibilidad en un proyecto de R:

1. Administrar versiones de R con [`rig`](https://rig.r-lib.org/).
2. Gestionar dependencias y entornos reproducibles con [`renv`](https://rstudio.github.io/renv/articles/renv.html).
3. Organizar código R en módulos reutilizables con [`box`](https://klmr.me/box/).
4. Utilizar Git y GitHub para control de versiones.
5. Introducir los conceptos fundamentales de Docker.
6. Contenerizar un proyecto de R.
7. Publicar una imagen en [Docker Hub](https://hub.docker.com/).

Al finalizar el curso tendremos un proyecto de R versionado con Git, con sus dependencias registradas mediante `renv`, organizado mediante módulos y preparado para ejecutarse dentro de un contenedor Docker.

---

# 1. Preparar el repositorio Git

Antes de comenzar los ejercicios, crearemos un repositorio para ir registrando los cambios realizados durante el curso.

> Los requisitos de instalación de Git, Docker, Positron y WSL 2 se encuentran en el documento de requisitos del curso.

## Configurar Git

Comprueba que Git está instalado:

```bash
git --version
```

Configura tu nombre y correo electrónico:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@ejemplo.com"
```

Puedes revisar la configuración con:

```bash
git config --global --list
```

## Crear el repositorio en GitHub

Crea un nuevo repositorio en GitHub:

https://github.com/new

Por ejemplo, puedes llamarlo:

```text
viernes-bioinformatica
```

Clona el repositorio:

```bash
git clone https://github.com/<tu-usuario>/viernes-bioinformatica.git
```

Accede al directorio:

```bash
cd viernes-bioinformatica
```

Después de añadir el material inicial del curso:

```bash
git status
git add .
git commit -m "Add initial course files"
git push -u origin HEAD
```

A partir de este momento podremos utilizar Git para registrar los cambios realizados durante los ejercicios.

---

# 2. Administrar versiones de R con `rig`

[`rig`](https://rig.r-lib.org/) es un administrador de instalaciones de R que permite instalar y mantener diferentes versiones de R en el mismo sistema.

Comprueba si `rig` está instalado:

```bash
rig --version
```

Consulta las versiones de R disponibles:

```bash
rig available
```

Consulta las versiones instaladas:

```bash
rig list
```

Por ejemplo, para instalar R 4.6.1:

```bash
rig add 4.6.1
```

Comprueba nuevamente las versiones instaladas:

```bash
rig list
```

Puedes establecer una versión como predeterminada:

```bash
rig default 4.6.1
```

Comprueba qué versión de R se está utilizando:

```bash
R --version
```

## Instalación de `rig`

Si todavía no tienes `rig` instalado, consulta las instrucciones oficiales:

https://rig.r-lib.org/

En sistemas compatibles con el instalador mediante shell:

```bash
curl -LsSf https://r-lib.github.io/rig/install.sh | sh
```

---

# 3. Preparar las dependencias del sistema para R

Algunos paquetes de R necesitan bibliotecas del sistema para poder compilarse.

En Ubuntu o Debian podemos instalar algunas dependencias habituales con:

```bash
sudo apt-get update

sudo apt-get install -y \
    build-essential \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libdeflate-dev \
    libcurl4-openssl-dev \
    libgit2-dev \
    libtiff-dev \
    libuv1-dev
```

> No todos los paquetes de R necesitan estas dependencias. Las instalamos en este curso para disponer de un entorno preparado para compilar paquetes que las requieran.

---

# 4. Crear un entorno reproducible con `renv`

[`renv`](https://rstudio.github.io/renv/articles/renv.html) permite gestionar las dependencias de un proyecto de R de forma aislada y reproducible.

El archivo principal generado por `renv` es:

```text
renv.lock
```

Este archivo registra las versiones de R y de los paquetes utilizados por el proyecto.

## Instalar `renv`

Desde la consola de R:

```r
install.packages("renv")
```

## Inicializar el proyecto

Ejecuta:

```r
renv::init()
```

Esto inicializa `renv` en el proyecto.

Para proyectos que utilizan Bioconductor, también puedes inicializarlo indicando la versión de Bioconductor:

```r
renv::init(bioconductor = TRUE)
```

## Instalar paquetes

Con `renv` activo podemos instalar paquetes dentro del entorno del proyecto.

Por ejemplo:

```r
renv::install("jsonlite")
```

También podemos instalar varios paquetes:

```r
renv::install(c(
  "box",
  "dplyr",
  "ggplot2"
))
```

Después de instalar dependencias, registra su estado:

```r
renv::snapshot()
```

Esto actualizará:

```text
renv.lock
```

## Comandos principales de `renv`

### Comprobar el estado del proyecto

```r
renv::status()
```

### Instalar una dependencia

```r
renv::install("ggplot2")
```

### Registrar las dependencias actuales

```r
renv::snapshot()
```

### Restaurar un entorno

Si clonamos el proyecto en otro ordenador:

```r
renv::restore()
```

`renv` instalará las versiones registradas en `renv.lock`.

El flujo básico es:

```text
Instalar paquetes
       ↓
renv::snapshot()
       ↓
renv.lock
       ↓
Git
       ↓
Otro ordenador
       ↓
renv::restore()
```

---

# 5. Paquetes para el entorno de desarrollo

Algunos paquetes son útiles para mejorar la experiencia de desarrollo.

Por ejemplo:

```r
renv::install(c(
  "languageserver",
  "httpgd"
))
```

Estos paquetes son especialmente útiles en editores que proporcionan integración avanzada con R.

Si necesitas excluir determinados paquetes del análisis de dependencias de `renv`, puedes utilizar:

```r
renv::settings$ignored.packages(c(
  "languageserver",
  "httpgd"
))
```

Para consultar los paquetes ignorados:

```r
renv::settings$ignored.packages()
```

Para restablecer la configuración:

```r
renv::settings$ignored.packages(character())
```

> Utiliza `ignored.packages` únicamente cuando tengas una razón concreta para excluir esos paquetes del entorno reproducible del proyecto.

---

# 6. Organizar código R con `box`

[`box`](https://klmr.me/box/) permite organizar el código R en módulos reutilizables.

En lugar de concentrar todas las funciones en un único archivo o cargar scripts mediante `source()`, podemos separar responsabilidades en módulos.

Una estructura sencilla podría ser:

```text
viernes-bioinformatica/
├── modules/
│   └── expression_summary.R
├── analysis.R
├── renv.lock
└── README.md
```

## Crear un módulo

Crea:

```text
modules/expression_summary.R
```

con el siguiente contenido:

```r
summarize_expression <- function(data) {
  data |>
    dplyr::group_by(gene) |>
    dplyr::summarise(
      mean_expression = mean(expression),
      .groups = "drop"
    )
}
```

## Utilizar el módulo

Desde otro archivo R:

```r
box::use(./modules/expression_summary)
```

Creamos algunos datos:

```r
expression_data <- data.frame(
  gene = c("BRCA1", "BRCA1", "TP53", "TP53"),
  expression = c(8.2, 9.1, 5.4, 6.0)
)
```

Y utilizamos la función del módulo:

```r
expression_summary$summarize_expression(expression_data)
```

La ruta:

```r
./modules/expression_summary
```

corresponde a:

```text
modules/expression_summary.R
```

No es necesario escribir la extensión `.R`.

En este ejemplo utilizamos explícitamente:

```r
dplyr::group_by()
dplyr::summarise()
```

Por tanto, el módulo no necesita ejecutar:

```r
library(dplyr)
```

---

# 7. Ejemplo práctico en R

Vamos a crear un pequeño análisis reproducible utilizando `dplyr` y `ggplot2`.

## Datos de expresión

```r
library(dplyr)
library(ggplot2)

expression_data <- data.frame(
  gene = c(
    "BRCA1", "BRCA1",
    "TP53", "TP53",
    "EGFR", "EGFR"
  ),
  expression = c(8.2, 9.1, 5.4, 6.0, 7.3, 8.1)
)
```

Calculamos la expresión media:

```r
mean_expression <- expression_data |>
  group_by(gene) |>
  summarise(
    mean_expression = mean(expression),
    .groups = "drop"
  )
```

Visualizamos el resultado:

```r
ggplot(
  mean_expression,
  aes(x = gene, y = mean_expression, fill = gene)
) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Expresión media por gen",
    x = "Gen",
    y = "Expresión media"
  ) +
  theme_minimal()
```

---

## Ejemplo: número de lecturas por muestra

```r
read_counts <- data.frame(
  sample = c(
    "Muestra 1", "Muestra 1", "Muestra 1",
    "Muestra 2", "Muestra 2", "Muestra 2"
  ),
  gene = c(
    "BRCA1", "TP53", "EGFR",
    "BRCA1", "TP53", "EGFR"
  ),
  reads = c(120, 85, 64, 98, 110, 72)
)
```

Agrupamos por muestra:

```r
counts_by_sample <- read_counts |>
  group_by(sample) |>
  summarise(
    total_reads = sum(reads),
    .groups = "drop"
  )
```

Creamos el gráfico:

```r
ggplot(
  counts_by_sample,
  aes(x = sample, y = total_reads, fill = sample)
) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Lecturas totales por muestra",
    x = "Muestra",
    y = "Número de lecturas"
  ) +
  theme_minimal()
```

---

## Ejemplo: control de calidad

```r
quality_data <- data.frame(
  sample = c(
    "Muestra 1", "Muestra 1", "Muestra 1",
    "Muestra 2", "Muestra 2", "Muestra 2"
  ),
  measurement = c(12.4, 9.8, 11.1, 8.5, 10.6, 12.0)
)
```

Clasificamos las observaciones utilizando un umbral:

```r
quality_summary <- quality_data |>
  mutate(passes_threshold = measurement >= 10) |>
  group_by(sample) |>
  summarise(
    passing_fraction = mean(passes_threshold),
    .groups = "drop"
  )
```

Visualizamos el resultado:

```r
ggplot(
  quality_summary,
  aes(x = sample, y = passing_fraction, fill = sample)
) +
  geom_col(show.legend = FALSE) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Proporción de mediciones que superan el umbral",
    x = "Muestra",
    y = "Proporción"
  ) +
  theme_minimal()
```

---

# 8. Guardar el entorno reproducible

Después de añadir nuestro código y dependencias:

```r
renv::status()
```

Si todo está correcto:

```r
renv::snapshot()
```

Ahora registramos los cambios con Git:

```bash
git status
git add .
git commit -m "Add reproducible R environment"
git push
```

Hasta este punto tenemos:

```text
Código R
   +
Dependencias
   +
renv.lock
   +
Git
```

El siguiente paso será reproducir no solo las dependencias de R, sino también el **entorno de ejecución**.

Para ello utilizaremos Docker.

---

# 9. Introducción a Docker

[Docker](https://www.docker.com/) permite empaquetar una aplicación y sus dependencias dentro de una **imagen**.

Al ejecutar una imagen se crea un **contenedor**.

De forma simplificada:

```text
Dockerfile
    ↓
docker build
    ↓
Docker image
    ↓
docker run
    ↓
Container
```

Podemos pensar en la **imagen** como una plantilla inmutable y en el **contenedor** como una instancia creada a partir de esa imagen.

## Comprobar Docker

Comprueba la versión instalada:

```bash
docker --version
```

Después ejecuta:

```bash
docker run --rm hello-world
```

La imagen `hello-world` nos permite comprobar que Docker puede descargar y ejecutar correctamente un contenedor.

La opción:

```text
--rm
```

elimina automáticamente el contenedor cuando termina.

---

# 10. Primer Dockerfile

Antes de contenerizar nuestro proyecto de R, construiremos una imagen muy sencilla.

Crea un archivo:

```text
Dockerfile
```

con:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends cowsay \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/games/cowsay"]

CMD ["Hola desde Docker"]
```

## Construir la imagen

```bash
docker build -t curso-cowsay:1.0 .
```

La opción:

```text
-t curso-cowsay:1.0
```

establece el nombre y la etiqueta de la imagen.

El punto:

```text
.
```

indica que utilizaremos el directorio actual como contexto de construcción.

## Ver las imágenes

```bash
docker images
```

## Ejecutar el contenedor

```bash
docker run --rm curso-cowsay:1.0
```

También podemos proporcionar otro mensaje:

```bash
docker run --rm curso-cowsay:1.0 "Hola, Viernes de Bioinformática"
```

---

# 11. Imágenes y contenedores

Una distinción fundamental en Docker es:

```text
IMAGE
  │
  ├── container 1
  ├── container 2
  └── container 3
```

Una misma imagen puede utilizarse para crear múltiples contenedores.

## Descargar una imagen

Por ejemplo:

```bash
docker pull debian:bookworm-slim
```

## Ver imágenes locales

```bash
docker images
```

## Ver contenedores activos

```bash
docker ps
```

## Ver todos los contenedores

Incluidos los que ya han terminado:

```bash
docker ps -a
```

## Eliminar un contenedor

```bash
docker rm <container-id>
```

## Eliminar una imagen

```bash
docker rmi curso-cowsay:1.0
```

---

# 12. Ejecutar RStudio dentro de Docker

Una de las ventajas de los contenedores es que podemos ejecutar software sin instalarlo directamente en nuestro sistema.

Por ejemplo, podemos utilizar una imagen de RStudio del proyecto Rocker:

```bash
docker run --rm \
  -p 8787:8787 \
  -e PASSWORD=test \
  rocker/rstudio:4
```

Después abre en el navegador:

```text
http://localhost:8787
```

Para montar el directorio actual dentro del contenedor:

```bash
docker run --rm \
  -p 8787:8787 \
  -e PASSWORD=test \
  -v "$PWD:/home/rstudio/" \
  rocker/rstudio:4
```

El directorio actual estará disponible en el contenedor en:

```text
/home/rstudio/project
```

> La contraseña `test` se utiliza únicamente para este ejercicio local. No utilices contraseñas simples en despliegues reales.

---

# 13. Crear un Dockerfile para un proyecto de R

Hasta ahora hemos utilizado imágenes existentes.

El siguiente paso es crear una imagen que contenga nuestro propio proyecto de R.

Una estructura simplificada sería:

```text
viernes-bioinformatica/
├── modules/
├── analysis.R
├── renv.lock
├── renv/
├── Dockerfile
└── README.md
```

Conceptualmente queremos reproducir:

```text
Proyecto R
    +
Versión de R
    +
Paquetes de renv.lock
    +
Código
      ↓
Docker image
```

---

# 14. Generar un Dockerfile con `dockerfiler`

El paquete [`dockerfiler`](https://github.com/ThinkR-open/dockerfiler) permite generar Dockerfiles desde R.

Podemos instalarlo con:

```r
renv::install("ThinkR-open/dockerfiler")
```

Después:

```r
library(dockerfiler)
```

Podemos generar un Dockerfile a partir de `renv.lock`:

```r
my_dock <- dock_from_renv(
  lockfile = "renv.lock",
  user = NULL
)
```

Comprueba el resultado:

```r
my_dock
```

Y escribe el Dockerfile:

```r
my_dock$write("Dockerfile")
```

> El Dockerfile generado es un punto de partida. Antes de utilizarlo en producción conviene revisar la imagen base, las dependencias del sistema, los permisos, la seguridad y la estrategia de instalación de paquetes.

---

# 15. Construir nuestra imagen

Desde el directorio que contiene el `Dockerfile`:

```bash
docker build -t mi-imagen:1.0 .
```

Comprueba que la imagen existe:

```bash
docker images
```

---

# 16. Publicar una imagen en Docker Hub

Para publicar la imagen necesitaremos una cuenta de Docker Hub.

Primero inicia sesión:

```bash
docker login
```

También puedes especificar el usuario:

```bash
docker login -u tu_usuario
```

Docker solicitará la contraseña o token de acceso de forma interactiva.

> **Importante:** nunca escribas un Personal Access Token (PAT) en el Dockerfile, en scripts que vayas a versionar o directamente en un repositorio Git.

## Crear una etiqueta para Docker Hub

Las imágenes publicadas deben utilizar el nombre de usuario o namespace correspondiente.

Por ejemplo:

```bash
docker tag mi-imagen:1.0 tu_usuario/mi-imagen:1.0
```

Comprueba:

```bash
docker images
```

Deberías encontrar:

```text
mi-imagen                    1.0
tu_usuario/mi-imagen         1.0
```

## Publicar la imagen

```bash
docker push tu_usuario/mi-imagen:1.0
```

La imagen estará disponible en Docker Hub bajo tu cuenta.

Otra persona podrá descargarla mediante:

```bash
docker pull tu_usuario/mi-imagen:1.0
```

Aquí completamos otro nivel de reproducibilidad:

```text
Código
  +
Git
  +
renv.lock
  +
Dockerfile
  ↓
Docker image
  ↓
Docker Hub
```

---

# 17. Comandos útiles

## Git

```bash
git status
git add .
git commit -m "Descripción del cambio"
git push
git pull
```

## rig

```bash
rig available
rig list
rig add 4.6.1
rig default 4.6.1
```

## renv

```r
renv::status()
renv::install("package-name")
renv::snapshot()
renv::restore()
```

## Docker

```bash
# Información
docker --version

# Autenticación
docker login

# Imágenes
docker images
docker pull <imagen>
docker rmi <imagen>

# Contenedores
docker ps
docker ps -a
docker run <imagen>
docker stop <contenedor>
docker rm <contenedor>

# Construir imágenes
docker build -t <nombre>:<tag> .

# Etiquetar
docker tag <imagen>:<tag> <usuario>/<imagen>:<tag>

# Publicar
docker push <usuario>/<imagen>:<tag>
```

---

# Limpieza de Docker

Durante los ejercicios puedes acumular imágenes, contenedores y caché de construcción.

Puedes comprobar el espacio utilizado con:

```bash
docker system df
```

Para eliminar objetos de Docker que no están siendo utilizados:

```bash
docker system prune
```

Docker solicitará confirmación antes de eliminar los recursos.

Existe también:

```bash
docker system prune -a
```

> **Cuidado:** la opción `-a` elimina todas las imágenes que no estén siendo utilizadas por contenedores, no solamente imágenes intermedias. No la utilices como comando habitual de limpieza sin comprobar primero qué recursos necesitas conservar.

---

# Opcional: VS Code

El curso utiliza **Positron** como entorno principal de desarrollo.

Si prefieres utilizar Visual Studio Code, puedes instalar la extensión de R:

```bash
code --install-extension REditorSupport.r --force
```

Este paso **no es necesario** si estás utilizando Positron.

---

# Flujo completo del curso

Al finalizar habremos recorrido el siguiente flujo:

```text
R
│
├── rig
│   └── versión de R
│
├── renv
│   └── dependencias
│
├── box
│   └── módulos
│
├── Git + GitHub
│   └── control de versiones
│
└── Docker
    ├── Dockerfile
    ├── imagen
    ├── contenedor
    └── Docker Hub
```

La idea principal es pasar progresivamente de:

```text
"Funciona en mi ordenador"
```

a:

```text
"El proyecto describe cómo reproducir
su código, dependencias y entorno"
```

---

# Recursos

## R

- [Advanced R](https://adv-r.hadley.nz/index.html)
- [`rig`](https://rig.r-lib.org/)
- [`renv`](https://rstudio.github.io/renv/articles/renv.html)
- [`box`](https://klmr.me/box/)

## Shiny

- [Mastering Shiny](https://mastering-shiny.org/basic-app.html)
- [Engineering Production-Grade Shiny Apps](https://engineering-shiny.org/index.html)

## Git

- [Git](https://git-scm.com/)
- [GitHub](https://github.com/)
- [Git Tutorial](https://evainformatica.es/biblioteca_virtual/manuales/Tutorial_de_Git_en_Espanol.pdf)

## Docker

- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Install Scripts](https://github.com/docker/docker-install)
- [`dockerfiler`](https://github.com/ThinkR-open/dockerfiler)