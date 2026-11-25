# MNet <img src="logo.png" align="right" alt="" width="120" />

## 1. Overview

**MNet: a metabolic network-centered tool for interpreting metabolomic and transcriptomic data**

- **Knowledgebase - dbMNet:** <font color="CadetBlue">**dbKEGG**</font> for extended pathway analysis and <font color="CadetBlue">**dbNet**</font> for metabolism-related subnetwork analysis  

- **Algorithm for extended pathway analysis:** Extended pathway enrichment analysis (<font color="CadetBlue">**ePEA**</font>), extended pathway differential abundance analysis (<font color="CadetBlue">**ePDA**</font>), and extended pathway set enrichment analysis (<font color="CadetBlue">**eSEA**</font>) to identify dysregulated metabolic pathways via considering both metabolites and genes  

- **Algorithm for metabolism-related subnetwork analysis:** Maximising the potential of our well-established <font color="CadetBlue">**dnet**</font> algorithm in integrative analysis of metabolomic and transcriptomic data to provide a systems-level understanding of metabolic interconnections

![Figure 1 Overview](vignettes/data/Figure1.jpg)

<font size="2" color="CadetBlue">**Figure 1. Overview of the analytical model underlying MNet.** **(A)** The MNet model includes three primary components: _**Knowledgebase**_, _**Algorithm**_, and _**Deployment**_. Their interconnected relationships are illustrated. **(B)** The _**Knowledgebase**_ component comprises gene-metabolite pairs sourced from five primary data sources. This comprehensive knowledgebase forms the foundation for both extended pathway and subnetwork analyses (see the next _**Algorithm**_ component). **(C)** The _**Algorithm**_ component includes methods for extended pathway and metabolism-related subnetwork analyses. Extended pathway analyses (implemented in ePEA, ePDA, and eSEA) consider both genes and metabolites, while metabolism-related subnetwork analysis employs our previously well-established algorithm ‘dnet’ to explore interactions involving genes and metabolites. **(D)** The _**Deployment**_ component includes its use via programmatically accessible R functions and an intuitive Shiny user interface.</font>

## 2. Get Started

Get started can be found [here](https://tuantuangui.github.io/MNet/articles/MNet.html)

### 2.1 R Installation

R (http://www.r-project.org) is a language and environment for statistical computing and graphics. We assume R (version 4.0.0 or higher) has been installed in your local machine. The latest version can be installed following instructions below for different platforms (Windows, Mac, and Linux).

- Quick link for Windows: [Download R for Windows](https://cran.r-project.org/bin/windows/base/).

- Quick link for Mac: [Download R for Mac OS X 11](https://cran.r-project.org/bin/macosx/big-sur-arm64/base/).

- Below are shell command lines in Terminal (for Linux):

```bash
#Ensure you have the conda:
conda install -c conda-forge r-base
```

### 2.2 MNet Installation

MNet requires R version 4.0.0 or higher. The `dnet`, `supraHex`, and `DMwR2` dependencies are installed from GitHub; other dependencies are resolved from CRAN and Bioconductor.

MNet is available for all operating systems and can be installed via the Github.

```R
install.packages("BiocManager")
BiocManager::install("remotes", ask = FALSE, update = FALSE)

# Make both CRAN and the matching Bioconductor repositories available to remotes.
options(repos = BiocManager::repositories())

# Install non-CRAN dependencies before MNet. supraHex is a dependency of dnet.
remotes::install_github("hfang-bristol/supraHex", dependencies = TRUE, upgrade = "never")
remotes::install_github("hfang-bristol/dnet", dependencies = TRUE, upgrade = "never")
remotes::install_github("ltorgo/DMwR2", dependencies = TRUE, upgrade = "never")

# DESCRIPTION also records these GitHub sources in its Remotes field.
remotes::install_github("tuantuangui/MNet", dependencies = TRUE, upgrade = "never")
```

Check the package 'MNet' successfully installed

```R
library(help=MNet)
```

### 2.3 Docker Deployment

MNet can be run in a Docker container without manually installing R and its dependencies.

**Prerequisites:** [Docker](https://docs.docker.com/get-docker/) (or Docker Desktop).

#### Option 1: Pull the pre-built image from Docker Hub

**[Docker Hub: https://hub.docker.com/r/hiomics/mnet](https://hub.docker.com/r/hiomics/mnet)**

```bash
docker pull hiomics/mnet:latest
docker run -d --name mnet-shiny -p 3838:3838 hiomics/mnet:latest
```

#### Option 2: Build the image locally

```bash
docker build -t mnet:latest .
docker run -d --name mnet-shiny -p 3838:3838 mnet:latest
```

Or start with Docker Compose:

```bash
docker compose up -d
```

Then open http://localhost:3838/ in your browser.

Useful commands:

```bash
docker logs -f mnet-shiny   # view logs
docker stop mnet-shiny      # stop the app
docker compose down         # stop and remove (compose)
```

### 2.4 Usage

- Extended pathway analysis can be found [here](https://tuantuangui.github.io/MNet/articles/01-Pathway_analysis.html)

- Metabolism-related subnetwork analysis can be found [here](https://tuantuangui.github.io/MNet/articles/02-Subnetwork_analysis.html)

- Routine analysis can be found [here](https://tuantuangui.github.io/MNet/articles/03-Routine_analysis.html)

## 3. Need help?

If you have any questions about MNet, please don’t hesitate to email me (guituant2009@163.com).

### 3.1 Frequently Asked Questions

1. If installation reports that `dnet`, `supraHex`, or `DMwR2` is unavailable, install the GitHub dependencies in the order shown above, then rerun the MNet installation command. `BiocManager::install()` is for CRAN and Bioconductor packages; use `remotes::install_github()` for these GitHub repositories.
