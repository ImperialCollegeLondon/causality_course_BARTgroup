library(dplyr)
library(causl)
library(aciccomp2016)
library(BART)
library(fastDummies)
library(rstudioapi)
set.seed(12345)
# import acicomp2016 data to simulate simular to 
dat <- as_tibble(input_2016)

script_directory = dirname(rstudioapi::getSourceEditorContext()$path)

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
write.csv(data, paste0(script_directory, '/data/test_data.csv') )

# create dummy variables
data = dummy_cols(data, remove_first_dummy = TRUE, remove_selected_columns=TRUE)
write.csv(data, paste0(script_directory, '/data/test_data_with_dummy_vars.csv') )
