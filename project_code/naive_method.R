library(ggplot2)

set.seed(12345)
# directory of the script
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)


coefficients = list()
ci_lower = list()
ci_upper = list()
name_list = list()
count = 0
# loop through all data files
for (val in c('A', 'B', 'C', 'D')){
  for (val2 in c('', '_uneven')){
    count = count + 1
    val = paste0(val, val2)

    #read data
    data = read.csv(paste0(script_directory, '/data/data', val, '.csv'))
    #fit linear model
    fit = lm(Y ~ . , data = data)
    #save coefficient value
    coefficients[[count]] = fit$coefficients["A"]
    ci_lower[[count]] = confint(fit, "A")[1]
    ci_upper[[count]] = confint(fit, "A")[2]
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
  geom_point(color= 'blue') +
  geom_errorbar(width=0.25, color = 'blue') +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title="ATE estimates and CI (95%) using naive method", x="Data", y="ATE estimate") +
  geom_hline(yintercept=-100, linetype="dashed", color = "red")
# save plot
directory = dirname(script_directory)
ggsave(paste0(directory, '/pngs/naive_method.png'), dpi = 300)
