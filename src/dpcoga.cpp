// [[Rcpp::interfaces(r, cpp)]]

#include <Rcpp.h>
using namespace Rcpp;

double get_c(NumericVector alpha, NumericVector beta) {
  double beta1 = min(beta);
  int n = alpha.size();
  double out = 1;
  for(int i = 0; i < n; ++i) {
    out *= pow(beta1 / beta[i], alpha[i]);
  }
  return out;
}

double get_rho(NumericVector alpha) {
  int n = alpha.size();
  double out = 0;
  for(int i = 0; i < n; ++i) {
    out += alpha[i];
  }
  return out;
}

// get k-th little gamma, k start from 1,2,3,...
double get_lgam(NumericVector alpha, NumericVector beta, int k) {
  int n = alpha.size();
  double beta1 = min(beta);
  double out = 0;
  for(int i = 0; i < n; ++i) {
    out += alpha[i] * pow((1 - (beta1 / beta[i])), k) / k;
  }
  return out;
}

// get next delta by given delta and lgam
double get_next_delta(NumericVector delta, NumericVector lgam) {
  int n = lgam.size();
  double out = 0;
  for(int i = 0; i < n; ++i) {
    out += lgam[i] * delta[n-1-i] * (i + 1);
  }
  return out / n;
}

/* old recycling
NumericVector makeup(NumericVector x, NumericVector y) {
  // make up x to y
  double xvalue = x[0];
  NumericVector xx(y.size(), xvalue);
  return xx;
}
*/

// do recycling x to follw y's size
NumericVector recycling(NumericVector x, NumericVector y) {
  // recycling x to y
  int nx = x.size();
  int ny = y.size();
  int mx = x.size();
  while(TRUE) {
    for(int i = 0; i < nx; ++i) {
      x.push_back(x[i]);
      mx = x.size();
      if (mx == ny) break;
    }
    if (mx == ny) break;
  }
  return x;
}

/********************************************************************
****************** Density of convolution of gamma ******************
*********************************************************************/

// non vectorize version
double dcoga_nv(double x,  NumericVector alpha, NumericVector beta) {
  if (x <= 0) return 0;
  double beta1 = min(beta);
  NumericVector delta  = NumericVector::create(1);
  NumericVector lgam   = NumericVector::create(get_lgam(alpha, beta, 1));
  double rho = get_rho(alpha);

  int k = 0;
  double out = 0;
  double step = 0;

  while(TRUE) {
    step = delta[k] * R::dgamma(x, rho + k, beta1, 0);
    if (step == R_PosInf || R_IsNaN(step)) {
      warning("Inf or NaN happened, not converge!");
      break;
    }
    out += step;
    if (step == 0) break;
    delta.push_back(get_next_delta(delta, lgam));
    k++;
    lgam.push_back(get_lgam(alpha, beta, k + 1));
  }

  out *= get_c(alpha, beta);
  return out;
}

