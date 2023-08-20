pkgname <- "coga"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "coga-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('coga')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("dcoga")
### * dcoga

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: dcoga
### Title: Convolution of Gamma Distributions (Exact Method).
### Aliases: dcoga pcoga rcoga

### ** Examples

## Example 1: Correctness check
set.seed(123)
## do grid
y <- rcoga(100000, c(3,4,5), c(2,3,4))
grid <- seq(0, 15, length.out=100)
## calculate pdf and cdf
pdf <- dcoga(grid, shape=c(3,4,5), rate=c(2,3,4))
cdf <- pcoga(grid, shape=c(3,4,5), rate=c(2,3,4))

## plot pdf
plot(density(y), col="blue")
lines(grid, pdf, col="red")

## plot cdf
plot(ecdf(y), col="blue")
lines(grid, cdf, col="red")

## Example 2: Show parameter recycling
## these pairs give us the same results
dcoga(1:5, c(1, 2), c(1, 3, 4, 2, 5))
dcoga(1:5, c(1, 2, 1, 2, 1), c(1, 3, 4, 2, 5))

pcoga(1:5, c(1, 3, 5, 2, 2), c(3, 5))
pcoga(1:5, c(1, 3, 5, 2, 2), c(3, 5, 3, 5, 3))




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("dcoga", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("dcoga2dim")
### * dcoga2dim

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: dcoga2dim
### Title: Convolution of Two Gamma Distributions (Exact Method).
### Aliases: dcoga2dim pcoga2dim

### ** Examples

## Example 1: Correctness check
set.seed(123)
## do grid
y <- rcoga(100000, c(3,4), c(2,3))
grid <- seq(0, 15, length.out=100)
## calculate pdf and cdf
pdf <- dcoga2dim(grid, 3, 4, 2, 3)
cdf <- pcoga2dim(grid, 3, 4, 2, 3)

## plot pdf
plot(density(y), col="blue")
lines(grid, pdf, col="red")

## plot cdf
plot(ecdf(y), col="blue")
lines(grid, cdf, col="red")

## Example 2: Comparison with `dcoga` and `pcoga`
## these pairs give us the same results
dcoga(1:5, c(1, 2), c(3, 4))
dcoga2dim(1:5, 1, 2, 3, 4)

pcoga(1:5, c(1, 3), c(3, 5))
pcoga2dim(1:5, 1, 3, 3, 5)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("dcoga2dim", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("dcoga_approx")
### * dcoga_approx

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: dcoga_approx
### Title: Convolution of Gamma distribuitons (Approximation Method)
### Aliases: dcoga_approx pcoga_approx

### ** Examples

## Example 1: Correctness check
set.seed(123)
## do grid
y <- rcoga(100000, c(3,4,5), c(2,3,4))
grid <- seq(0, 15, length.out=100)
## calculate pdf and cdf
pdf <- dcoga_approx(grid, shape=c(3,4,5), rate=c(2,3,4))
cdf <- pcoga_approx(grid, shape=c(3,4,5), rate=c(2,3,4))

## plot pdf
plot(density(y), col="blue")
lines(grid, pdf, col="red")

## plot cdf
plot(ecdf(y), col="blue")
lines(grid, cdf, col="red")

## Example 2: Show parameter recycling
## these pairs give us the same results
dcoga_approx(1:5, c(1, 2), c(1, 3, 4, 2, 5))
dcoga_approx(1:5, c(1, 2, 1, 2, 1), c(1, 3, 4, 2, 5))

pcoga_approx(1:5, c(1, 3, 5, 2, 2), c(3, 5))
pcoga_approx(1:5, c(1, 3, 5, 2, 2), c(3, 5, 3, 5, 3))




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("dcoga_approx", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("pcoga2dim_diff_shape")
### * pcoga2dim_diff_shape

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: pcoga2dim_diff_shape
### Title: Recurrence Identity of Shape Parameter for 'pcoga2dim'
### Aliases: pcoga2dim_diff_shape

### ** Examples

## these pairs give us the same results
pcoga2dim_diff_shape(3,2,4,5,4)
pcoga2dim(3,2,4,5,4) - pcoga2dim(3,3,4,5,4)

pcoga2dim_diff_shape(3,0,4,3,5)
pgamma(3,4,5) - pcoga2dim(3,1,4,3,5)

pcoga2dim_diff_shape(3,6,0,5,4)
pgamma(3,6,5) - pgamma(3,7,5)

pcoga2dim_diff_shape(3,0,0,4,5)
1 - pgamma(3,1,4)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("pcoga2dim_diff_shape", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
