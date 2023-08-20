## library(coga)
context("distribution of convolution of gamma")

test_that("input check of shape", {
    expect_error(pcoga(4, shape=c(-1, 3), rate=c(4, 5)))
    expect_error(pcoga(4, shape=c(0, 0), rate=c(4, 5)))
})

test_that("input check of rate", {
    expect_error(pcoga(4, shape=c(2, 3), rate=c(-4, 5)))
    expect_error(pcoga(4, shape=c(2, 3), rate=c(0, 5)))
})

test_that("input check of x", {
    expect_equal(pcoga(-4, shape=c(2, 3), rate=c(4, 5)),
                 0)
    expect_equal(pcoga(0, shape=c(2, 3), rate=c(4, 5)),
                 0)
})

test_that("handle some shapes are 0", {
    expect_equal(pcoga(4, shape=c(2, 3, 0), rate=c(4, 5, 6)),
                 pcoga(4, shape=c(2, 3), rate=c(4, 5)))
    expect_equal(pcoga(4, shape=c(2, 3, 0, 0), rate=c(4, 5, 6, 7)),
                 pcoga(4, shape=c(2, 3, 0), rate=c(4, 5, 6)))
})

test_that("handle recycle", {
    expect_equal(pcoga(4, shape=c(2), rate=c(4, 5, 6)),
                 pcoga(4, shape=c(2, 2, 2), rate=c(4, 5, 6)))
    expect_equal(pcoga(4, shape=c(2, 3, 4), rate=c(4, 4, 4)),
                 pcoga(4, shape=c(2, 3, 4), rate=c(4)))
    expect_equal(pcoga(4, shape=c(2, 3, 2, 3), rate=c(4, 2, 5, 3)),
                 pcoga(4, shape=c(2, 3), rate=c(4, 2, 5, 3)))
    expect_equal(pcoga(4, shape=c(2, 3, 4, 6, 7), rate=c(4, 3)),
                 pcoga(4, shape=c(2, 3, 4, 6, 7), rate=c(4, 3, 4, 3, 4)))
})
