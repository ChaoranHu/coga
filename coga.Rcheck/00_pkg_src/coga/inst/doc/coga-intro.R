## ---- include=FALSE------------------------------------------------------
library(coga)
if (!requireNamespace("microbenchmark", quietly = TRUE)) {
  stop("Pkg microbenchmark needed for this vignette to work. Please install it.",
    call. = FALSE)
}

## ---- echo=TRUE, fig.width = 7, fig.height = 6---------------------------
y <- rcoga(1000000, c(3,4), c(2,3))
grid <- seq(0, 8, length.out=1000)
pdf <- dcoga(grid, shape=c(3, 4), rate=c(2, 3))
 
plot(density(y), col="blue")
lines(grid, pdf, col="red")

## ---- echo=TRUE, fig.width = 7, fig.height = 6---------------------------
y <- rcoga(1000000, c(3,4), c(2,3))
grid <- seq(0, 8, length.out=1000)
cdf <- pcoga(grid, shape=c(3, 4), rate=c(2, 3))

plot(ecdf(y), col="blue")
lines(grid, cdf, col="red")

## ---- echo=TRUE----------------------------------------------------------
grid <- seq(0, 15, length.out=10)

microbenchmark::microbenchmark(
    dcoga(grid, shape=c(3,4,5), rate=c(2,3,4)),
    coga:::dcoga.R(grid, shape=c(3,4,5), rate=c(2,3,4)),
    pcoga(grid, shape=c(3,4,5), rate=c(2,3,4)),
    coga:::pcoga.R(grid, shape=c(3,4,5), rate=c(2,3,4))
)

## ---- echo=TRUE----------------------------------------------------------
grid <- seq(0, 15, length.out=100)

microbenchmark::microbenchmark(
    dcoga(grid, shape=c(3,4), rate=c(2,3)),
    dcoga2dim(grid, 3, 4, 2, 3),
    pcoga(grid, shape=c(3,4), rate=c(2,3)),
    pcoga2dim(grid, 3, 4, 2, 3))

