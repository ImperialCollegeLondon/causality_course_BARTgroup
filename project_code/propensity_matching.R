library(rstudioapi)
library(MatchIt)
library(ggplot2)
set.seed(12345)

# directory of the script
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)
directory = dirname(script_directory)

coefficients = list()
ci_lower = list()
ci_upper = list()
name_list = list()
count = 0
# loop through all data files
for (val in c('A', 'B', 'C', 'D')){
  for (val2 in c('', '_uneven')){
    print(paste0('Processing: data_',val, val2) )
    
    count = count + 1
    val = paste0(val, val2)
    
    # read data
    data = read.csv(paste0(script_directory, '/data/data', val, '.csv'))
    # fit propensity score model and match data using optimal matching
    m.out1 <- matchit(A ~ . -Y , data = data, distance = "glm", method= "optimal")
    
    #plotting distribution of propensity scores before and after matching
    try(dev.off())
    pdf(paste0(directory, '/pngs/distribution_propensity_matching_plot_', val, '.pdf'))
    plot(m.out1, type = "jitter", interactive = FALSE)
    dev.off()
    
    #matched data
    data = match.data(m.out1, data=data)
    data = subset(data, select = -c(distance, weights, subclass))
    
    
    
    #fit linear model
    fit = lm(Y ~ . , data = data)
    #save coefficient value
    coefficients[[count]] = fit$coefficients["A"]
    ci_lower[[count]] = confint(fit, "A")[1]
    ci_upper[[count]] = confint(fit, "A")[2]
    
    # NB match it matchit package suggests using avg_comparisons() to estimate 
    # ATE, however they note in some cases this is superfluous i belive this is 
    # one of these cases and i have verified that it produces the same results
    
    #save name of data
    name_list[[count]] = val
}
}

#plot coefficient estimates and confidence intervals and true value in dashed line (true value =-100)
coefficients = unlist(coefficients)
ci_lower = unlist(ci_lower)
ci_upper = unlist(ci_upper)
name_list = unlist(name_list)
plot_data = data.frame(name_list, coefficients, ci_lower, ci_upper)
ggplot(plot_data, aes(x=name_list, y=coefficients, ymin=ci_lower, ymax=ci_upper))+
  geom_point(color= 'blue', size = 3) +
  geom_errorbar(width=0.25, color = 'blue', linewidth = 1.1) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title="", x="Dataset Name", y="ATE estimate") +
  geom_hline(yintercept=-100, linetype="dashed", color = "red", linewidth=1.1)
# save plot
ggsave(paste0(directory, '/pngs/propensity_matching_method.png'), dpi = 300)

