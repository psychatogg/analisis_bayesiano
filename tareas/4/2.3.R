y <- c(93, 66, 42, 45, 38, 32, 36, 43, 40, 53)
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
datos1 <- list(n = length(x), x = x, y = y, modelo=1)
datos2 <- list(n = length(x), x = x, y = y, modelo=2)
codigo <- "
  data {
    int<lower=0> n;
    real<lower=0> x[n];
    real<lower=0> y[n];
    int modelo;
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
		if(modelo==1){
		mu = exp(tau+omega1*x[i]);
		}else{
		mu = exp(tau+omega1*x[i]+omega2*(x[i])^2);
		}
		alpha = mu*phi;
		beta = phi;
		y[i] ~ gamma(alpha,beta);
	}
  }
  generated quantities{
  real D;
  real alpha_D;
  real beta_D;
  beta_D = phi;
  D =  0;
  for (i in 1:n){
  	if(modelo == 1){
  	alpha_D = exp(tau+omega1*x[i])*phi;
  	} else {
  	alpha_D = exp(tau+omega1*x[i]+omega2*(x[i])^2)*phi;
  	}
  
  D += gamma_lpdf(x[i] | alpha_D,beta_D);
  }
  D*= -2;
  }
  "
fit1 <- stan(model_code = codigo, data = datos1, iter = 1000)
fit2 <- stan(model_code = codigo, data = datos2, iter = 1000)

D1 <- unlist(extract(fit1, pars='D'))
D2 <- unlist(extract(fit2, pars='D'))
DIC1 <- mean(D1) + 0.5 * var(D1)
DIC2 <- mean(D2) + 0.5 * var(D2)

cat(sprintf("\nModelo 1. mean D = %8.2f. pD = %8.2f. DIC = %8.2f\n
Modelo 2. mean D = %8.2f. pD = %8.2f. DIC = %8.2f\n",
						mean(D1), 0.5*var(D1), DIC1, mean(D2), 0.5*var(D2), DIC2))

print(fit1)
print(fit2)
