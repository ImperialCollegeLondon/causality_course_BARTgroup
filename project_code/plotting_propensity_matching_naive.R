library(ggplot2)
library(rstudioapi)

directory = dirname(rstudioapi::getSourceEditorContext()$path)
# import data
load(paste0(directory, '/data/plot_data_propensity_matching.RData'))
plot_data_propensity = plot_data
plot_data_naive = load(paste0(directory, '/data/plot_data_naive_method.RData'))
plot_data_naive = plot_data

# add method column to each set of data
plot_data_propensity$Method = "Propensity Matching"
plot_data_naive$Method = "Naive Method"

# combine the data
plot_data = rbind(plot_data_propensity, plot_data_naive)


# plot density of the coefficient estimates for each method
p = ggplot(plot_data, aes(x=coefficients, fill=Method)) + 
  geom_density(alpha=0.5) + 
  facet_wrap(~names) + 
  theme_minimal() + 
  labs(title = "", x = "Coefficient estimate", y = "Density") 

#add legend in bottom right corner
p = p + theme(legend.position = "bottom")
#add vertical line at true value
p = p + geom_vline(xintercept = -100, linetype="dashed", color = "black")
ggsave(paste0(dirname(directory), '/pngs/density_multiple_sims_naive_propensity.png'), p, dpi = 300)

# add column of binary variables indicating whether the true value is within the confidence interval
plot_data$true_in_ci = ifelse(plot_data$ci_lower <= -100 & plot_data$ci_upper >= -100, 1, 0)

# calculate proportion of confidence intervals containing the true value for each method and data set
proportion_ci_true <- plot_data %>%
  group_by(names, Method) %>%
  summarize(proportion = mean(true_in_ci))

# plot proportion of confidence intervals
p2 <- ggplot(proportion_ci_true, aes(x = names, y = proportion, fill = Method)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "",
       x = "Dataset Name", y = "Proportion",
       fill = "Method")
# add legend in bottom right corner
p2 = p2 + theme(legend.position = "bottom")
# add horizontal line at 0.95
p2 = p2 + geom_hline(yintercept = 0.95, linetype="dashed", color = "black")
# save plot as png
ggsave(paste0(dirname(directory), '/pngs/proportion_in_ci_multiple_sims_naive_propensity.png'), p2, dpi = 300)

