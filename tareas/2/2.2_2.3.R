library(rstan)
library(ggplot2)

set.seed(1)
x <- c(1, 1, 1, 0, 0)
b <- c(-1.20, -0.65, 0.20, 0.80, 1.15)
datos <- list(n_items = length(x), x = x, b = b)

codigo <- "
data {
  int  n_items;
  int x [n_items];
  real b[n_items];
}

parameters {
  real theta;
}

model {
  real p;
  theta ~ normal(0, 1);
  for (i in 1:n_items) {
    p = exp(theta - b[i]) / (1 + exp(theta - b[i]));
    x[i] ~ bernoulli(p);
  }
}
"

fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)

traceplot(fit, pars="theta")
stan_hist(fit, pars="theta")
stan_dens(fit, pars="theta")
plot(fit)
stan_ac(fit, pars="theta")


