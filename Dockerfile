FROM rocker/r-ver:3.6.1

ARG RSTUDIO_VERSION
#ENV RSTUDIO_VERSION=${RSTUDIO_VERSION:-1.2.1335}
ARG S6_VERSION
ARG PANDOC_TEMPLATES_VERSION
ENV S6_VERSION=${S6_VERSION:-v1.21.7.0}
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
ENV PANDOC_TEMPLATES_VERSION=${PANDOC_TEMPLATES_VERSION:-2.6}

## Download and install RStudio server & dependencies
## Attempts to get detect latest version, otherwise falls back to version given in $VER
## Symlink pandoc, pandoc-citeproc so they are available system-wide
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    file \
    git \
    libapparmor1 \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    procps \
    python-setuptools \
    python \
    sudo \
    wget \
    libclang-dev \
    libclang-3.8-dev \
    libobjc-6-dev \
    libclang1-3.8 \
    libclang-common-3.8-dev \
    libllvm3.8 \
    libobjc4 \
    libgc1c2 \
    libz-dev \
    curl \
    gnupg \
    unixodbc-dev \
    unixodbc \
    odbc-postgresql \
    libsqliteodbc \
    tdsodbc \
    openjdk-8-jdk \
  && if [ -z "$RSTUDIO_VERSION" ]; then RSTUDIO_URL="https://www.rstudio.org/download/latest/stable/server/debian9_64/rstudio-server-latest-amd64.deb"; else RSTUDIO_URL="http://download2.rstudio.org/server/debian9/x86_64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb"; fi \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Need to configure non-root user for RStudio
  && useradd rstudio \
  && echo "rstudio:rstudio" | chpasswd \
	&& mkdir /home/rstudio \
	&& chown rstudio:rstudio /home/rstudio \
	&& addgroup rstudio staff \
  ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
  &&  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  ## configure git not to request password each time
  && git config --system credential.helper 'cache --timeout=3600' \
  && git config --system push.default simple \
  ## Set up S6 init system
  && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
          \n## load /etc/environment vars first: \
  		  \n for line in $( cat /etc/environment ) ; do export $line ; done \
          \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/services.d/rstudio/run \
  && echo '#!/bin/bash \
          \n rstudio-server stop' \
          > /etc/services.d/rstudio/finish \
  && mkdir -p /home/rstudio/.rstudio/monitored/user-settings \
  && echo 'alwaysSaveHistory="0" \
          \nloadRData="0" \
          \nsaveAction="0"' \
          > /home/rstudio/.rstudio/monitored/user-settings/user-settings \
  && chown -R rstudio:rstudio /home/rstudio/.rstudio

## Install R packages
RUN R -e 'install.packages(c("plumber", "jsonlite","here", "dplyr", "stringr","readr","sqldf","tseries","forecast","randomForest","tree","plotly", "fortunes", "sp", "gstat", "knitr", "Rcpp", "magrittr", "units", "lattice", "rjson", "FNN", "udunits2", "stringr", "xts", "DBI", "lambda.r", "futile.logger", "htmltools", "intervals", "yaml", "rprojroot", "digest", "sf", "futile.options", "evaluate", "rmarkdown", "stringi", "backports", "spacetime", "zoo", "bookdown", "blogdown","DBI", "odbc","RMySQL", "RPostgresSQL", "RSQLite","RSQLServer","xlsx","ggvis","htmlwidgets","ggmap","quantmod","parallel","reticulate","devtools","packrat","rstudioapi","miniUI","flexdashboard","rsconnect","png"))'

COPY userconf.sh /etc/cont-init.d/userconf

## running with "-e ADD=shiny" adds shiny server
COPY add_shiny.sh /etc/cont-init.d/add
COPY disable_auth_rserver.conf /etc/rstudio/disable_auth_rserver.conf
COPY pam-helper.sh /usr/lib/rstudio-server/bin/pam-helper
EXPOSE 8787
## automatically link a shared volume for kitematic users
VOLUME /home/rstudio/kitematic

RUN mkdir /home/rstudio/.conda

# Install util tools.
# Install conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN chown -R rstudio:rstudio /opt/conda \
    && chmod -R 777 /opt/conda \
    && chown -R rstudio:rstudio /home/rstudio/.conda \
    && chmod -R 777 /home/rstudio/.conda

RUN chown -R rstudio:rstudio /usr/local/lib/R/site-library \
    && chmod -R 777 /usr/local/lib/R/site-library \
    && chown -R rstudio:rstudio /usr/local/lib/R/site-library \
    && chmod -R 777 /usr/local/lib/R/site-library
    
# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev

# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc

# install SQL Server tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

CMD ["/init"]
