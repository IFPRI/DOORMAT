
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Data Processor for IMPACT runs (DOORMAT)

### Status

<!-- badges: start -->

[![license](https://img.shields.io/badge/Licence-GPL%20(%3E%3D%203)-red)](https://github.com/IFPRI/reportIMPACT/blob/master/LICENSE.md)

[![:name status
badge](https://ifpri.r-universe.dev/badges/:name)](https://ifpri.r-universe.dev)

[![R-CMD-check](https://github.com/IFPRI/DOORMAT/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/IFPRI/DOORMAT/actions/workflows/R-CMD-check.yaml)

[![:registry status
badge](https://ifpri.r-universe.dev/badges/:registry)](https://ifpri.r-universe.dev)

[![DOORMAT status
badge](https://ifpri.r-universe.dev/badges/DOORMAT)](https://ifpri.r-universe.dev)
<!-- badges: end -->

## Introduction

DOORMAT (**D**ata pr**O**cessor f**O**R i**M**p**A**c**T**) is the core
R package which helps in compiling basic R functions to be able to
analyze some standard outputs from the the International Model for
Policy Analysis of Agricultural Commodities and Trade (IMPACT) model.

The IMPACT model was developed in the early 1990s to explore the long
term challenges facing policymakers in reducing hunger and poverty in a
sustainable fashion. The IMPACT model has been expanded and improved
repeatedly to respond to increasingly complex policy questions and the
state-of-the-art of modeling. [See documentation of most recent
update](http://www.ifpri.org/publication/international-model-policy-analysis-agricultural-commodities-and-trade-impact-model-0).

The goal of DOORMAT is to to be able to setup some standar functions
which will help in reading the outputs from a *gdx* file belonging to
the outputs of an IMPACT run. The package also provides a `buildPackage`
utility which helps in compiling the packages from the IMPACT
R-universe.

## Installing `rtools` on windows machines

Rtools is a toolchain bundle used for building R packages from source
(those that need compilation of C/C++ or Fortran code) and for build R
itself.

Rtools can be downloaded from the [RTools
website](https://cran.r-project.org/bin/windows/Rtools/)

Usually, Rtools also needs to be added to the `Environment Variables` in
windows machines. This is automatically done once you successfully
install Rtools.

## Setting user library

*skip this part if you already have a personal R library set*

*you can check this by running `Sys.getenv("R_LIBS_USER")` in an R
session and see if it returns a folder path you have setup as your
library.*

Sometimes, `Sys.getenv("R_LIBS_USER")` points to an `appdata` folder on
windows machines. It can cause some editing privileges to be removed
from inside an R environment. To make sure that packages can be
successfully installed, we can manually create a folder to hold personal
R libraries.

To do so, you can open a R session and paste the following:

``` r
path <- "C:/Rpackages"
if (!dir.exists(path)) {
  dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)
}
```

## Adding `GAMS` as `PATH` environment variable

See <https://www.gams.com/latest/docs/UG_WIN_INSTALL.html>

> When installing a fresh copy of GAMS or updating GAMS, you have two
> options to run the installer: In default or advanced mode. In the
> default mode, the installer will prompt you for the name of the
> directory in which to install GAMS. You may accept the default choice
> or pick another directory. Please remember: if you want to install two
> different versions of GAMS, they must be in separate directories.

> If you choose to use the advanced mode, the installer will also ask
> you for a name of a start menu folder, if GAMS should be installed for
> all users, if the GAMS directory should be added to the PATH
> environment variable and which desktop icons should be created.

## Installing `devtools`

The aim of devtools is to make package development easier by providing R
functions that simplify and expedite common tasks. R Packages is a book
based around this workflow.

``` r
# Install devtools from CRAN
install.packages("devtools", dependencies=TRUE)

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("r-lib/devtools", dependencies=TRUE)
```

## Additional repository

For installation of the most recent package version of IFPRI managed R
packages, `magclass` (for array based operations), additional
repositories have to be added in R:

``` r
options(repos = c(CRAN="https://cloud.r-project.org/", PIK="https://rse.pik-potsdam.de/r/packages", KIRAN="https://ifpri.r-universe.dev"))
```

Here,

- CRAN is the Comprehensive R Archive Network

- PIK is the repository managed by PIK in Germany

- KIRAN is the Key IMPACT R Archive Network managed by IFPRI

## Installing `magclass`

`magclass` package can be installed from the `pik-piam` universe of
packages. This package is also distributed via CRAN but is not as
frequently updated. Installation of this package can be easily achieved
via:

``` r
# Development version from GitHub:
# install.packages("devtools")
devtools::install_github("pik-piam/magclass", dependencies=TRUE)
```

## Installing dependencies

Installation of R package `gamstransfer` is required before `DOORMAT`
can be used correctly.

GAMS Transfer R (`gamstransfer`) depends on packages `R6`, `R.utils`,
and `Rcpp`. These can be manually installed if needed by running the
following commands in an R session:

``` r
install.packages("R6", dependencies=TRUE)
install.packages("R.utils", dependencies=TRUE)
install.packages("Rcpp", dependencies=TRUE)
```

## Installation of `gamstransfer`

Starting with release of GAMS 41.1.0, the standard R library for reading
`gdx` files in R using the package `gdxrrw` is deprecated.

As `gdxrrw` is earmarked for removal in a future release, use of “GAMS
Transfer R” is recommended. GAMS Transfer is a package to maintain GAMS
data outside a GAMS script in a programming language like R. GAMS
Transfer’s main focus is the highly efficient transfer of data between
GAMS and R, while keeping those operations as simple as possible for the
user. In order to achieve this, symbol records - the actual and
potentially large-scale data sets - are stored in native data structures
of the corresponding programming languages (like R).

The user must download and install the latest version of GAMS in order
to install GAMS Transfer R. GAMS Transfer R can then be installed from
either the source package or from the binary package.

The installation from the source will install `gamstransfer` and all of
its dependencies.

``` r
install.packages("[PathToGAMS]/apifiles/R/gamstransfer/source/gamstransfer_r.tar.gz", dependencies=TRUE)
```

The users can also install gamstransfer without compiling the package
source code using gamstransfer binary package. The binary packages are
platform dependent and the instructions for each supported platform are
shown below.

On Windows

``` r
install.packages("[PathToGAMS]/apifiles/R/gamstransfer/binary/gamstransfer.zip", type="binary")
```

On linux

``` r
install.packages("[PathToGAMS]/apifiles/R/gamstransfer/binary/gamstransfer.tar.gz")
```

On macOS

``` r
install.packages("[PathToGAMS]/apifiles/R/gamstransfer/binary/gamstransfer.tgz", type="binary")
```

See documentation on [GAMS
website](https://www.gams.com/latest/docs/API_R_GAMSTRANSFER.html)

## Installing `DOORMAT`

Once `gasmtransfer` is installed, you can install the latest version of
DOORMAT from [GitHub](https://github.com/) with:

``` r
devtools::install_github("IFPRI/DOORMAT", dependencies=TRUE)
```

## Questions / Problems

In case of questions / problems please contact Abhijeet Mishra
(<A.Mishra@cgiar.org>)
