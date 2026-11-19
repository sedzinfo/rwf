# rwf
**Version 0.1**

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

> **Note on Git LFS:** the package and its datasets install completely with any of the options below. Git LFS is only used for files the package does not need, such as the raw data in `data/` and the archived packages in `working_functions/PACKAGES/`, so you only need it when you clone the repository (Option C).

### Option A — Standard install

The source tarball of the [latest release](https://github.com/sedzinfo/rwf/releases/tag/latest), rebuilt from `main` on every change, together with the PDF manual:

```r
install.packages(
  "https://github.com/sedzinfo/rwf/releases/download/latest/rwf_0.1.0.tar.gz",
  repos = NULL, type = "source"
)
```

---

### Option B — Install from GitHub

```r
install.packages("remotes")
remotes::install_github("sedzinfo/rwf/rwf")
```

For a private repository:

```r
install.packages(c("devtools", "usethis", "credentials", "remotes"))

usethis::use_git_config(user.name = "YourName", user.email = "your@mail.com")
usethis::create_github_token()   # opens GitHub — generate a PAT there
credentials::set_github_pat()    # paste your PAT into the prompt

remotes::install_github("sedzinfo/rwf/rwf")
```

---

### Option C — Clone & install (includes Git LFS assets)

Use this path when you want the whole repository, including the files outside the package that are tracked by Git LFS (such as the raw data in `data/`).

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

**Public:**
```bash
git clone https://github.com/sedzinfo/rwf.git
cd rwf
```

**Private (token auth):**
```bash
git clone https://YOUR_PAT@github.com/sedzinfo/rwf.git
cd rwf
```

Replace `YOUR_PAT` with a Personal Access Token generated at **GitHub → Settings → Developer settings → Personal access tokens**. The token needs at minimum `repo` scope.

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

---

### Keeping up to date (Option C)

```bash
git pull
git lfs pull
```

Then reinstall in R:
```r
devtools::install("path/to/rwf/rwf")
```

---

![Stars](https://img.shields.io/github/stars/sedzinfo/rwf)
![Watchers](https://img.shields.io/github/watchers/sedzinfo/rwf)
![Repo Size](https://img.shields.io/github/repo-size/sedzinfo/rwf)
![Open Issues](https://img.shields.io/github/issues/sedzinfo/rwf)
![Forks](https://img.shields.io/github/forks/sedzinfo/rwf)
![Last Commit](https://img.shields.io/github/last-commit/sedzinfo/rwf)
![Contributors](https://img.shields.io/github/contributors/sedzinfo/rwf)
![License](https://img.shields.io/github/license/sedzinfo/rwf)
![Release](https://img.shields.io/github/v/release/sedzinfo/rwf)
![Workflow Status](https://img.shields.io/github/actions/workflow/status/sedzinfo/rwf/main.yml)

