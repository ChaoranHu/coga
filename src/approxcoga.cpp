// [[Rcpp::interfaces(r, cpp)]]
#include <Rcpp.h>

using namespace Rcpp;


// [[Rcpp::export]]
double get_mu(NumericVector alpha, NumericVector beta) {
  double beta1 = min(beta);
  double result = 0;
  int n = alpha.size();
  
  for(int i = 0; i < n; ++i) {
    result += (beta[i] / beta1) * (1 - (beta1 / beta[i])) * alpha[i];
  }

  return result;
}


// [[Rcpp::export]]
double get_mu2(NumericVector alpha, NumericVector beta) {
  double beta1 = min(beta);
  double result = 0;
  int n = alpha.size();
  
  for(int i = 0; i < n; ++i) {
    result += pow(beta[i] / beta1, 2) * (1 - (beta1 / beta[i])) * alpha[i];
  }

  return result;
}

// [[Rcpp::export]]
double get_mu3(NumericVector alpha, NumericVector beta) {
  double beta1 = min(beta);
  double result = 0;
  int n = alpha.size();
  
  for(int i = 0; i < n; ++i) {
    result += pow(beta[i] / beta1, 3) * (1 - (beta1 / beta[i]))
      * (2 - beta1 / beta[i]) * alpha[i];
  }

  return result;
}

// [[Rcpp::export]]
double get_A(double mu, double mu2, double mu3) {
  double result = pow(mu * mu3 - 3 * pow(mu2, 2), 2) - 2;
  result /= mu * pow(mu2, 3);
  return result;
}

// [[Rcpp::export]]
double get_p_GNB(double A) {
  double result = 1 - (A / 2) + pow(pow(A, 2) / 4 - 1, 0.5);
  return result;
}

// [[Rcpp::export]]
double get_b_GNB(double p, double mu, double mu2) {
  double cart = mu * (1 - p) / mu2;
  double result = (1 - pow(cart, 0.5)) / p;
  return result;
}

// [[Rcpp::export]]
double get_r_GNB(double mu, double p, double b) {
  double result = mu * (1 - p * b) / p;
  return result;
}

// [[Rcpp::export]]
double get_p_NB(double mu, double mu2) {
  double result = 1 - mu / mu2;
  return result;
}

// [[Rcpp::export]]
double get_r_NB(double p, double mu) {
  double result = (1 - p) * mu / p;
  return result;
}

// [[Rcpp::export]]
double GNB(double k, double r, double p, double b, double mu) {
  // input check
  if (p < 0 || p > 1 || (p * b) > 1 || (p * b) < -1) warning("out of control");
  //if (b < 1 && b > 0) stop("GNB do not exit");
  if(k >= mu && (r + b * mu) < 0) return 0;

  double result = r / (r  + b * k) * R::choose(r + b * k, k);
  result *= pow(p, k) * pow(1 - p, r + b * k - k);
  return result;
}

// [[Rcpp::export]]
double NB(double k, double r, double p) {
  double result = r / (r + k) * R::choose(r + k, k);
  result *= pow(p, k) * pow(1 - p, r);
  return result;
}

double get_rho_approx(NumericVector alpha) {
  int n = alpha.size();
  double out = 0;
  for(int i = 0; i < n; ++i) {
    out += alpha[i];
  }
  return out;
}

// [[Rcpp::export]]
double dcoga_approx_nv(double x, NumericVector alpha, NumericVector beta) {
  double mu = get_mu(alpha, beta);
  double mu2 = get_mu2(alpha, beta);
  double mu3 = get_mu3(alpha, beta);
  double valueA = get_A(mu, mu2, mu3);
  double rho = get_rho_approx(alpha);
  double beta1 = min(beta);
  // double cart = exp(- x / beta1);
  double step = 0;

  double result = 0;
  int k = 0;

  if (valueA < 2) {
    double valuep = get_p_NB(mu, mu2);
    double valuer = get_r_NB(valuep, mu);
    while(TRUE) {
      step = NB(k, valuer, valuep);
      step *= R::dgamma(x, rho + k, beta1, 0);
      // step /= pow(beta1, rho + k);
      // step *= pow(x, rho + k - 1);
      // step /= exp(R::lgammafn(rho + k));
      if(step == R_PosInf || R_IsNaN(step)) {
	warning("Inf or NaN happened, not converge!");
	break;
      }
      if(step == 0) break;
      result += step;
      k++;
    }
  } else {
    double valuep = get_p_GNB(valueA);
    double valueb = get_b_GNB(valuep, mu, mu2);
    double valuer = get_r_GNB(mu, valuep, valueb);
    while(TRUE) {
      step = GNB(k, valuer, valuep, valueb, mu);
      step *= R::dgamma(x, rho + k, beta1, 0);
      // step /= pow(beta1, rho + k);
      // step *= pow(x, rho + k - 1);
      // step /= exp(R::lgammafn(rho + k));
      if(step == R_PosInf || R_IsNaN(step)) {
	warning("Inf or NaN happened, not converge!");
	break;
      }
      if(step == 0) break;
      result += step;
      k++;
    }
  }

  return result;
}

