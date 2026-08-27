# MNet: integrative analysis of metabolomic and transcriptomic data
# Shiny app Docker image based on rocker/r2u (binary R packages via apt)
FROM rocker/r2u:24.04

LABEL maintainer="Tuantuan Gui <guituant2009@163.com>"
LABEL description="MNet Shiny app"

# Install CRAN and Bioconductor dependencies as binary packages via r2u.
# This covers DESCRIPTION Imports plus the extra packages loaded in app.R.
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        r-cran-ggplot2 \
        r-cran-dplyr \
        r-cran-survival \
        r-cran-igraph \
        r-cran-caret \
        r-cran-xgboost \
        r-cran-magrittr \
        r-cran-rcolorbrewer \
        r-cran-tibble \
        r-cran-dmwr2 \
        r-cran-hmisc \
        r-cran-stringr \
        r-cran-survminer \
        r-cran-pheatmap \
        r-cran-proc \
        r-cran-randomforest \
        r-cran-jsonlite \
        r-cran-tidyr \
        r-cran-ggrepel \
        r-cran-boruta \
        r-cran-filesstrings \
        r-cran-reshape2 \
        r-cran-tidyselect \
        r-cran-cowplot \
        r-cran-data.table \
        r-cran-shiny \
        r-cran-bs4dash \
        r-cran-dt \
        r-cran-colourpicker \
        r-cran-shinywidgets \
        r-cran-cairo \
        r-cran-ggsci \
        r-cran-markdown \
        r-cran-callr \
        r-cran-shinyjs \
        r-cran-remotes \
        r-bioc-limma \
        r-bioc-pathview \
        r-bioc-ropls \
        r-bioc-fgsea \
        r-bioc-suprahex \
    && rm -rf /var/lib/apt/lists/*

# dnet is not available on r2u; install it from GitHub (supraHex/igraph already installed above)
RUN Rscript -e 'remotes::install_github("hfang-bristol/dnet", upgrade = "never")'

# Install MNet from the local source tree (dependencies already satisfied above)
COPY . /opt/MNet
RUN R CMD INSTALL --no-build-vignettes /opt/MNet

EXPOSE 3838

CMD ["Rscript", "-e", "shiny::runApp(system.file('shinyapp', package = 'MNet'), host = '0.0.0.0', port = 3838, launch.browser = FALSE)"]
