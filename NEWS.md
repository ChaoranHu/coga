# CHANGES IN coga VERSION 0.2.2

## MAJOR CHANGES

* Rewrite function `dcoga2dim` and `pcoga2dim` to make it faster and more robust.

* Rewrite function `dcoga` to make it can handle wider ranges of parameters and x.

* Add new function `dcoga_approx` and `pcoga_approx` for approximation method, that can impove the speed of code under three or more variables case.

## MINOR CHANGES

* Remove `microbenchmark` from *Suggests* according to the requirement from CRAN.

* Move vignette to inst in order to pass the cran check with devel R.


# CHANGES IN coga VERSION 0.2.1

## MINOR CHANGES

* Rename variable `sun` to `starn`, in order to meet the requirement of solaris.

* Remove `RcppGSL` from import.

# CHANGES IN coga VERSION 0.2.0

## MAJOR CHANGES

* Create 'coga.h' and 'coga_RcppExports.h' to make C++ code can be called directly.

* Modify parameter shape and rate recycling work. When the length of one parameter is not a multiple of another, `dcoga`, `pcoga`, and `rcoga` will return a warning.

* Add functions, `dcoga2dim`, and `pcoga2dim`, in order to achieve higher performance under situation of convolution of two gamma distributions.

* Add function, `pcoga2dim_diff_shape`, in order to implementing the recurrence identity of shape parameter of convolution of two gamma distributions distribution function.

## MINOR CHANGES

* Update CRAN URL and BugReport URL from bitbucket to github.

* Update Vignette.


# CHANGES IN coga VERSION 0.1.0

## NEW FEATURES

* The first version of **coga** providing `dcoga` for density function of convolution of gamma distributions, `pcoga` for distribution function of convolution of gamma distributions, and `rcoga` for simulating sample from convolution of gamma distributions.
