library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
set.seed(1)

x1 = c(28, 43, 19, 30, 25, 32, 45, 41, 26, 22, 32, 41, 36, 20, 29)
y = c(1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0)


datos <- list(n = length(y), x = x1, y = y)
codigo <- "
data {
  int<lower=0> n;
  int<lower=0,upper=1> y[n];
  real x[n];
}

parameters {
  real tau;
  real omega;
}

model {
	real pi; 
  tau ~ normal(0,5);
  omega ~ normal(0,5);
  for (i in 1:n) {
  	pi = (exp(tau+omega*x[i]))/(1+exp(tau+omega*x[i])) ;
    y[i] ~ bernoulli(pi);
  }
}
"

fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)
