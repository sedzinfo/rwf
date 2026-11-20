# rwf

[Website](https://sedzinfo.github.io/rwf/)

---

## Overview

`rwf` is an R package designed to streamline **statistical reporting** and enhance **visualizations** for commonly used methodologies in psychology. By automating code-heavy tasks using well-known R packages, `rwf` helps researchers and data scientists save time and reduce coding complexity.

## Key Features

- Statistical reporting for ANOVA, regression, t-tests, and more.
- Intuitive visualizations: ROC curves, histograms, scatterplots, and interaction plots.
- Support for advanced modeling: CFA, IRT models, Thurstonian scales.
- Simulated datasets for practice and demonstration.

---

## Installation

### Prerequisites

1. **Install R** (version 3.5 or higher): https://cran.r-project.org/
2. **Install RStudio** (optional but recommended): https://posit.co/downloads/

### Package Installation

Open RStudio (or an R console) and run:

```r
install.packages(
  "rwf",
  repos = c("https://sedzinfo.r-universe.dev", "https://cloud.r-project.org")
)
```

[R-universe](https://sedzinfo.r-universe.dev/rwf) builds rwf from this repository, and CRAN provides the packages it needs.

To install from GitHub instead:

```r
# Install devtools if you haven't already
install.packages("devtools")
# Install rwf from GitHub
devtools::install_github("sedzinfo/rwf/rwf")
```

Or install the source tarball of the [latest release](https://github.com/sedzinfo/rwf/releases/tag/latest), which is rebuilt from `main` on every change, together with the PDF manual:

```r
install.packages(
  "https://github.com/sedzinfo/rwf/releases/download/latest/rwf_0.1.0.tar.gz",
  repos = NULL, type = "source"
)
```

### From a clone of the repository

Use this path when you want the whole repository, including the files outside the package that are tracked by Git LFS, such as the raw data in `data/` and the archived packages in `working_functions/PACKAGES/`. The package and its datasets install completely with the commands above, without Git LFS.

#### 1. Install Git LFS (one-time)

**Ubuntu/Debian:**
```bash
sudo apt install git-lfs
git lfs install
```

**macOS:**
```bash
brew install git-lfs
git lfs install
```

**Windows:**
Download and run the installer from https://git-lfs.com, then:
```bash
git lfs install
```

#### 2. Clone the repository

```bash
git clone https://github.com/sedzinfo/rwf.git
cd rwf
```

#### 3. Pull LFS files

```bash
git lfs pull
```

To verify LFS files downloaded correctly (you should see real file sizes, not 130-byte pointers):
```bash
git lfs ls-files
```

> If you cloned *before* installing Git LFS and files appear as small pointer files, run `git lfs install` then `git lfs pull` to hydrate them.

#### 4. Install the package from the local clone

```r
install.packages("devtools")
devtools::install("path/to/rwf/rwf")
```

#### Keeping up to date

```bash
git pull
git lfs pull
```

Then reinstall in R:
```r
devtools::install("path/to/rwf/rwf")
```

---

[![R-universe](https://sedzinfo.r-universe.dev/rwf/badges/version)](https://sedzinfo.r-universe.dev/rwf)
![Stars](https://img.shields.io/github/stars/sedzinfo/rwf)
![Watchers](https://img.shields.io/github/watchers/sedzinfo/rwf)
![Repo Size](https://img.shields.io/github/repo-size/sedzinfo/rwf)
![Open Issues](https://img.shields.io/github/issues/sedzinfo/rwf)
![Forks](https://img.shields.io/github/forks/sedzinfo/rwf)
![Last Commit](https://img.shields.io/github/last-commit/sedzinfo/rwf)
![Contributors](https://img.shields.io/github/contributors/sedzinfo/rwf)
![License](https://img.shields.io/github/license/sedzinfo/rwf)
![Workflow Status](https://img.shields.io/github/actions/workflow/status/sedzinfo/rwf/build-tarball.yml)
![R-CMD-check](https://github.com/sedzinfo/rwf/actions/workflows/r.yml/badge.svg)
