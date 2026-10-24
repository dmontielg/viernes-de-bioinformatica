# Viernes de Bioinformática - 13 de noviembre de 2026

## Bioinformatica reproducible con R: “Del codigo al contenedor”

Este repositorio ofrece una introducción práctica al desarrollo y despliegue de aplicaciones con R.

A partir de la configuración del entorno de R, el curso cubrirá progresivamente:

1. Instalar y administrar versiones de R con **rig**.
2. Crear entornos reproducibles para proyectos con **renv**.
3. Aprender los fundamentos de **box**.
5. Introduccion a **Docker**.
4. Contenerizar la aplicación con **Docker**.
6. Preparar la aplicación para su despliegue en Docker hub.

El objetivo es ofrecer una ruta práctica desde los conceptos básicos de hasta una aplicación reproducible y contenerizada usando R como lenguaje. También se presentan el uso de librerias como `renv` para entornos reproducibles, módulos con `box` y finalmente crear una imagen `docker` para su reproducibilidad.

## 1. Instalar `rig`

Instala el administrador de instalaciones de R:

```bash
curl -LsSf https://r-lib.github.io/rig/install.sh | sh
```

Instala R 4.6.1:

```bash
rig available
rig add 4.6.1
rig list
```

---

## 2. Instalar las dependencias de R para VS Code

Inicia R e instala los paquetes necesarios para el entorno de desarrollo de R en VS Code:

```bash
code --install-extension REditorSupport.r --force
```

```r
install.packages(c(
  "languageserver",
  "httpgd",
  "ps",
  "jsonlite",
  "processx"
))
```


---

## 3. Inicializar `renv`

Instala `renv`:

```r
install.packages("renv")
```

Inicializa el entorno del proyecto:

```r
# Cran packages
renv::init()

# Si quieres incluir packages en Bioconductor
renv::init(bioconductor = TRUE)
# Puedes tambien especificar que version usar
renv::init(bioconductor = "3.14")

```

Instala un paquete usando renv

```r
# Cran-packages
renv::install("<package-name>")
```

Guarda las versiones de los paquetes en `renv.lock`:

```r
renv::snapshot()
```

---

## 4. Instalar paquetes del curso

Con el proyecto activado con `renv`, instala `box` para organizar el código en módulos, `dplyr` para transformar datos y `ggplot2` para crear visualizaciones:

```r
renv::install(c("box", "dplyr", "ggplot2"))
```

Registra las versiones instaladas para que otras personas puedan reproducir el entorno:

```r
renv::snapshot()
```

## 5. Organizar el código en módulos con `box`

`box` permite separar el código en archivos reutilizables llamados módulos. Cada módulo puede contener funciones relacionadas; después, otro archivo lo importa y utiliza sus funciones. Esta organización ayuda a mantener más legibles los proyectos del curso a medida que crecen.

Por ejemplo, crea el archivo `modules/expression_summary.R` con una función para calcular la expresión media por gen:

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

Desde otro archivo R, importa el módulo y llama a la función:

```r
box::use(./modules/expression_summary)

expression_data <- data.frame(
  gene = c("BRCA1", "BRCA1", "TP53", "TP53"),
  expression = c(8.2, 9.1, 5.4, 6.0)
)

expression_summary$summarize_expression(expression_data)
```

La ruta `./modules/expression_summary` corresponde al archivo `modules/expression_summary.R`, sin escribir la extensión `.R`. En este ejemplo, el módulo usa `dplyr` con su espacio de nombres explícito (`dplyr::`), así que no es necesario cargarlo con `library()` dentro del módulo.

## 6. Ejemplos con `dplyr` y `ggplot2`

Los siguientes ejemplos usan datos pequeños creados en el propio código para que puedan ejecutarse sin descargar archivos adicionales.

### Ejemplo 1: expresión media por gen

Agrupa las mediciones por gen, calcula la expresión media y representa los resultados en un gráfico de barras:

```r
library(dplyr)
library(ggplot2)

expression_data <- data.frame(
  gene = c("BRCA1", "BRCA1", "TP53", "TP53", "EGFR", "EGFR"),
  expression = c(8.2, 9.1, 5.4, 6.0, 7.3, 8.1)
)

mean_expression <- expression_data |>
  group_by(gene) |>
  summarise(mean_expression = mean(expression), .groups = "drop")

ggplot(mean_expression, aes(x = gene, y = mean_expression, fill = gene)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Expresión media por gen",
    x = "Gen",
    y = "Expresión media"
  ) +
  theme_minimal()
```

### Ejemplo 2: número de lecturas por muestra

Suma los conteos de lecturas de los genes por muestra y compara los totales en un gráfico:

