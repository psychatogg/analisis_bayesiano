library(rstan)
set.seed(1)

y <- 18
n <- 50

alpha <- 16
beta <- 64

datos <- list(N=n, exitos=y, a=alpha, b=beta)

codigo <- '
data {
int<lower=0> N;
int exitos;
real a;
real b;
}

parameters {
real<lower=0, upper=1> pi;
}

model {
pi ~ beta(a,b);
exitos ~ binomial(N, pi);
}
'

fit <- stan(model_code = codigo, data = datos)
print(fit)

