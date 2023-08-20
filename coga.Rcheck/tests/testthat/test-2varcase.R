## library(coga)
context("two variables case coga")

test_that("one alpha equals to 0", {
    expect_equal(dcoga2dim(3, 0, 5, 1, 2),
                 dgamma(3, 5, 2))
    expect_equal(dcoga2dim(3, 5, 0, 1, 2),
                 dgamma(3, 5, 1))
    expect_equal(dcoga2dim(3, 0, 5, 2, 1),
                 dgamma(3, 5, 1))
    expect_equal(dcoga2dim(3, 5, 0, 2, 1),
                 dgamma(3, 5, 2))
    expect_equal(pcoga2dim(3, 0, 5, 1, 2),
                 pgamma(3, 5, 2))
    expect_equal(pcoga2dim(3, 5, 0, 1, 2),
                 pgamma(3, 5, 1))
    expect_equal(pcoga2dim(3, 0, 5, 2, 1),
                 pgamma(3, 5, 1))
    expect_equal(pcoga2dim(3, 5, 0, 2, 1),
                 pgamma(3, 5, 2))
})

test_that("no alpha equals to 0", {
    expect_equal(dcoga2dim(3, 3, 2, 4, 6),
                 dcoga2dim(3, 2, 3, 6, 4))
    expect_equal(pcoga2dim(3, 3, 2, 4, 6),
                 pcoga2dim(3, 2, 3, 6, 4))
})

test_that("diff two alpha equal to 0", {
    expect_equal(pcoga2dim_diff_shape(3, 0, 0, 4, 6),
                 1 - pgamma(3, 1, 4))
    expect_equal(pcoga2dim_diff_shape(3, 0, 0, 6, 4),
                 1 - pgamma(3, 1, 6))
})

test_that("diff one alpha equal to 0", {
    expect_equal(pcoga2dim_diff_shape(3, 1, 0, 4, 6),
                 pgamma(3, 1, 4) - pgamma(3, 2, 4))
    expect_equal(pcoga2dim_diff_shape(3, 1, 0, 6, 4),
                 pgamma(3, 1, 6) - pgamma(3, 2, 6))
    expect_equal(pcoga2dim_diff_shape(3, 0, 1, 6, 4),
                 pgamma(3, 1, 4) - pcoga2dim(3, 1, 1, 6, 4))
    expect_equal(pcoga2dim_diff_shape(3, 0, 1, 4, 6),
                 pgamma(3, 1, 6) - pcoga2dim(3, 1, 1, 4, 6))
})

test_that("diff no alpha equal to 0", {
    expect_equal(pcoga2dim_diff_shape(3, 1, 2, 4, 6),
                 pcoga2dim(3, 1, 2, 4, 6) - pcoga2dim(3, 2, 2, 4, 6))
    expect_equal(pcoga2dim_diff_shape(3, 1, 2, 6, 4),
                 pcoga2dim(3, 1, 2, 6, 4) - pcoga2dim(3, 2, 2, 6, 4))
})
