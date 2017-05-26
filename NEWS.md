# CHANGES IN coga VERSION 0.1.0.9000

## MAJOR CHANGES

* Create 'coga.h' to make CPP code can be called directly.

* Modified parameter shape and rate recycling work. When the length of one parameter is not a multiple of another, `dcoga`, `pcoga`, and `rcoga` will return a warning.

## MINOR CHANGES

* Updated CRAN URL and BugReport URL to github.



# CHANGES IN coga VERSION 0.1.0

## NEW FEATURES

* The first version of **coga** providing `dcoga` for density function of convolution of gamma distributions, `pcoga` for distribution function of convolution of gamma distributions, and `rcoga` for simulating sample from convolution of gamma distributions.