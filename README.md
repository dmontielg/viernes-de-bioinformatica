# R Shiny Development Environment Setup

This guide describes how to configure an R development environment using R, `rig`, `renv`, and VS Code.

## 1. Install `rig`

Install the R Installation Manager:

```bash
curl -LsSf https://r-lib.github.io/rig/install.sh | sh
```

Install R 4.6.1:

```bash
rig add 4.6.1
```

Check the installed R versions:

```bash
rig list
```

---

## 2. Install VS Code R Dependencies

Start R and install the packages required for the VS Code R development environment:

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
  libgit2-dev
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