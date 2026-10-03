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

> **Note on Git LFS:** `remotes::install_github()` downloads a ZIP archive which does **not** include Git LFS files — large assets will appear as broken pointer files. If the package functions that depend on those files are critical to you, use the **Clone & Install** path below. If you only need the R code (functions, no bundled datasets), the standard `remotes` install is sufficient.

### Option A — Standard install

```r
install.packages("https://github.com/sedzinfo/rwf/raw/refs/heads/main/rwf_0.1.0.tar.gz")
```

---

### Option B — Standard install (R code only, no LFS assets)

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

Use this path when you need bundled datasets or any other large files tracked by LFS.

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

### Keeping up to date (Option B)

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
![Workflow Status](https://img.shields.io/github/actions/workflow/status/sedzinfo/rwf/r.yml)

