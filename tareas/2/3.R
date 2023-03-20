library(rstan)
set.seed(1)
x <- rnorm(25,3,2)
datos <- list(N = length(x), x = x)
codigo <- "
data {
  int<lower=0> N;  
  real x[N];
}

parameters {
  real mu;
}

model {
  mu ~ normal(0,10);
  x ~ normal(mu,2);
}
"
fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)
cat(sprintf("EAP = %6.3f, Var_post = %6.3f, Li_post = %6.3f,  Ls_post = %6.3f",
						3.31, 0.41^2,qnorm(0.04, 3.31,0.41), qnorm(0.96, 3.31,0.41)))

