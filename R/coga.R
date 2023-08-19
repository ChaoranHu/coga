##' coga: Convolution of independent Gamma Distributions
##'
##' Evaluation for density and distribution function of convolution of gamma
##' distributions in R. Two related exact methods and one approximate method are
##' implemented with efficient algorithm and C++ code. A quick guide for choosing
##' correct method and usage of this package is given in package vignette.
##'
##' @section coga functions:
##' dcoga, pcoga, rcoga, dcoga2dim, pcoga2dim, pcoga2dim_diff_shape, dcoga_approx, and
##' pcoga_approx.
##'
##' @author
##' \itemize{
##'   \item *maintainer, author* Chaoran Hu \email{chaoran.hu@@uconn.edu}
##'   \item *advisor* Jun Yan \email{jun.yan@@uconn.edu}
##'   \item *advisor* Vladimir Pozdnyakov \email{vladimir.pozdnyakov@@uconn.edu}
##' }
##' 
##' @docType package
##' @name coga
##' @aliases coga-package
##' @useDynLib coga
##' @importFrom Rcpp sourceCpp
##' @importFrom Rcpp evalCpp

NULL
