library(rstudioapi)
library(MatchIt)
library(ggplot2)
set.seed(12345)

# directory of the script
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)

n_r = 500
n = n_r*8
coefficients = numeric(n)
ci_lower = numeric(n)
ci_upper = numeric(n)
names = character(n)
count = 0
# loop through all data files

# start time

for (val in c('A', 'B', 'C', 'D')){
  for (val2 in c('', '_uneven')){
    print(paste0('Processing: data_',val, val2) )
    
    val = paste0(val, val2)
    for (r in seq_len(n_r)){
      count = count + 1
    
    # read data
    data = read.csv(paste0(script_directory, '/data/data', val , formatC(r, width=3, fla="0") ,'.csv'))
    # fit propensity score model and match data using optimal matching
    m.out1 <- matchit(A ~ . -Y , data = data, distance = "glm", method= "nearest")

    
    #matched data
    data = subset(match.data(m.out1, data=data), select = -c(distance, weights, subclass))
    
    
    
    #fit linear model
    fit = lm(Y ~ . , data = data)
    #save coefficient value
    coefficients[count] = fit$coefficients["A"]
    ci_lower[count] = confint(fit, "A")[1]
    ci_upper[count] = confint(fit, "A")[2]
    names[count] = val
    # NB match it matchit package suggests using avg_comparisons() to estimate 
    # ATE, however they note in some cases this is superfluous i belive this is 
    # one of these cases and i have verified that it produces the same results
  }
}
}

plot_data = data.frame(names, coefficients, ci_lower, ci_upper)
# save plot data
save(plot_data, file = paste0(script_directory, '/data/plot_data_propensity_matching.RData'))