```r
library(dplyr)
library(ggplot2)

read_counts <- data.frame(
  sample = c("Muestra 1", "Muestra 1", "Muestra 1",
             "Muestra 2", "Muestra 2", "Muestra 2"),
  gene = c("BRCA1", "TP53", "EGFR", "BRCA1", "TP53", "EGFR"),
  reads = c(120, 85, 64, 98, 110, 72)
)

counts_by_sample <- read_counts |>
  group_by(sample) |>
  summarise(total_reads = sum(reads), .groups = "drop")

ggplot(counts_by_sample, aes(x = sample, y = total_reads, fill = sample)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Lecturas totales por muestra",
    x = "Muestra",
    y = "Número de lecturas"
  ) +
  theme_minimal()
```

### Ejemplo 3: control de calidad de mediciones

Clasifica las mediciones según un umbral, calcula la proporción que lo supera en cada muestra y compara los resultados:

```r
library(dplyr)
library(ggplot2)

quality_data <- data.frame(
  sample = c("Muestra 1", "Muestra 1", "Muestra 1",
             "Muestra 2", "Muestra 2", "Muestra 2"),
  measurement = c(12.4, 9.8, 11.1, 8.5, 10.6, 12.0)
)

quality_summary <- quality_data |>
  mutate(passes_threshold = measurement >= 10) |>
  group_by(sample) |>
  summarise(
    passing_fraction = mean(passes_threshold),
    .groups = "drop"
  )

ggplot(quality_summary, aes(x = sample, y = passing_fraction, fill = sample)) +
  geom_col(show.legend = FALSE) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Proporción de mediciones que superan el umbral",
    x = "Muestra",
    y = "Proporción"
  ) +
  theme_minimal()
```

## 7. Introducción a Docker

Docker permite empaquetar una aplicación y sus dependencias en una **imagen**. Al ejecutar esa imagen se crea un **contenedor**. La imagen sirve como plantilla; el contenedor es una instancia en ejecución (o ya finalizada) de esa plantilla.

### Instalar y comprobar Docker

Instala Docker Desktop o Docker Engine siguiendo las instrucciones oficiales para tu sistema operativo: [Instalar Docker](https://docs.docker.com/engine/install/). Después, comprueba que Docker está disponible y que el motor se está ejecutando:

```bash
docker --version
docker run --rm hello-world
```

`hello-world` es una imagen de prueba. La opción `--rm` elimina automáticamente el contenedor al terminar.

### Crear una imagen de ejemplo con `cowsay`

En la raíz del proyecto, crea un archivo llamado `Dockerfile` con este contenido. El archivo describe cómo construir una imagen Debian que incluye `cowsay`:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends cowsay \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/games/cowsay"]
CMD ["¡Hola desde Docker!"]
```

Construye la imagen y asígnale el nombre `curso-cowsay` y la etiqueta `1.0`:

```bash
docker build -t curso-cowsay:1.0 .
```

El punto final indica que Docker debe usar el directorio actual como contexto de construcción. Ejecuta la imagen; el texto opcional reemplaza el mensaje predeterminado:

```bash
docker run --rm curso-cowsay:1.0 "¡Hola, curso de bioinformática!"
```

### Descargar y listar imágenes

`docker pull` descarga una imagen del registro de Docker Hub. `docker images` muestra las imágenes disponibles localmente:

```bash
docker pull debian:bookworm-slim
docker images
```

### Ejecutar y listar contenedores

`docker run` crea y ejecuta un contenedor a partir de una imagen. En el ejemplo anterior, `cowsay` termina inmediatamente después de mostrar el mensaje; por eso, no aparecerá en la lista de contenedores activos. Para ver los contenedores finalizados, usa `docker ps -a`.

```bash
docker run -d --name cowsay-demo curso-cowsay:1.0

# Desde Docker hub
docker run rancher/cowsay:latest
docker run rancher/cowsay:latest "hola docker"
docker run rancher/cowsay:latest -l
docker run rancher/cowsay:latest -f "dragon-and-cow" "hola mundo"
docker ps
```

En este comando se reemplaza temporalmente el punto de entrada `cowsay` por una shell que imprime un mensaje y espera 300 segundos. La opción `-d` ejecuta el contenedor en segundo plano y `--name` le asigna un nombre fácil de recordar. Algunos comandos útiles para consultar y administrar contenedores son:

```bash
docker ps -a
docker logs cowsay-demo
docker stop cowsay-demo
docker rm cowsay-demo
```

`docker logs` muestra la salida del contenedor; `docker stop` lo detiene y `docker rm` elimina el contenedor detenido. Para borrar la imagen de ejemplo cuando ya no la necesites, primero asegúrate de que no haya contenedores que la estén usando:

```bash
docker rmi curso-cowsay:1.0
```

Ahora usemos una imagen de `Rstudio` sin instalarlo.

```bash
docker run --rm -p 8787:8787 -e PASSWORD=test rocker/rstudio:4
docker run --rm -p 8787:8787 -e PASSWORD=test -v $PWD:/home/rstudio/ rocker/rstudio:4
```

## Recursos

* Advanced R https://adv-r.hadley.nz/index.html
* Mastering Shiny https://mastering-shiny.org/basic-app.html
* Engineering Production-Grade Shiny Apps https://engineering-shiny.org/index.html
