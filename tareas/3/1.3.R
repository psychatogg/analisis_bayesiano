library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
set.seed(1)

datos <- list(n = length(y), x = x, y = y)
codigo <- "
  data {
    int<lower=0> n;
    int<lower=0> y[n];
    int<lower=0> x[n];
  }
  
  parameters {
    real tau;
    real omega;
  }
  model {
  	real lambda;
    tau ~ normal(0, 5);
    omega ~ normal(0, 5);
    for (i in 1:n) {
    	lambda = exp(tau + omega*x[i]);
      y[i] ~ poisson(lambda);
    }
  }
"

fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)