## this R script is only for research purpose
## functions here should not be exported

## TODO:
## handle replicated scale/rate parameters input,
## like c(2,3,3,5,1)
dcoga_salvo_source <- function(x, shape, scale){
    dim <- length(shape) - 1
    integrand <- function(u){
        salvo_integrand(u, x, shape, scale)
    }

    cartA <- cubature::hcubature(integrand,
                                 lowerLimit = rep(0, dim),
                                 upperLimit = rep(1, dim))$integral

    cartB <- salvo_multi_comp(x, shape, scale)

    cartA * cartB
}

dcoga_salvo <- function(x, shape, rate){
    scale <- 1/rate
    min_scale <- min(scale)
    minind_scale  <- which.min(scale)
    min_shape <- shape[minind_scale]
    scale <- c(scale[-minind_scale], min_scale)
    shape <- c(shape[-minind_scale], min_shape)

    result <- rep(NA, length(x))
    for (i in 1:length(x)){
        result[i] <- dcoga_salvo_source(x[i], shape, scale)
    }

    result
}

