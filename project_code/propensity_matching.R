library(dplyr)
library(rstudioapi)
library(MatchIt)
set.seed(12345)
script_directory = dirname(rstudioapi::getSourceEditorContext()$path)

dataA = read.csv(paste0(script_directory, '/data/dataA.csv'))

data =dataA
m.out0 <- matchit(A ~ . , data = data,
                  method = NULL, distance = "glm")
summary(m.out0)


i=1
dataA_treated = data[data$A==1,i]
dataA_untreated = data[data$A==0,i]

xx = c(max(table(dataA_treated)), max(table(dataA_untreated)))/ c(length(dataA_treated), length(dataA_treated))
# If numeric, create histograms for treated data
hist(dataA_treated, col = rgb(0, 0, 1, 0.5), main = "Histogram of Treated vs. Untreated Data",
     xlab = "Values", ylab = "Frequency", xlim = range(c(dataA_treated, dataA_untreated)), ylim=c(0,max(xx)), freq=FALSE)

# Add histogram for untreated data with transparency to distinguish between the two histograms
hist(dataA_untreated, col = rgb(1, 0, 0, 0.5), add = TRUE, freq=FALSE)

# Add a legend
legend("topright", legend = c("Treated", "Untreated"), fill = c(rgb(0, 0, 1, 0.5), rgb(1, 0, 0, 0.5)))