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

## generate data A
forms <- list(list(),
              list(A ~ x_1 + x_3 + x_4),
              list(Y ~ A),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=c(-1.5,0.03,0.02,0.05)),
             Y = list(beta=c(3200, -100), phi=400^2),
             cop = list(beta=-1))
print(paste0('DataA True ATE: -100'))

data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataA.csv'), row.names=FALSE)



# generate data C
coeff = c(1, rep(c(0.01,-0.01), 10)[1:6])
forms <- list(list(),
              list(A ~ 1 + x_1^2 + x_3^2 + x_4^2 +x_1*x_3 + x_1*x_4 + x_3*x_4 ),
              list(Y ~ A),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=coeff),
             Y = list(beta=c(3200, -100), phi=400^2),
             cop = list(beta=-1))
print(paste0('DataB True ATE: -100'))

data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataB.csv'), row.names=FALSE )



## generate data C
forms <- list(list(),
              list(A ~ x_1 + x_3 + x_4),
              list(Y ~ A + x_1 + x_3),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=c(-1.5,0.03,0.02,0.05)),
             Y = list(beta=c(3200, -100, -50, 50), phi=400^2),
             cop = list(beta=1))

print(paste0('TDataC True ATE: -100'))

data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataC.csv') , row.names=FALSE)


## generate data D
forms <- list(list(),
              list(A ~ x_1 + x_3 + x_4),
              list(Y ~ A + exp(A)),
              list(~ 1))
fams <- list(integer(0), 5, 1, 1)
pars <- list(A = list(beta=c(-1.5,0.03,0.02,0.05)),
             Y = list(beta=c(3200, -100, -100), phi=400^2),
             cop = list(beta=-1))

#print(paste0('TDataD True ATE: -100'))
data <- rfrugalParam(formulas=forms, family=fams, pars=pars, dat=dat)
print(summary(data$A))
write.csv(data, paste0(script_directory, '/data/dataD.csv') , row.names=FALSE)
