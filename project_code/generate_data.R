library(dplyr)
library(causl)
library(aciccomp2016)
library(BART)
library(fastDummies)
library(rstudioapi)
set.seed(12345)
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)

# import aciccomp2016 data to simulate simular to 
dat <- as_tibble(input_2016)

# parameters for simulations
forms <- list(list(),
              list(A ~ x_1 + x_3 + x_4),
              list(Y ~ A),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=c(-1.5,0.03,0.02,0.05)),
             Y = list(beta=c(3200, -500), phi=400^2),
             cop = list(beta=-1))

# generate data
data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataA.csv') )


coeff = c(1, rep(c(0.01,-0.01), 10)[1:6] )
# parameters for simulations
forms <- list(list(),
              list(A ~ 1 + x_1^2 + x_3^2 + x_4^2 +x_1*x_3 + x_1*x_4 + x_3*x_4 ),
              list(Y ~ A),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=coeff),
             Y = list(beta=c(3200, -500), phi=400^2),
             cop = list(beta=-1))

# generate data
data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataB.csv') )




# parameters for simulations
forms <- list(list(),
              list(A ~ x_1 + x_3 + x_4),
              list(Y ~ A + x_1 + x_3 + x_4),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=c(-1.5,0.03,0.02,0.05)),
             Y = list(beta=c(3200, -500, 0.05, 0.05, 0.05), phi=400^2),
             cop = list(beta=-1))

# generate data
data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataC.csv') )
