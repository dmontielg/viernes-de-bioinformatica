FROM rocker/rstudio:4.6.1

USER root

# Can be overridden at build time:
# docker build --build-arg PROJECT_DIR=/workspace ...
ARG PROJECT_DIR=/home/rstudio

# Persist the path for build-time commands and runtime renv activation
ENV PROJECT_DIR=${PROJECT_DIR}

# ------------------------------------------------------------
# Linux system dependencies
# ------------------------------------------------------------
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  curl \
  git \
  pandoc \
  zlib1g-dev \
  libbz2-dev \
  liblzma-dev \
  libdeflate-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libgit2-dev \
  libicu-dev \
  libuv1-dev \
  libxml2-dev \
  libx11-dev \
  libtiff-dev && \
  rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# Global R configuration
# ------------------------------------------------------------
RUN echo "options(renv.config.pak.enabled = FALSE, repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" \
  > /usr/local/lib/R/etc/Rprofile.site

# ------------------------------------------------------------
# Install renv
# ------------------------------------------------------------
RUN R -e 'install.packages(c("remotes", "BiocManager"))' && \
  R -e 'remotes::install_version("renv", version = "1.3.1")'

# ------------------------------------------------------------
# renv configuration
# ------------------------------------------------------------
ENV RENV_PATHS_LIBRARY=/opt/renv/library
ENV RENV_PATHS_CACHE=/opt/renv/cache

RUN mkdir -p \
  "${PROJECT_DIR}" \
  "${RENV_PATHS_LIBRARY}" \
  "${RENV_PATHS_CACHE}" && \
  chown -R rstudio:rstudio \
  "${PROJECT_DIR}" \
  /opt/renv

WORKDIR ${PROJECT_DIR}

# ------------------------------------------------------------
# Copy renv metadata first for Docker layer caching
# ------------------------------------------------------------
COPY --chown=rstudio:rstudio renv.lock .Rprofile ./
COPY --chown=rstudio:rstudio \
  renv/activate.R \
  renv/settings.json \
  ./renv/

# ------------------------------------------------------------
# Restore dependencies
# ------------------------------------------------------------
USER rstudio

RUN RENV_CONFIG_CACHE_ENABLED=FALSE \
  R --vanilla -e "renv::restore( \
  project = Sys.getenv('PROJECT_DIR'), \
  lockfile = file.path(Sys.getenv('PROJECT_DIR'), 'renv.lock'), \
  library = renv::paths\$library(project = Sys.getenv('PROJECT_DIR')), \
  prompt = TRUE \
  )"

# ------------------------------------------------------------
# Copy application code
# ------------------------------------------------------------
USER root

COPY --chown=rstudio:rstudio . .