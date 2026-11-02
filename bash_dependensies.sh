#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install r-base r-base-dev r-cran-rjava r-cran-sparsem r-cran-rgl build-essential liblzma-dev libopenblas-dev liblapack-dev libmpfr-dev libgsl0-dev libpng-dev libjpeg-dev libgmp-dev tk-dev libproj-dev libx11-dev libpq5 libssl-dev
sudo R CMD javareconf