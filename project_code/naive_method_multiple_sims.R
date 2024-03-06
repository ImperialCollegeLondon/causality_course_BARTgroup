library(ggplot2)
library(rstudioapi)

set.seed(12345)
# directory of the script
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)

directory = dirname(script_directory)

n_r = 500
n = n_r*8
coefficients = numeric(n)
ci_lower = numeric(n)
ci_upper = numeric(n)
names = character(n)

count = 0
# loop through all data files
for (val in c('A', 'B', 'C', 'D')){
  for (val2 in c('', '_uneven')){
    val = paste0(val, val2)
    print(val)
    for (r in seq_len(n_r)){
      count = count + 1
    
    #fit linear model
    fit = lm(Y ~ . , data = read.csv(paste0(script_directory, '/data/data', val , formatC(r, width=3, fla="0") ,'.csv')))
    #save coefficient value
    coefficients[count] = fit$coefficients["A"]
    ci_lower[count] = confint(fit, "A")[1]
    ci_upper[count] = confint(fit, "A")[2]
    names[count] = val
}
}
}


plot_data = data.frame(names, coefficients, ci_lower, ci_upper)
# save plot data
save(plot_data, file = paste0(script_directory, '/data/plot_data_naive_method.RData'))


