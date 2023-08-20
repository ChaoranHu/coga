// [[Rcpp::interfaces(r, cpp)]]

#include <Rcpp.h>
using namespace Rcpp;

// all shape and scale parameter here with the minimum scale at the end

double get_h(NumericVector u, double ind){
  if (ind == 1) return(1);
  u.erase(ind - 1, u.length());
  double result = 1;
  for(int i = 0; i < u.length(); ++i){
    result *= 1 - u(i);
  }
  return result;
}

NumericVector get_s(NumericVector scale){
  double min_scale = scale(scale.length() - 1);
  scale.erase(scale.length() - 1);
  return(1/min_scale - 1/scale);
}

double get_alpha_bar(NumericVector shape, double ind){
  shape.erase(0, ind);
  return sum(shape) - 1;
}

// prepare integrand
// [[Rcpp::export]]
double salvo_integrand(NumericVector u, double y,
		       NumericVector shape, NumericVector scale){
  NumericVector s = get_s(scale);
  double result;
  int nFold = shape.length() - 1;

  double cartA = 0;
  for (int i = 1; i <= nFold; ++i) {
    cartA += u(i - 1) * s(i - 1) * get_h(u, i);
  }
  cartA = exp(cartA * y);

  double cartB = 1;
  for (int i = 1; i <= nFold; ++i) {
    cartB *= pow(u(i - 1), shape(i - 1) - 1) * pow(1 - u(i - 1), get_alpha_bar(shape, i));
  }

  result = cartA * cartB;
  return result;
}


// prepare multiplicative component
// [[Rcpp::export]]
double salvo_multi_comp(double y,
			NumericVector shape, NumericVector scale){
  double min_scale = scale(scale.length() - 1);
  double sum_shape = sum(shape);
  double result = pow(y/min_scale, sum_shape) / y;
  result *= exp(-y/min_scale)/tgamma(shape(shape.length() - 1));

  double cartA = 1;
  for (int i = 1; i < shape.length(); ++i){
    cartA *= pow(min_scale/scale(i-1), shape(i-1))/tgamma(shape(i-1));
  }
  return cartA * result;
}

