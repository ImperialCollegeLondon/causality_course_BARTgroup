library(dplyr)
library(causl)
library(aciccomp2016)
install.packages('fastDummies')
library(BART)
library(fastDummies)
set.seed(12345)


# iport acicomp2016 data to simulate simular to 
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



# create dummy variables
data = dummy_cols(data, remove_first_dummy = TRUE, remove_selected_columns=TRUE)

# Fit BART model 
x.train = subset(data, select = -c(Y) )
y.train = data$Y
bart_model <- mc.wbart(x.train, y.train, mc.cores=8)


x.train$A = 1
pred_y1 = predict(bart_model, x.train)
x.train$A = 0
pred_y0 = predict(bart_model, x.train)

ATE = mean(pred_y1 - pred_y0)
print(ATE)
