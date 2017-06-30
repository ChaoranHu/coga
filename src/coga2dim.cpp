// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::depends(RcppGSL)]]
#include <Rcpp.h>
#include <RcppGSL.h>
#include <gsl/gsl_sf_hyperg.h>

using namespace Rcpp;

// [[Rcpp::export]]
double dcoga2dim_nv(double x, double shape1, double shape2,
		       double rate1, double rate2) {
  // transfer rate to scale
  double beta1 = 1 / rate1;
  double beta2 = 1 / rate2;
  /*
  // handle one shape is 0
  if (shape1 == 0) return R::dgamma(x, shape2, beta2, 0);
  if (shape2 == 0) return R::dgamma(x, shape1, beta1, 0);
  */
  gsl_set_error_handler_off();
  double lgam = shape1 + shape2;
  double parx = (1/beta1 - 1/beta2) * x;
  double result = pow(x, lgam - 1);
  result *= gsl_sf_hyperg_1F1(shape2, lgam, parx);
  result /= pow(beta1, shape1) * pow(beta2, shape2);
  result /= exp(R::lgammafn(lgam) + (x / beta1));
  return result;
}

//' Convolution of Two Gamma Distributions.
//'
//' Density, and distribution function of convolution of two gamma
//' distributions is a special situation of convolution of gamma
//' distributions. Compare to the general situation, the speed of code
//' is much faster. The algorithm of these two functions comes from
//' Mathai, A.M. (1982).
//'
//' @param x Quantiles.
//' @param shape1,shape2 Shape parameters of the first and second gamma
//' distributions, all shape parameters >= 0, at least one shape parameter > 0.
//' @param rate1,rate2 Rate parameters of the first and second gamma
//' distributions, all rate parameters > 0.
//'
//' @references
//' Mathai, A.M.: Storage capacity of a dam with gamma type inputs.
//' Ann. Inst. Statist.Math. 34, 591-597 (1982)
//'
//' @examples
//' ## do grid
//' y <- rcoga(100000, c(3,4), c(2,3))
//' grid <- seq(0, 15, length.out=100)
//' ## calculate pdf and cdf
//' pdf <- dcoga2dim(grid, 3, 4, 2, 3)
//' cdf <- pcoga2dim(grid, 3, 4, 2, 3)
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
NumericVector dcoga2dim(NumericVector x, double shape1, double shape2,
			double rate1, double rate2) {
  if (rate1 <= 0 || rate2 <= 0) stop("all rate should be larger than 0");
  if (shape1 < 0 || shape2 < 0) stop("all shape should be larger than or equal to 0");
  if (shape1 == 0 && shape2 == 0) stop("at least one shape should be larger than 0");

  int n = x.size();
  NumericVector out(n);
  for (int i = 0; i < n; ++i) {
    out[i] = dcoga2dim_nv(x[i], shape1, shape2, rate1, rate2);
  }
  return out;
}


// [[Rcpp::export]]
double pcoga2dim_nv(double x, double shape1, double shape2,
		 double rate1, double rate2) {
  // transfer rate to scale
  double beta1 = 1 / rate1;
  double beta2 = 1 / rate2;
  /*
  // handle one shape is 0
  if (shape1 == 0) return R::pgamma(x, shape2, beta2, 1, 0);
  if (shape2 == 0) return R::pgamma(x, shape1, beta1, 1, 0);
  */
  // make convergence faster
  double lgam = shape1 + shape2;
  double star = 1 - (beta1 / beta2);
  
  double cartB = 1.;
  double cartD = R::pgamma(x/beta1, lgam, 1, 1, 0);
  double cart = cartD;
  double result = 0.;
  int r = 0;

  while (TRUE) {
    if (cart == R_PosInf || R_IsNaN(cart)) {
      warning("Inf or NaN happened, not converge!");
      break;
    }
    result += cart;
    if (cart == 0) break;
    cartB *= star * (shape2 + r) / (r + 1);
    r++;
    cartD = R::pgamma(x/beta1, lgam + r, 1, 1, 0);
    cart = cartB * cartD;
  }
  return result * pow(beta1/beta2, shape2);
}

//' @rdname dcoga2dim
//' @export
// [[Rcpp::export]]
NumericVector pcoga2dim(NumericVector x, double shape1, double shape2,
			double rate1, double rate2) {
  if (rate1 <= 0 || rate2 <= 0) stop("all rate should be larger than 0");
  if (shape1 < 0 || shape2 < 0) stop("all shape should be larger than or equal to 0");

  int n = x.size();
  NumericVector out(n);
  for (int i = 0; i < n; ++i) {
    out[i] = pcoga2dim_nv(x[i], shape1, shape2, rate1, rate2);
  }
  return out;
}

//' Recurrence Identity of Shape Parameter for Distribution Function of coga2dim 
//'
//' The difference of distribution functions of convolution of two gamma
//' distributions between consecutive neighbors of shape parameter. This
//' function can return the value of pcoga2dim(x, shape1, shape2, rate1, rate2)
//' - pcoga2dim(x, shape1 + 1, shape2, rate1, rate2) with higher efficiency
//' (this function is much more faster than call pcoga2dim).
//'
//' @param x Quantiles.
//' @param shape1,shape2 Shape parameters of the first and second gamma
//' distributions, all shape parameters >= 0.
//' @param rate1,rate2 Rate parameters of the first and second gamma
//' distributions, all rate parameters > 0.
//'
//' @examples
//' pcoga2dim_diff_shape(3,2,4,5,4)
//' pcoga2dim(3,2,4,5,4) - pcoga2dim(3,3,4,5,4)
//'
//' pcoga2dim_diff_shape(3,0,4,3,5)
//' pgamma(3,4,5) - pcoga2dim(3,1,4,3,5)
//'
//' pcoga2dim_diff_shape(3,6,0,5,4)
//' pgamma(3,6,5) - pgamma(3,7,5)
//'
//' pcoga2dim_diff_shape(3,0,0,4,5)
//' 1 - pgamma(3,1,4)
//'
//' @author Chaoran Hu
//'
//' @export
// [[Rcpp::export]]
double pcoga2dim_diff_shape (double x,
			     double shape1, double shape2,
			     double rate1, double rate2) {
  /*
  // handle special situations
  if (shape1 == 0 && shape2 == 0) {
    return 1 - pcoga2dim(x, 1, 0, rate1, rate2);
  }
  if (shape1 == 0 && shape2 != 0) {
    return pcoga2dim(x, 0, shape2, rate1, rate2) - pcoga2dim(x, 1, shape2, rate1, rate2);
  }
  if (shape1 != 0 && shape2 == 0) {
    return pcoga2dim(x, shape1, 0, rate1, rate2) - pcoga2dim(x, shape1 + 1, 0, rate1, rate2);
  }
  */
  
  gsl_set_error_handler_off();
  double result = pow(rate1, shape1) * pow(rate2, shape2);
  double lgam = shape1 + shape2 + 1;
  double parx = x * (rate1 - rate2);
  result *= pow(x, lgam - 1);
  result /= exp(R::lgammafn(lgam) + (x * rate1));
  result *= gsl_sf_hyperg_1F1(shape2, lgam, parx);
  return result;
}
