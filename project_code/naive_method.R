set.seed(12345)
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)


fits = list()
count = 0
for (val in c('A', 'B', 'C', 'D')){
  for (val2 in c('', '_uneven')){
    count = count + 1
    val = paste0(val, val2)
    data = read.csv(paste0(script_directory, '/data/data', val, '.csv'))
    data_treated = data[data$A==1,]
    data_untreated = data[data$A==0,]
    #data = rbind(data_treated, data_untreated[floor(nrow(data_untreated)/2),])
    fit = lm(Y ~ . , data = data)
    fits[[count]] = fit
    print(paste0('data', val))
    print(fit$coefficients["A"])
    print(confint(fit, "A"))
}
}

#plot boxplot of FIT with the A coeefficient and a 2 sided ci