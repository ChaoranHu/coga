############### R version ###############################################
## calculate the pdf of the sum of gamma distributions, R version
dcoga_nvec <- function(x, shape, rate, period=50) {
    stopifnot(length(shape) == length(rate))
    beta <- 1/rate
    alpha <- shape
    ## check input
    stopifnot(alpha >= 0, rate > 0)
    if (prod(alpha == 0)) stop("At least one alpha should be larger than 0")
    ## treat alpha == 0
    if (!prod(alpha > 0)) {
        alpha.ind <- which(alpha == 0)
        alpha <- alpha[-alpha.ind]
        beta <- beta[-alpha.ind]
    }
    stopifnot(period >= 1, round(period) == period)

    if (x <= 0) return(0)

    beta1 <- min(beta)
    rho <- sum(alpha)
    C <- prod((beta1 / beta)^alpha)
    delta <- 1
    b <- max(1 - beta1 / beta)

    ## generate the k-th gam
    gam.k <- function(k) {
        sum((alpha * (1 - beta1 / beta)^k) / k)
    }

    ## calculate the next delta
    ## parameter delta here is vector
    ## parameter gam here is vector
    nextDelta <- function(delta, gam) {
        n <- length(gam)
        (1 / n) * sum(gam * (1:n) * rev(delta))
    }

    ## generate the upcoming n delta
    ## init.delta is from 0 to m
    ## init.gam is from 1 to m
    ## return delta from 0 to m+n
    ## return gam from 1 to m+n
    getDelta <- function(n, init.delta, init.gam) {
        delta <- c(init.delta, numeric(n))
        gam   <- c(init.gam, numeric(n))
        
        for (i in (seq_len(n) + length(init.gam))) {
            gam[i] <- gam.k(i)
        }
        for (i in (seq_len(n) + length(init.gam))) {
            delta[i + 1] <- nextDelta(delta=delta[1:i], gam=gam[1:i])
        }

        list(delta=delta, gam=gam)
    }

    ## calculate the k-th pdf
    ## k starts form 0
    pdfk <- function(k, delta) {
        C * delta[k + 1] * x^(rho + k - 1) * exp(-x / beta1) / (beta1^(rho + k) * gamma(rho + k))
    }

    ## delete NaN in a vector
    noNaN <- function(x) {x[!is.nan(x)]}

    
    ## start calculate cdf and determine stop times stp
    ## the first stp+1 terms will be used such that
    ## the desired accuracy is attained
    gam <- NULL
    pdf <- pdfk(k=0, delta=delta)
    k <- 0
    while (TRUE) {
        delgam <- getDelta(period, init.delta=delta, init.gam=gam)
        delta <- delgam$delta
        gam <- delgam$gam

        pdf.vec <- suppressWarnings(pdfk(1:period + period*k, delta=delta))
        pdf.vec <- noNaN(pdf.vec)
        pdf <- pdf + sum(pdf.vec)
        ind <- pdf.vec[length(pdf.vec)] == 0
        if(ind) break
        k <- k + 1
    }

    pdf
}

## vectorize
dcoga.R <- Vectorize(dcoga_nvec, vectorize.args="x")



## ------------------------------------------------------------------------------------



### calculate the cdf of the sum of gamma distributions, R version
pcoga_nvec <- function(x, shape, rate, period=50) {
    stopifnot(length(shape) == length(rate))
    beta <- 1/rate
    alpha <- shape
    ## check input
    stopifnot(alpha >= 0, rate > 0)
    if (prod(alpha == 0)) stop("At least one alpha should be larger than 0")
    ## treat alpha == 0
    if (!prod(alpha > 0)) {
        alpha.ind <- which(alpha == 0)
        alpha <- alpha[-alpha.ind]
        beta <- beta[-alpha.ind]
    }
    stopifnot(period >= 1, round(period) == period)

    if (x <= 0) return(0)

    beta1 <- min(beta)
    rho <- sum(alpha)
    C <- prod((beta1 / beta)^alpha)
    delta <- 1
    b <- max(1 - beta1 / beta)

    ## generate the k-th gam
    gam.k <- function(k) {
        sum((alpha * (1 - beta1 / beta)^k) / k)
    }

    ## calculate the next delta
    ## parameter delta here is vector
    ## parameter gam here is vector
    nextDelta <- function(delta, gam) {
        n <- length(gam)
        (1 / n) * sum(gam * (1:n) * rev(delta))
    }

    ## generate the upcoming n delta
    ## init.delta is from 0 to m
    ## init.gam is from 1 to m
    ## return delta from 0 to m+n
    ## return gam from 1 to m+n
    getDelta <- function(n, init.delta, init.gam) {
        delta <- c(init.delta, numeric(n))
        gam   <- c(init.gam, numeric(n))
        
        for (i in (seq_len(n) + length(init.gam))) {
            gam[i] <- gam.k(i)
        }
        for (i in (seq_len(n) + length(init.gam))) {
            delta[i + 1] <- nextDelta(delta=delta[1:i], gam=gam[1:i])
        }

        list(delta=delta, gam=gam)
    }

    ## calculate the k-th cdf
    ## k starts form 0
    cdfk <- function(k, delta) {
        C * delta[k + 1] * stats::pgamma(x / beta1, rho + k)
    }

    ## delete NaN in a vector
    noNaN <- function(x) {x[!is.nan(x)]}

    
    ## start calculate cdf and determine stop times stp
    ## the first stp+1 terms will be used such that
    ## the desired accuracy is attained
    gam <- NULL
    cdf <- cdfk(k=0, delta=delta)
    k <- 0
    while (TRUE) {
        delgam <- getDelta(period, init.delta=delta, init.gam=gam)
        delta <- delgam$delta
        gam <- delgam$gam

        cdf.vec <- suppressWarnings(cdfk(1:period + period*k, delta=delta))
        cdf.vec <- noNaN(cdf.vec)
        cdf <- cdf + sum(cdf.vec)
        ind <- cdf.vec[length(cdf.vec)] == 0
        if(ind) break
        k <- k + 1
    }

    cdf
}

## vectorize
pcoga.R <- Vectorize(pcoga_nvec, vectorize.args="x")




## ------------------------------------------------------------------------------------

##' @rdname dcoga
##' @export
rcoga <- function(n, shape, rate) {
    if (length(shape) != length(rate)) {
        param.save <- cbind(shape, rate)
        shape <- param.save[,1]
        rate <- param.save[,2]
    }
    
    stopifnot(shape >= 0, rate > 0)
    if (prod(shape == 0)) stop("At least one shape parameter should be larger than 0")
    dim <- length(shape)
    result <- matrix(numeric(n * dim), nrow=dim, ncol=n)
    for(i in 1:dim) {
        result[i, ] <- stats::rgamma(n, shape=shape[i], rate=rate[i])
    }
    apply(result, 2, sum)
}
