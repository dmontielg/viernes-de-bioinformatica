# Requisitos

## Requisitos antes del curso

Antes de comenzar, asegurate de contar con:

- Una **cuenta de GitHub**.
- **GitHub CLI (`gh`)** instalado y con la sesión iniciada.
- **Docker** instalado y con la sesión iniciada en Docker Hub.

Crea una cuenta de GitHub en: https://github.com/

## Instalación en tu computadora

Instala GitHub CLI y Docker antes del curso. En Windows, usa WSL 2 y asegúrate de que ambas herramientas estén disponibles en el entorno donde ejecutarás los ejercicios:

- **Windows:** instala y usa **WSL 2**. Instala Docker Desktop y habilita la integración con tu distribución de WSL. Instala GitHub CLI en el entorno que usarás para trabajar.
- **Linux/Unix:** instala Docker Engine y GitHub CLI siguiendo las instrucciones para tu distribución. En Linux puedes usar este instalador rápido de Docker:

  ```bash
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm get-docker.sh
  ```

  Consulta el proyecto oficial: https://github.com/docker/docker-install
- **macOS:** instala Docker Desktop y GitHub CLI.

Instrucciones oficiales:

- GitHub CLI: https://github.com/cli/cli#installation
- Docker Desktop para Windows con WSL 2: https://docs.docker.com/desktop/setup/install/windows-install/
- Docker Engine para Linux: https://docs.docker.com/engine/install/
- Docker Desktop para Mac: https://docs.docker.com/desktop/setup/install/mac-install/

Durante el curso usaremos GitHub Codespaces y también clonaremos el proyecto en tu computadora para ejecutar allí los mismos pasos y comprobar su reproducibilidad. Por eso, debes instalar GitHub CLI y Docker localmente, además de tenerlos disponibles en el entorno que uses.

Comprueba que las herramientas estén instaladas e inicia sesión en tu entorno local:

```bash
gh --version
gh auth login
gh auth status
docker --version
docker login
```

`gh auth status` debe confirmar que la sesión de GitHub está activa. `docker login` debe completarse correctamente para autenticarte en Docker Hub.

## Preparativos que puedes hacer antes o durante el curso

Podrás configurar durante el curso los servicios y accesos adicionales que necesitemos.

## GitHub Codespaces

En el curso usaremos **GitHub Codespaces** para proporcionar un entorno de desarrollo listo para usar directamente desde tu repositorio de GitHub.

Durante el curso comprobaremos cómo:

- Iniciar sesión en GitHub.
- Acceder a GitHub Codespaces.
- Crear un Codespace desde un repositorio.

Si usas Codespaces, no necesitas instalar R ni VS Code en tu computadora.

## Cuenta de Docker Hub

Para iniciar sesión en Docker y realizar los ejercicios de contenerización necesitas una **cuenta de Docker Hub**. Esta cuenta es obligatoria antes de comenzar.

Puedes usar tu **cuenta de GitHub para registrarte o iniciar sesión en Docker Hub**.

Crea una cuenta o accede a la tuya en: https://hub.docker.com/

Durante el curso usarás Docker Hub para:

- Autenticarte en Docker.
- Crear y administrar imágenes de Docker.
- Subir imágenes a Docker Hub.
- Descargar imágenes desde Docker Hub.

## Token de acceso personal (PAT) de Docker Hub

Se recomienda crear un **token de acceso personal (PAT, por sus siglas en inglés)** en Docker Hub.

Puedes usar este token en lugar de tu contraseña de Docker Hub para autenticarte, especialmente desde entornos de desarrollo como GitHub Codespaces.

Ten a mano la siguiente información:

- Tu nombre de usuario de Docker Hub.
- Tu token de acceso personal (PAT) de Docker Hub, si lo usarás para iniciar sesión.

> **Importante:** Trata tu PAT como una contraseña. No lo incluyas directamente en scripts, archivos Dockerfile ni repositorios de Git, y nunca lo subas a GitHub.

## Lista de verificación

Antes de comenzar, asegúrate de cumplir todos estos requisitos:

- [ ] Una cuenta de GitHub.
- [ ] GitHub CLI (`gh`) instalado y con la sesión iniciada; `gh auth status` confirma que está autenticado.
- [ ] Docker instalado y con la sesión iniciada en Docker Hub mediante `docker login`.
- [ ] Una cuenta de Docker Hub.
- [ ] Tu nombre de usuario de Docker Hub y tu token de acceso personal (PAT).
