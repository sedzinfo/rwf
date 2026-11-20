# rwf

[Help pages](https://sedzinfo.github.io/rwf/reference/)

## What it does

`rwf` is an R package designed to streamline **statistical reporting**
and enhance **visualizations** for commonly used methodologies in
psychology. By automating code-heavy tasks using well-known R packages,
`rwf` helps researchers and data scientists save time and reduce coding
complexity.

## Features

- Statistical reporting for ANOVA, regression, t-tests, and more.
- Intuitive visualizations: ROC curves, histograms, scatterplots, and
  interaction plots.
- Support for advanced modeling: CFA, IRT models, Thurstonian scales.
- Simulated datasets for practice and demonstration.

## Installation

### 1. Install R

Download R 3.5 or newer from [CRAN](https://cran.r-project.org/), for
Windows, macOS or Linux, and run the installer.

### 2. Install RStudio or Positron

An editor makes R easier to use. It is optional, and both are free, from
Posit:

- [RStudio Desktop](https://posit.co/download/rstudio-desktop/)
- [Positron](https://positron.posit.co/download.html), which also runs
  Python

### 3. Install rwf

Run one of these in RStudio, Positron or the R console. Each one also
installs the packages rwf needs.

#### From R-universe (recommended)

[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(`` `` ``"rwf"``,`` `` repos ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"https://sedzinfo.r-universe.dev"``, ``"https://cloud.r-project.org"``)`` ``)`

[R-universe](https://sedzinfo.r-universe.dev/rwf) builds rwf from this
repository after every change, ready to install on Windows, macOS and
Linux, and CRAN provides the packages it needs.

#### From GitHub

[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"pak"``)`` ``# once`` ``pak``::`[`pak`](https://pak.r-lib.org/reference/pak.html)`(``"sedzinfo/rwf/rwf"``)`

#### From the release tarball

The [latest
release](https://github.com/sedzinfo/rwf/releases/tag/latest) has the
source tarball and the PDF manual, rebuilt from `main` on every change:

[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"pak"``)`` ``# once`` ``pak``::`[`pak`](https://pak.r-lib.org/reference/pak.html)`(``"url::https://github.com/sedzinfo/rwf/releases/download/latest/rwf_0.1.0.tar.gz"``)`

#### From a clone of the repository, with Git LFS

Use this path when you want the whole repository, including the files
outside the package that are tracked by [Git LFS](https://git-lfs.com),
such as the raw data in `data/` and the archived packages in
`working_functions/PACKAGES/`. The package and its datasets install
completely with the commands above, without Git LFS.

**1. Install [Git](https://git-scm.com/downloads) and Git LFS**, once
per computer. Git for Windows includes Git LFS; on macOS run
`brew install git-lfs`, on Ubuntu or Debian `sudo apt install git-lfs`,
or use the installer from [git-lfs.com](https://git-lfs.com). Then turn
it on:

``` bash
git lfs install
```

**2. Clone the repository and download the LFS files:**

``` bash
git clone https://github.com/sedzinfo/rwf.git
cd rwf
git lfs pull
```

`git lfs ls-files` lists the files in Git LFS. If you cloned before
installing Git LFS, they are small pointer files: run `git lfs install`
and `git lfs pull` to download them.

**3. Install the package from the clone:**

[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"pak"``)`` ``# once`` ``pak``::`[`local_install`](https://pak.r-lib.org/reference/local_install.html)`(``"path/to/rwf/rwf"``)`

To update it later, run `git pull` and `git lfs pull` in the clone, and
install again.

## Usage

[`library`](https://rdrr.io/r/base/library.html)`(`[`rwf`](https://sedzinfo.github.io/rwf/)`)`` ``x`` ``<-`` ``df_insurance``[``, `[`c`](https://rdrr.io/r/base/c.html)`(``"age"``, ``"bmi"``, ``"charges"``)``]`` ``correlations`` ``<-`` `[`report_correlation`](https://sedzinfo.github.io/rwf/reference/report_correlation.md)`(``x``, scatterplot ``=`` ``FALSE``)`` ``correlations``$``r_lower`` ``# also the p values, confidence intervals, sample sizes, ...`` `[`report_correlation`](https://sedzinfo.github.io/rwf/reference/report_correlation.md)`(``x``, scatterplot ``=`` ``FALSE``, file ``=`` ``"correlations"``)`` ``# saves the tables in correlations.xlsx and the plot in correlations_corrplot.pdf`

Most `report_*` functions take a `file` argument in the same way. Every
function has a [help page](https://sedzinfo.github.io/rwf/reference/)
with examples, and the
[articles](https://sedzinfo.github.io/rwf/articles/) work through each
method with its output.

------------------------------------------------------------------------

[![R-universe](https://sedzinfo.r-universe.dev/rwf/badges/version)](https://sedzinfo.r-universe.dev/rwf)
![Stars](https://img.shields.io/github/stars/sedzinfo/rwf)![Watchers](https://img.shields.io/github/watchers/sedzinfo/rwf)![Repo
Size](https://img.shields.io/github/repo-size/sedzinfo/rwf)![Open
Issues](https://img.shields.io/github/issues/sedzinfo/rwf)![Forks](https://img.shields.io/github/forks/sedzinfo/rwf)![Last
Commit](https://img.shields.io/github/last-commit/sedzinfo/rwf)![Contributors](https://img.shields.io/github/contributors/sedzinfo/rwf)![License](https://img.shields.io/github/license/sedzinfo/rwf)![Workflow
Status](https://img.shields.io/github/actions/workflow/status/sedzinfo/rwf/build-tarball.yml)![R-CMD-check](https://github.com/sedzinfo/rwf/actions/workflows/r.yml/badge.svg)
