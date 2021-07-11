# README #

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/coga)](https://cran.r-project.org/package=coga)
[![Build Status](https://www.travis-ci.com/ChaoranHu/coga.svg?branch=master)](https://www.travis-ci.com/ChaoranHu/coga)

This README would normally document whatever steps are necessary to get this application up
and running.

### What is this R package for? ###

* Convolution of gamma distributions in R. The convolution of gamma distributions is the sum
of independent gamma distributions and all gamma distributions here can have different
parameters. The purpose of this package is calculating density, distribution function,
and do simulation work for convolution of gamma variables. Two related exact methods
(Moschopoulos, 1985)(Mathai, 1982) and one approximate method (Barnabani, 2017) are
implemented with efficient algorithm and `C++` code. A quick guide for this package is
given as package vignette.

* Version: 1.1.0.9000

### How do I get set up? ###

* Run the following R code.

```
## install.packages("devtools")
devtools::install_github("ChaoranHu/coga")
```

or

```
install.packages("coga")
```

Note: The first way need your computer have development tools, but can help you follow the newest version from my github. This package includes Cpp and C codes, so you need a CPP compiler (for mac, you can use Xcode, which can be installed from Apple Store). Also, this package use GNU GSL, so you also need to install GNU GSL first. If you do not have these tools, please use second way to install from CRAN.

* Run `library(coga)` to load in R.

### How do I use? ###

Please read the vignette of this package for more information, documentation and examples.

### Who do I talk to? ###

Chaoran Hu, <chaoran.hu@uconn.edu>

### Reference ###

[1] Moschopoulos, Peter G. "The distribution of the sum of independent gamma random variables." Annals of the Institute of Statistical Mathematics 37.1 (1985): 541-544.

[2] Mathai, A.M.: Storage capacity of a dam with gamma type inputs. Ann. Inst. Statist.Math. 34, 591-597 (1982).

[3] Barnabani, M. (2017). An approxmation to the convolution of gamma distributions. Communications in Statistics - Simulation and Computation 46(1), 331-343.

[4] Hu, C., Pozdnyakov, V., and Yan, J. (2020). Density and Distribution Evaluation for Convolution of Independent Gamma Variables. Computational Statistics 35, 327-342.
