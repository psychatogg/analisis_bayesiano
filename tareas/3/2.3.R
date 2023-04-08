library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
set.seed(1)

x1 = c(28, 43, 19, 30, 25, 32, 45, 41, 26, 22, 32, 41, 36, 20, 29)
x2 = c(11, 17, 14, 12, 18, 12, 14, 16, 12, 13, 17, 15, 11, 13, 20)
y = c(1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0)

datos <- list(n = length(y), x1 = x1, x2 = x2, y = y)
codigo <- "
data {
  int<lower=0> n;
  int<lower=0,upper=1> y[n];
  real x1[n];
  real x2[n];
}

parameters {
  real tau;
  real omega1;
  real omega2;
}

model {
	real pi;
  tau ~ normal(0, 5);
  omega1 ~ normal(0, 5);
  omega2 ~ normal(0, 5);
  
  for (i in 1:n) {
  	pi = (exp(tau+omega1*x1[i]+omega2*x2[i]))/(1+exp(tau+omega1*x1[i]+omega2*x2[i]));
    y[i] ~ bernoulli(pi);
  }
}
"
fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)
