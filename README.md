# Requisitos: Viernes de Bioinformática - 13 de noviembre de 2026

## Bioinformatica reproducible con R: “Del codigo al contenedor”

## Requisitos antes del curso

Antes de comenzar, asegurate de contar con:
- Una terminal: Ya sea de Linux, con Windows usa WSL2 o Unix con macOSX.
- Una **cuenta de GitHub**, que usarás para GitHub y que también puedes usar para registrarte o iniciar sesión en Docker Hub.
- **Git** instalado.
- **Docker** instalado y con la sesión iniciada en Docker Hub.
- **Positron** instalado.

Crea una cuenta de GitHub en: https://github.com/

## Instalación en tu computadora

Instala Git, y Docker antes del curso. En Windows, usa WSL 2 y asegúrate de que las herramientas estén disponibles en el entorno donde ejecutarás los ejercicios:

- **Windows:** instala y usa **WSL 2**. Instala Docker Desktop y habilita la integración con tu distribución de WSL. 

  ```bash
  wsl -l --online
  wsl --install -d <distro-name>
  wsl --install --name ubuntu-bioinf
  wsl -d ubuntu-bioinf
  ```

- **Linux/Unix:** instala Git y Docker Engine siguiendo las instrucciones para tu distribución. En Ubuntu o Debian, instala Git con:

  ```bash
  sudo apt-get update && sudo apt-get upgrade -y
  sudo apt-get install -y git
  ```

  Para otras distribuciones y sistemas operativos, consulta las [instrucciones oficiales de instalación de Git](https://git-scm.com/downloads).

  En Linux puedes usar este instalador rápido de Docker:

  ```bash
  # Asegurate de estar en /home/usuario/
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm get-docker.sh

  sudo apt install util-linux-extra 
  sudo usermod -aG docker $USER && newgrp docker
  docker run hello-world
  
  # optional
  sudo apt update && sudo apt install -y locales
  sudo locale-gen en_US.UTF-8
  sudo update-locale LANG=en_US.UTF-8
  wsl --shutdown -d ubuntu-bioinf
  wsl -d ubuntu-bioinf
  ```

  Consulta el proyecto oficial: https://github.com/docker/docker-install
- **macOS:** instala Docker Desktop, Git y GitHub CLI.

Descarga e instala [Positron](https://positron.posit.co/download.html).

Instrucciones oficiales:

- Git: https://git-scm.com/downloads
- Docker Desktop para Windows con WSL 2: https://docs.docker.com/desktop/setup/install/windows-install/
- Docker Engine para Linux: https://docs.docker.com/engine/install/
- Docker Desktop para Mac: https://docs.docker.com/desktop/setup/install/mac-install/

### Inicia sesion tanto en GitHub como en Docker Hub antes de continuar. 

Comprueba que las herramientas estén instaladas e inicia sesión en tu entorno local:

```bash
git config --global user.name "Nombre";
git config --global user.email "correo@gmail.com";

git --version
docker --version
docker login
```
Verifica que el login haya sido exitoso haciendo de nuevo `docker login`.
Sino tambien puede iniciar sesion creando un PAT
```bash
docker login -u usuario
```
> **Importante:** Trata tu PAT como una contraseña. No lo incluyas directamente en scripts, archivos Dockerfile ni repositorios de Git, y nunca lo subas a GitHub.

Durante el curso usarás Docker Hub para:

- Autenticarte en Docker.
- Crear y administrar imágenes de Docker.
- Subir imágenes a Docker Hub.
- Descargar imágenes desde Docker Hub.

## Lista de verificación

Antes de comenzar, asegúrate de cumplir todos estos requisitos:
- [ ] Accesso a una terminal de GNU/Linux, en Windows utiliza WSL2 o una terminal de macOSX.
- [ ] Una cuenta de GitHub para GitHub y para registrarte o iniciar sesión en Docker Hub.
- [ ] Git instalado; `git --version` confirma que está disponible.
- [ ] Docker instalado y con la sesión iniciada en Docker Hub mediante `docker login`.
- [ ] Positron instalado: [descarga Positron](https://positron.posit.co/download.html).
- [ ] Tu nombre de usuario de Docker Hub y tu token de acceso personal (PAT).
