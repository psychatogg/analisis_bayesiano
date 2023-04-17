library(rstan)
x1 <- c(4.8, 6.2, 6.1, 5.1, 4.8, 3, 6)
x2 <- c(4, 4.7, 4.9, 5.7, 4.2, 2.9, 5.6)
datos <- list(n = length(x1), x1 = x1, x2 = x2)
codigo <- "
  data {
    int<lower=0> n;
    real<lower=0> x1[n];
    real<lower=0> x2[n];
  }
  
  parameters {
  real mu1;
  real mu2;
  }
  model{
  mu1 ~ normal(0,5);
  mu2 ~ normal(0,5);
  for(i in 1:n){
		x1[i] ~ normal(mu1,1);
		}
	for(i in 1:n){
		x2[i] ~ normal(mu2,1);
		} 
  }
  generated quantities{
  real D;
  D =  0;
  for (i in 1:n){
  D += normal_lpdf(x1[i] | mu1,1);
  D += normal_lpdf(x2[i] | mu2,1);
  }
  D*= -2;
  }
  "
fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)
D1<- unlist(extract(fit, pars='D'))
DIC1 <- mean(D1) + 0.5 *var(D1)
print(DIC1)