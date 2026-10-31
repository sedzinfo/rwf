#!/usr/bin/env bash
# Installs everything rwf needs on Ubuntu and Linux Mint (Ubuntu-based editions):
# R from CRAN's apt repository, the system libraries that rwf's R dependencies
# compile or link against, Java for openNLP/rJava, and then the R packages.
#
# Usage: ./install_dependencies.sh [options]
# Run it as your normal user; it calls sudo itself for the apt steps.
#
#   --system-only    install the system packages only, skip the R packages
#   --no-suggests    skip the Suggests packages (thurstonianIRT/rstan, rJava, caret, ...)
#   --no-cran-repo   do not add CRAN's apt repository, use the distribution's R
#   --from-source    compile R packages from CRAN sources instead of Posit binaries (slow)
#   --with-latex     also install TeX Live + qpdf, to build rwf.pdf and run R CMD check
#                    (texlive-fonts-extra alone is over 1 GB)
#   --dry-run        print the commands instead of running them
#   -h, --help       show this help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/rwf"

SYSTEM_ONLY=0
SUGGESTS=1
CRAN_REPO=1
FROM_SOURCE=0
LATEX=0
DRY_RUN=0

# system libraries for rwf's full dependency tree (Imports, Suggests and devtools),
# taken from the Posit sysreqs database; the comments name the R packages needing them
SYSTEM_PACKAGES=(
  cmake                 # nloptr (car -> lme4), RcppParallel (rstan), fs
  make
  git                   # remotes, gert, credentials
  default-jdk           # rJava, openNLP, openNLPdata
  pandoc                # rmarkdown, knitr, pkgdown, vignettes
  libcurl4-openssl-dev  # curl
  libssl-dev            # curl, openssl
  libxml2-dev           # xml2 (tm), igraph
  libglpk-dev           # igraph
  libicu-dev            # stringi (stringr)
  libuv1-dev            # fs
  zlib1g-dev            # httpuv, haven
  libgit2-dev           # gert (devtools, usethis)
  libx11-dev            # clipr
  libfontconfig1-dev    # systemfonts
  libfreetype6-dev      # systemfonts, textshaping, ragg
  libharfbuzz-dev       # textshaping
  libfribidi-dev        # textshaping
  libpng-dev            # ragg, svglite
  libjpeg-dev           # ragg
  libtiff-dev           # ragg
  libwebp-dev           # ragg
)

# R CMD Rd2pdf needs inconsolata (texlive-fonts-extra), upquote and makeindex
LATEX_PACKAGES=(
  texlive-latex-base
  texlive-latex-recommended
  texlive-latex-extra
  texlive-fonts-recommended
  texlive-fonts-extra
  texinfo
  qpdf
)

log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

run() {
  if (( DRY_RUN )); then printf '+'; printf ' %q' "$@"; printf '\n'; else "$@"; fi
}

run_r() {
  if (( DRY_RUN )); then printf '+ Rscript -e <<R\n%s\nR\n' "$1"; else Rscript -e "$1"; fi
}

usage() { sed -n '2,/^$/{s/^# \{0,1\}//;p}' "${BASH_SOURCE[0]}"; }