//' Convolution of Gamma Distributions.
//'
//' Density, distribution function, and random generation for convolution of gamma
//' distributions. The distribution of the convolution of independent Gamma random
//' variables with different parameters
//' is \eqn{Y = X_{1} + ... + X_{n}}, where \eqn{X_{i}, i = 1, ..., n},
//' are independent Gamma distributions with parameters shapes and rates.
//' The density function and distribution function can be calculated, according to the
//' formulas from Moschopoulos, Peter G. (1985).
//'
//' @param x Quantiles.
//' @param n Number of sample.
//' @param shape Numerical vector of shape parameters of every gamma distributions,
//' all shape parameters >= 0, at least one shape parameter > 0.
//' @param rate Numerical vector of rate parameters of every gamma distributions,
//' all rate parameters > 0.
//'
//' @references
//' Moschopoulos, Peter G. "The distribution of the sum of independent
//' gamma random variables." Annals of the Institute of
//' Statistical Mathematics 37.1 (1985): 541-544.
//' @examples
//' set.seed(123)
//' ## do grid
//' y <- rcoga(100000, c(3,4,5), c(2,3,4))
//' grid <- seq(0, 15, length.out=100)
//' ## calculate pdf and cdf
//' pdf <- dcoga(grid, shape=c(3,4,5), rate=c(2,3,4))
//' cdf <- pcoga(grid, shape=c(3,4,5), rate=c(2,3,4))
//'
//' ## plot pdf
//' plot(density(y), col="blue")
//' lines(grid, pdf, col="red")
//'
//' ## plot cdf
//' plot(ecdf(y), col="blue")
//' lines(grid, cdf, col="red")
//'
//' @author Chaoran Hu
//'
//' @export
// [[Rcpp::export]]
NumericVector dcoga(NumericVector x, NumericVector shape, NumericVector rate) {
  // input check
  // handle recycle
  if (shape.size() != rate.size()) {
    if (shape.size() < rate.size()) {
      if (rate.size() % shape.size() != 0) warning("number of rate is not a multiple of shape.");
      shape = recycling(shape, rate);
    } else {
      if (shape.size() % rate.size() != 0) warning("number of shape is not a multiple of rate.");
      rate = recycling(rate, shape);
    }
  }

  if (is_true(any(shape < 0))) stop("all shape should be larger than or equal to 0, with at least one non-zero.");
  if (is_true(any(rate <= 0))) stop("all rate should be larger than 0.");
  if (is_true(all(shape == 0))) stop("all shape should be larger than or equal to 0, with at least one non-zero.");

  // transfer from shape rate to alpha beta
  NumericVector alpha = shape;
  NumericVector beta  = 1 / rate;

  // remove 0
  beta  = beta[alpha > 0];
  alpha = alpha[alpha > 0];

  // vectorize
  int n = x.size();
  NumericVector out(n);
  for(int i = 0; i < n; ++i) {
    out[i] = dcoga_nv(x[i], alpha, beta);
  }
  return out;
}





/*************************************************************************
****************** Distribution of convolution of gamma ******************
*************************************************************************/

// non vectorize version
double pcoga_nv(double x, NumericVector alpha, NumericVector beta) {
  if (x <= 0) return 0;
  double beta1 = min(beta);
  NumericVector delta  = NumericVector::create(1);
  NumericVector lgam   = NumericVector::create(get_lgam(alpha, beta, 1));
  double rho = get_rho(alpha);

  int k = 0;
  double out = 0;
  double step = 0;

  while(TRUE) {
    step = delta[k] * R::pgamma(x / beta1, rho + k, 1, 1, 0);
    if (step == R_PosInf || R_IsNaN(step)) {
      warning("Inf or NaN happened, not converge!");
      break;
    }
    out += step;
    if (step == 0) break;
    delta.push_back(get_next_delta(delta, lgam));
    k++;
    lgam.push_back(get_lgam(alpha, beta, k + 1));
  }

  out *= get_c(alpha, beta);
  return out;
}

//' @rdname dcoga
//' @export
// [[Rcpp::export]]
NumericVector pcoga(NumericVector x, NumericVector shape, NumericVector rate) {
  // input check
  // handle recycle
  if (shape.size() != rate.size()) {
    if (shape.size() < rate.size()) {
      if (rate.size() % shape.size() != 0) warning("number of rate is not a multiple of shape.");
      shape = recycling(shape, rate);
    } else {
      if (shape.size() % rate.size() != 0) warning("number of shape is not a multiple of rate.");
      rate = recycling(rate, shape);
    }
  }
  
  if (is_true(any(shape < 0))) stop("all shape should be larger than or equal to 0, with at least one non-zero.");
  if (is_true(any(rate <= 0))) stop("all rate should be larger than 0.");
  if (is_true(all(shape == 0))) stop("all shape should be larger than or equal to 0, with at least one non-zero.");

  // transfer from shape rate to alpha beta
  NumericVector alpha = shape;
  NumericVector beta  = 1 / rate;

  // remove 0
  beta  = beta[alpha > 0];
  alpha = alpha[alpha > 0];

  // vectorize
  int n = x.size();
  NumericVector out(n);
  for(int i = 0; i < n; ++i) {
    out[i] = pcoga_nv(x[i], alpha, beta);
  }
  return out;
}
