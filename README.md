# Viernes de Bioinformatica - 13 de Noviembre 2026 

## R Shiny Development to Production

This repository is a hands-on introduction to the R Shiny development and deployment workflow.

Starting from R environment setup, we will progressively cover:

1. Installing and managing R versions with **rig**
2. Creating reproducible project environments with **renv**
3. Learning the fundamentals of **R Shiny**
4. Building and running a Shiny application
5. Containerizing the application with **Docker**
6. Preparing the application for production deployment

The repository is designed to provide a practical path from basic Shiny development to a reproducible, containerized application.

## 1. Install `rig`

Install the R Installation Manager:

```bash
curl -LsSf https://r-lib.github.io/rig/install.sh | sh
```

Install R 4.6.1:

```bash
rig available
rig add 4.6.1
rig list
```

---

## 2. Install VS Code R Dependencies

Start R and install the packages required for the VS Code R development environment:

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

Install `renv`:

```r
install.packages("renv")
```

---

## 3. Initialize `renv`

Initialize the project environment:

```r
renv::init()
```

Install Shiny inside the project environment:

```r
renv::install("shiny")
```

Save the package versions to `renv.lock`:

```r
renv::snapshot()
```

---

## 4. Configure VS Code Session Watcher

Add the following code to the project's `.Rprofile` file.

This allows the VS Code R Session Watcher to initialize alongside `renv`:

```r
# Allow VS Code Session Watcher to initialize alongside renv
if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
  if (file.exists(file.path(Sys.getenv("HOME"), ".vscode-R", "init.R"))) {
    source(file.path(Sys.getenv("HOME"), ".vscode-R", "init.R"))
  }
}
```

> **Note:** If your `.Rprofile` already contains the `renv` activation code, keep it. Add the VS Code configuration without removing the existing `renv` configuration.

---

## 5. Shiny2Docker Setup

Install the required Linux system dependencies:

```bash
sudo apt-get update

sudo apt-get install -y \
  libtiff-dev \
  libgit2-dev \
  libuv1-dev \
  pandoc
```

Then install `shiny2docker` inside the project environment:

```r
renv::install("shiny2docker")
```

Update the `renv.lock` file:

```r
renv::snapshot()
```

---

## Useful `renv` Commands

### Install a package

```r
renv::install("package-name")
```

### Save the current environment

```r
renv::snapshot()
```

### Restore packages from `renv.lock`

```r
renv::restore()
```

### Check the project environment

```r
renv::status()
```

## Resources
* https://mastering-shiny.org/basic-app.html
* https://adv-r.hadley.nz/index.html
* https://engineering-shiny.org/index.html