# installs the given apt packages, skipping (with a warning) any this release does not have
apt_install() {
  local available=() pkg
  for pkg in "$@"; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      warn "$pkg is not available on this release, skipping it"
    fi
  done
  (( ${#available[@]} )) || return 0
  run "${SUDO[@]}" apt-get install -y "${available[@]}"
}

add_cran_repo() {
  local url="https://cloud.r-project.org/bin/linux/ubuntu" f files=()
  # Ubuntu 24.04 may have no sources.list at all, so only existing files are searched
  for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do
    [[ -f "$f" ]] && files+=("$f")
  done
  if (( ${#files[@]} )) && grep -qs '^[^#]*/bin/linux/ubuntu' "${files[@]}"; then
    log "CRAN apt repository already configured"
    return
  fi
  if ! curl -fsSL -o /dev/null "$url/${CODENAME}-cran40/Release"; then
    warn "CRAN has no R build for $CODENAME, using the distribution's R instead"
    return
  fi
  log "Adding CRAN apt repository ($CODENAME-cran40)"
  run "${SUDO[@]}" install -d -m 0755 /etc/apt/keyrings
  run "${SUDO[@]}" curl -fsSL -o /etc/apt/keyrings/cran_ubuntu_key.asc "$url/marutter_pubkey.asc"
  local line="deb [signed-by=/etc/apt/keyrings/cran_ubuntu_key.asc] $url ${CODENAME}-cran40/"
  if (( DRY_RUN )); then
    printf '+ echo %q > /etc/apt/sources.list.d/cran-r.list\n' "$line"
  else
    printf '%s\n' "$line" | "${SUDO[@]}" tee /etc/apt/sources.list.d/cran-r.list >/dev/null
  fi
  run "${SUDO[@]}" apt-get update
}

install_r_packages() {
  local repo="https://cloud.r-project.org" deps=TRUE
  (( SUGGESTS )) || deps=NA
  if (( ! FROM_SOURCE )); then
    local p3m="https://packagemanager.posit.co/cran/__linux__/${CODENAME}/latest"
    if curl -fsSL -o /dev/null "$p3m/src/contrib/PACKAGES"; then
      repo="$p3m"
    else
      warn "no Posit binaries for $CODENAME, R packages will be compiled from source (slow)"
    fi
  fi

  log "Installing R packages from $repo"
  # the user agent is how Posit Package Manager decides to serve binaries for this R version;
  # packages go to the user library when the site library is not writable
  run_r "$(cat <<EOF
options(repos = c(CRAN = "$repo"),
        HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
          paste(getRversion(), R.version[["platform"]], R.version[["arch"]], R.version[["os"]])))
if (file.access(.libPaths()[1], 2) != 0) {
  lib <- path.expand(Sys.getenv("R_LIBS_USER"))
  dir.create(lib, recursive = TRUE, showWarnings = FALSE)
  .libPaths(c(lib, .libPaths()))
}
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")
pak::local_install_deps("$PKG_DIR", dependencies = $deps, upgrade = FALSE)
pak::pkg_install("devtools", upgrade = FALSE)
EOF
)"

  log "Checking that every dependency in DESCRIPTION is installed"
  run_r "$(cat <<EOF
fields <- c("Depends", "Imports", if ($SUGGESTS) "Suggests")
d <- read.dcf("$PKG_DIR/DESCRIPTION", fields = fields)
pkgs <- trimws(sub("\\\\(.*", "", unlist(strsplit(d[!is.na(d)], ","))))
pkgs <- setdiff(pkgs[nzchar(pkgs)], "R")
missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(missing)) stop("not installed: ", paste(missing, collapse = ", "))
cat("all", length(pkgs), "dependencies are installed\n")
EOF
)"
}

while (( $# )); do
  case "$1" in
    --system-only)  SYSTEM_ONLY=1 ;;
    --no-suggests)  SUGGESTS=0 ;;
    --no-cran-repo) CRAN_REPO=0 ;;
    --from-source)  FROM_SOURCE=1 ;;
    --with-latex)   LATEX=1 ;;
    --dry-run)      DRY_RUN=1 ;;
    -h|--help)      usage; exit 0 ;;
    *)              usage >&2; die "unknown option: $1" ;;
  esac
  shift
done

command -v apt-get >/dev/null || die "apt-get not found, this script supports Ubuntu and Linux Mint only"
[[ -r /etc/os-release ]] || die "cannot read /etc/os-release"
# shellcheck source=/dev/null
. /etc/os-release
# Linux Mint has its own codename (e.g. zena); CRAN and Posit publish under the Ubuntu one (noble)
CODENAME="${UBUNTU_CODENAME:-}"
[[ -z "$CODENAME" && "${ID:-}" == ubuntu ]] && CODENAME="${VERSION_CODENAME:-}"
[[ -n "$CODENAME" ]] || die "this script supports Ubuntu and Ubuntu-based Linux Mint only (found: ${PRETTY_NAME:-unknown})"

if (( EUID == 0 )); then
  [[ -z "${SUDO_USER:-}" ]] || die "run this as your normal user, not with sudo; it calls sudo itself for apt"
  SUDO=()
else
  command -v sudo >/dev/null || die "sudo is required"
  SUDO=(sudo)
fi

[[ -f "$PKG_DIR/DESCRIPTION" ]] || die "rwf package not found at $PKG_DIR; keep this script in the root of the rwf repository"

log "Detected ${PRETTY_NAME:-$ID} (Ubuntu base: $CODENAME)"

log "Installing prerequisites"
run "${SUDO[@]}" apt-get update
apt_install ca-certificates curl

(( CRAN_REPO )) && add_cran_repo

log "Installing R and system libraries"
packages=(r-base r-base-dev "${SYSTEM_PACKAGES[@]}")
# git-lfs may already be installed outside apt (e.g. in /usr/local/bin)
command -v git-lfs >/dev/null || packages+=(git-lfs)
(( LATEX )) && packages+=("${LATEX_PACKAGES[@]}")
apt_install "${packages[@]}"

log "Configuring Java for R (rJava, openNLP)"
run "${SUDO[@]}" R CMD javareconf

log "Enabling Git LFS for your user (rwf/data is stored in LFS)"
run git lfs install

(( SYSTEM_ONLY )) || install_r_packages

log "Done"
cat <<EOF
Next steps, from $SCRIPT_DIR:
  git lfs pull     # fetch the package data if rwf/data holds small pointer files
  make build       # install rwf itself (runs devinstall.R)
EOF
