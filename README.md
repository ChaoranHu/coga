# README #

[![Build Status](https://travis-ci.org/ChaoranHu/coga.svg?branch=master)](https://travis-ci.org/ChaoranHu/coga)

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/coga)](https://cran.r-project.org/package=coga)

This README would normally document whatever steps are necessary to get your application up and running.

### What is this R package for? ###

* Convolution of gamma distributions in R. The convolution of gamma distributions is the sum of series of gamma distributions and all gamma distributions here can have different parameters. This package can calculate density function (`dcoga`), distribution function (`pcoga`), and do simulation work (`rcoga`). Also, this package provide functions, `dcoga2dim` and `pcoga2dim`, to calculate density and distribution function of convolution of *two* gamma distributions, which are much faster than general functions. This package also implements the recurrence identity of shape parameter during convolution of two gamma distributions, via `pcoga2dim_diff_shape`. The approximation method for convolution of three or more gamma distribuitons is implemented and can be access with R function `dcoga_approx` and `pcoga_approx`. This approximation method can give an approximate result and improve the speed of the code significantly.

* Version: 0.2.1.9000

### How do I get set up? ###

* Run the following R code.

```
install.packages("devtools")

## install package without vignette
devtools::install_github("ChaoranHu/coga")

## install package include vignette
devtools::install_github("ChaoranHu/coga", build_vignettes = TRUE)
```

or

```
install.packages("coga")
```

Note: The first way need your computer have development tools, but can help you follow the newest version from my github. This package includes Cpp and C codes, so you need a CPP compiler (for mac, you can use Xcode, which can be installed from Apple Store). Also, this package use GNU GSL, so you also need to install GNU GSL first. If you do not have these tools, please use second way to install from CRAN.

* Run `library(coga)` to load in R.

### How do I use? ###

Please read vignette of this package by type `browseVignettes("coga")` in R, which includes several examples.

### Who do I talk to? ###

Chaoran Hu, <chaoran.hu@uconn.edu>

### Reference ###

[1] Moschopoulos, Peter G. "The distribution of the sum of independent gamma random variables." Annals of the Institute of Statistical Mathematics 37.1 (1985): 541-544.

[2] Mathai, A.M.: Storage capacity of a dam with gamma type inputs. Ann. Inst. Statist.Math. 34, 591-597 (1982).

[3] Barnabani, M. (2017). An approxmation to the convolution of gamma distributions. Communications in Statistics - Simulation and Computation 46(1), 331-343.
