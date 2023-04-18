y <- c(93, 66, 42, 45, 38, 32, 36, 43, 40, 53)
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
datos <- list(n = length(x), x = x, y = y)
codigo <- "
  data {
    int<lower=0> n;
    real<lower=0> x[n];
    real<lower=0> y[n];
  }
  
  parameters {
  real phi;
  real tau;
  real omega1;
  real omega2;
  }
  model{
  real mu;
  real alpha;
  real beta;
  
  
  tau ~ normal(0,5);
  omega1 ~ normal(0,5);
  omega2 ~ normal(0,5);
	for(i in 1:n){
		mu = exp(tau+omega1*x[i]+omega2*(x[i])^2);
		alpha = mu*phi;
		beta = phi;
		y[i] ~ gamma(alpha,beta);
	}
  }
  generated quantities{
  real D;
  D =  0;
  for (i in 1:n){
  D += gamma_lpdf(x[i] | exp(tau+omega1*x[i]+omega2*(x[i])^2)*phi,phi);
  }
  D*= -2;
  }
  "
fit <- stan(model_code = codigo, data = datos, iter = 1000)
print(fit)
D2<- unlist(extract(fit, pars='D'))
DIC2 <- mean(D1) + 0.5 *var(D2)
print(DIC2)