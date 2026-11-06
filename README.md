# Requisitos: Viernes de Bioinformática

**Fecha:** 13 de noviembre de 2026  
**Curso:** Bioinformática reproducible con R: *Del código al contenedor*

## Requisitos previos

Antes del curso, asegúrate de contar con las siguientes herramientas:

- **Acceso a una terminal**
  - **Windows:** utilizaremos WSL 2 con Ubuntu.
  - **Linux:** utiliza la terminal de tu distribución.
  - **macOS:** utiliza la terminal de macOS.
- **Una cuenta de GitHub:** https://github.com/
- **Git instalado:** https://git-scm.com/install/
- **Docker instalado:** https://docs.docker.com/get-started/get-docker/
- **Una cuenta de Docker Hub** y acceso mediante `docker login`.
- **Positron instalado:** https://positron.posit.co/

> **Usuarios de Windows:** durante el curso utilizaremos WSL 2 como entorno GNU/Linux.
>
> Si nunca has utilizado WSL, puedes consultar este tutorial:
> https://www.youtube.com/watch?v=Qy44XLpiChc

---

# Instalación

## Windows

En Windows utilizaremos **WSL 2 con Ubuntu** para disponer de un entorno GNU/Linux.

### 1. Instalar WSL 2 y Ubuntu

Abre **PowerShell como administrador**.

Puedes consultar las distribuciones disponibles con:

```powershell
wsl --list --online
```

Instala Ubuntu:

```powershell
wsl --install -d Ubuntu
```

Si WSL todavía no está instalado en tu sistema, también puedes utilizar simplemente:

```powershell
wsl --install
```

Este comando instala WSL y Ubuntu como distribución predeterminada.

> Es posible que Windows solicite reiniciar el equipo después de instalar WSL.

Después de la instalación, comprueba las distribuciones instaladas:

```powershell
wsl --list --verbose
```

Deberías observar algo similar a:

```text
NAME      STATE     VERSION
Ubuntu    Stopped   2
```

Asegúrate de que Ubuntu utiliza **WSL 2**.

Para iniciar Ubuntu:

```powershell
wsl -d Ubuntu
```

La primera vez que abras Ubuntu se te pedirá crear un usuario y una contraseña para tu entorno Linux.

### 2. Instalar Docker Desktop

Instala **Docker Desktop para Windows**:

https://docs.docker.com/desktop/setup/install/windows-install/

Asegúrate de que Docker Desktop utiliza **WSL 2** y de que la integración con Ubuntu está habilitada.

En Docker Desktop puedes revisar:

```text
Settings
└── Resources
    └── WSL Integration
```

Habilita la integración para la distribución de Ubuntu que utilizarás durante el curso.

> **Importante:** si utilizas Docker Desktop con integración WSL 2, no necesitas instalar Docker Engine dentro de Ubuntu mediante `get.docker.com`.

### 3. Comprobar Docker desde WSL

Abre Ubuntu:

```powershell
wsl -d Ubuntu
```

Desde la terminal de Ubuntu, ejecuta:

```bash
docker --version
```

Después comprueba que puedes ejecutar contenedores:

```bash
docker run hello-world
```

Si ambos comandos funcionan correctamente, Docker está disponible desde WSL.

---

## Linux

En Linux utilizaremos **Docker Engine** directamente.

### 1. Instalar Git

En Ubuntu o Debian:

```bash
sudo apt-get update
sudo apt-get install -y git
```

Comprueba la instalación:

```bash
git --version
```

Para otras distribuciones, consulta:

https://git-scm.com/downloads

### 2. Instalar Docker

Consulta las instrucciones oficiales para tu distribución:

https://docs.docker.com/engine/install/

Para un entorno de desarrollo también puedes utilizar el script oficial de instalación de Docker:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
```

El proyecto oficial del instalador se encuentra en:

https://github.com/docker/docker-install

### 3. Ejecutar Docker sin `sudo`

Añade tu usuario al grupo `docker`:

```bash
sudo usermod -aG docker $USER
```

Aplica el cambio de grupo:

```bash
newgrp docker
```

Comprueba que puedes ejecutar Docker sin `sudo`:

```bash
docker run hello-world
```

> **Importante:** pertenecer al grupo `docker` otorga privilegios elevados sobre el sistema. Utiliza esta configuración únicamente en un equipo o entorno donde tengas autorización para hacerlo.

---

## macOS

En macOS instala las siguientes herramientas:

1. Git
2. Docker Desktop
3. Positron

Consulta las instrucciones oficiales:

- Git: https://git-scm.com/downloads
- Docker Desktop: https://docs.docker.com/desktop/setup/install/mac-install/
- Positron: https://positron.posit.co/download.html

Después de instalar Docker Desktop, comprueba desde la terminal:

```bash
docker --version
docker run hello-world
```

---

# Positron

Durante el curso utilizaremos **Positron** como entorno de desarrollo.

Descarga e instala Positron antes del curso:

https://positron.posit.co/download.html

Después de la instalación, abre Positron y comprueba que puedes acceder a una terminal.

---

# Configuración de Git

Después de instalar Git, configura tu nombre y correo electrónico.

Reemplaza los siguientes valores por los correspondientes a tu cuenta:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@ejemplo.com"
```

