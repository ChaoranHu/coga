## library(coga)
context("random generation of convolution of gamma")

test_that("input check of shape", {
    expect_error(rcoga(10, shape=c(-1, 3), rate=c(4, 5)))
    expect_error(rcoga(10, shape=c(0, 0), rate=c(4, 5)))
})

test_that("input check of rate", {
    expect_error(rcoga(10, shape=c(2, 3), rate=c(-4, 5)))
    expect_error(rcoga(10, shape=c(2, 3), rate=c(0, 5)))
})

