library(dplyr)
library(fastDummies)
library(rstudioapi)
set.seed(12345)
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)

dataA = read.csv(paste0(script_directory, '/data/dataA.csv'))

dataA_treated = data[data$A==1,]
dataA_untreated = data[data$A==0,]


for (i in seq(10)){
  
}