Comprueba que Git está disponible:

```bash
git --version
```

Puedes revisar la configuración con:

```bash
git config --global --list
```

---

# GitHub

Durante el curso utilizaremos Git y GitHub para trabajar con control de versiones y repositorios remotos.

Si todavía no tienes una cuenta, crea una en:

https://github.com/

Asegúrate de poder iniciar sesión en GitHub antes del curso.

---

# Docker Hub

Durante el curso utilizaremos Docker Hub para:

- Autenticarnos desde Docker.
- Descargar imágenes de Docker.
- Crear imágenes de Docker.
- Etiquetar nuestras imágenes.
- Subir imágenes a Docker Hub.

Crea una cuenta en Docker Hub antes del curso si todavía no dispones de una.

Comprueba primero que Docker está instalado:

```bash
docker --version
```

Después inicia sesión:

```bash
docker login
```

Docker te solicitará tus credenciales de forma interactiva.

También puedes especificar directamente tu usuario:

```bash
docker login -u TU_USUARIO
```

En ese caso, Docker solicitará la contraseña o token de acceso de forma interactiva.

> **Importante:** trata cualquier Personal Access Token (PAT) como una contraseña.
>
> No incluyas tokens directamente en:
>
> - scripts
> - Dockerfiles
> - archivos de configuración versionados
> - repositorios Git
>
> Nunca subas un PAT a GitHub.

---

# Opcional: configurar el locale en Ubuntu/WSL

En algunos entornos Ubuntu o WSL puedes encontrar avisos similares a:

```text
bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8)
```

Este problema **no debería impedirte realizar el curso**, pero puedes solucionarlo instalando los locales:

```bash
sudo apt-get update
sudo apt-get install -y locales
```

Genera el locale:

```bash
sudo locale-gen en_US.UTF-8
```

Configúralo como predeterminado:

```bash
sudo update-locale LANG=en_US.UTF-8
```

Si estás utilizando WSL, sal de Ubuntu:

```bash
exit
```

Después, desde **PowerShell**, reinicia WSL:

```powershell
wsl --shutdown
```

Abre nuevamente Ubuntu:

```powershell
wsl -d Ubuntu
```

> Este paso es opcional. Realízalo únicamente si encuentras problemas relacionados con el locale.

---

# Comprobación final

Antes del curso, abre la terminal que utilizarás durante los ejercicios y ejecuta:

```bash
git --version
docker --version
```

Comprueba también que Docker puede ejecutar un contenedor:

```bash
docker run hello-world
```

Finalmente, inicia sesión en Docker Hub:

```bash
docker login
```

Si estos comandos funcionan correctamente, tendrás preparado el entorno básico para el curso.

---

# Lista de verificación

Antes del **13 de noviembre de 2026**, asegúrate de poder marcar todas las siguientes casillas:

- [ ] Tengo acceso a una terminal GNU/Linux, WSL 2 en Windows o una terminal de macOS.
- [ ] Si utilizo Windows, tengo WSL 2 con Ubuntu funcionando.
- [ ] Tengo una cuenta de GitHub.
- [ ] Git está instalado.
- [ ] `git --version` funciona correctamente.
- [ ] He configurado mi nombre y correo electrónico en Git.
- [ ] Docker está instalado.
- [ ] `docker --version` funciona correctamente.
- [ ] `docker run hello-world` funciona correctamente.
- [ ] Tengo una cuenta de Docker Hub.
- [ ] Puedo iniciar sesión mediante `docker login`.
- [ ] Tengo Positron instalado.
- [ ] Puedo abrir Positron y acceder a una terminal.

---

# Enlaces de referencia

## Git y GitHub

- Git: https://git-scm.com/downloads
- GitHub: https://github.com/

## Docker

- Docker: https://docs.docker.com/get-started/get-docker/
- Docker Desktop para Windows: https://docs.docker.com/desktop/setup/install/windows-install/
- Docker Engine para Linux: https://docs.docker.com/engine/install/
- Docker Desktop para macOS: https://docs.docker.com/desktop/setup/install/mac-install/
- Script oficial de instalación: https://github.com/docker/docker-install

## WSL

- Documentación de WSL: https://learn.microsoft.com/windows/wsl/
- Instalación de WSL: https://learn.microsoft.com/windows/wsl/install

## Positron

- Positron: https://positron.posit.co/
- Descargar Positron: https://positron.posit.co/download.html