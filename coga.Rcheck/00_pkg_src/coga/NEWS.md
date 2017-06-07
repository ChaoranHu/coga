# CHANGES IN coga VERSION 0.1.0.9000

## MAJOR CHANGES

* Create 'coga.h' and 'coga_RcppExports.h' to make C++ code can be called directly.

* Modified parameter shape and rate recycling work. When the length of one parameter is not a multiple of another, `dcoga`, `pcoga`, and `rcoga` will return a warning.

* Add functions, `dcoga2dim`, and `pcoga2dim`, in order to achieve higher performance under situation of convolution of two gamma distributions.

## MINOR CHANGES

* Updated CRAN URL and BugReport URL from bitbucket to github.

* Updated Vignette.


# CHANGES IN coga VERSION 0.1.0

## NEW FEATURES

* The first version of **coga** providing `dcoga` for density function of convolution of gamma distributions, `pcoga` for distribution function of convolution of gamma distributions, and `rcoga` for simulating sample from convolution of gamma distributions.