// do recycling x to follw y's size
// the same function as recycling with diff name
NumericVector recycling2(NumericVector x, NumericVector y) {
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



//' Convolution of Gamma distribuitons with Approximation Method
//'
//' Density and distribution function of convolution of gamma distributions
//' are calculated based on approximation method from Barnabani(2017), which
//' gives us the benefit of faster calculation speed under three or more
//' variables case.
//'
//' @param x Quantiles.
//' @param shape Numerical vector of shape parameters.
//' @param rate Numerical vector of rate parameters.
//'
//' @references
//' Barnabani, M. (2017). An approximation to the convolution of gamma
//' distributions. Communications in Statistics - Simulation and Computation
//' 46(1), 331-343.
//' @examples
//' dcoga_approx(1:10, c(1, 2, 3), c(2, 3, 4))
//' pcoga_approx(1:10, c(1, 2, 3), c(2, 3, 4))
//'
//' @author Chaoran Hu
//'
//' @export
// [[Rcpp::export]]
NumericVector dcoga_approx(NumericVector x,
			   NumericVector shape,
			   NumericVector rate) {
  // input check
  if (is_true(any(rate <= 0))) stop("all rate should be larger than 0.");
  if (is_true(any(shape < 0))) stop("all shape should be larger than or equal to 0, with at least three non-zero.");
  // handle recycle
  if (shape.size() != rate.size()) {
    if (shape.size() < rate.size()) {
      if (rate.size() % shape.size() != 0) warning("number of rate is not a multiple of shape.");
      shape = recycling2(shape, rate);
    } else {
      if (shape.size() % rate.size() != 0) warning("number of shape is not a multiple of rate.");
      rate = recycling2(rate, shape);
    }
  }
  rate = rate[shape > 0];
  shape = shape[shape > 0];
  if (shape.size() < 3) stop("all shape should be larger than or equal to 0, with at least three non-zero.");
  // input check

  NumericVector beta = 1 / rate;
  int n = x.size();
  NumericVector result(n);
  for (int i = 0; i < n; ++i) {
    result[i] = dcoga_approx_nv(x[i], shape, beta);
  }
  return result;
}


////////////////////////////////////////////


// [[Rcpp::export]]
double pcoga_approx_nv(double x, NumericVector alpha, NumericVector beta) {
  double mu = get_mu(alpha, beta);
  double mu2 = get_mu2(alpha, beta);
  double mu3 = get_mu3(alpha, beta);
  double valueA = get_A(mu, mu2, mu3);
  double rho = get_rho_approx(alpha);
  double beta1 = min(beta);

  double step = 0;
  double result = 0;
  int k = 0;

  if (valueA < 2) {
    double valuep = get_p_NB(mu, mu2);
    double valuer = get_r_NB(valuep, mu);
    while(TRUE) {
      step = NB(k, valuer, valuep);
      step *= R::pgamma(x / beta1, rho + k, 1, 1, 0);
      if(step == R_PosInf || R_IsNaN(step)) {
	warning("Inf or NaN happened, not converge!");
	break;
      }
      if(step == 0) break;
      result += step;
      k++;
    }
  } else {
    double valuep = get_p_GNB(valueA);
    double valueb = get_b_GNB(valuep, mu, mu2);
    double valuer = get_r_GNB(mu, valuep, valueb);
    while(TRUE) {
      step = GNB(k, valuer, valuep, valueb, mu);
      step *= R::pgamma(x / beta1, rho + k, 1, 1, 0);
      if(step == R_PosInf || R_IsNaN(step)) {
	warning("Inf or NaN happened, not converge!");
	break;
      }
      if(step == 0) break;
      result += step;
      k++;
    }
  }

  return result;
}

//' @rdname dcoga_approx
//' @export
// [[Rcpp::export]]
NumericVector pcoga_approx(NumericVector x,
			   NumericVector shape,
			   NumericVector rate) {
  // input check
  if (is_true(any(rate <= 0))) stop("all rate should be larger than 0.");
  if (is_true(any(shape < 0))) stop("all shape should be larger than or equal to 0, with at least three non-zero.");
  // handle recycle
  if (shape.size() != rate.size()) {
    if (shape.size() < rate.size()) {
      if (rate.size() % shape.size() != 0) warning("number of rate is not a multiple of shape.");
      shape = recycling2(shape, rate);
    } else {
      if (shape.size() % rate.size() != 0) warning("number of shape is not a multiple of rate.");
      rate = recycling2(rate, shape);
    }
  }
  rate = rate[shape > 0];
  shape = shape[shape > 0];
  if (shape.size() < 3) stop("all shape should be larger than or equal to 0, with at least three non-zero.");
  // input check
  
  NumericVector beta = 1 / rate;
  int n = x.size();
  NumericVector result(n);
  for (int i = 0; i < n; ++i) {
    result[i] = pcoga_approx_nv(x[i], shape, beta);
  }
  return result;
}
