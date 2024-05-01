# Homework 7 Template

# Required Libraries
library(ggplot2)
library(pROC)
library(ResourceSelection)

# Required Functions
glm.prob.ci <- function(model, newdata = NULL, conf.level = 0.95) {
  alpha2.level <- conf.level + (1 - conf.level) / 2
  z_alpha2 <- qnorm(alpha2.level, 0, 1)
  if (is.null(newdata) == "TRUE") {
    model.logodds <- predict.glm(model, se.fit = T)
    model.logodds.lci <- model.logodds$fit - z_alpha2 * model.logodds$se.fit
    model.logodds.uci <- model.logodds$fit + z_alpha2 * model.logodds$se.fit
    model.probs.lci <- exp(model.logodds.lci) / (1 + exp(model.logodds.lci))
    model.probs.uci <- exp(model.logodds.uci) / (1 + exp(model.logodds.uci))
    model$data <- cbind(model$data, model.probs.lci, model.probs.uci)
    model$data
  } else {
    model.logodds <- predict.glm(model, newdata = newdata, se.fit = T)
    model.logodds.lci <- model.logodds$fit - z_alpha2 * model.logodds$se.fit
    model.logodds.uci <- model.logodds$fit + z_alpha2 * model.logodds$se.fit
    model.probs.lci <- exp(model.logodds.lci) / (1 + exp(model.logodds.lci))
    model.probs.uci <- exp(model.logodds.uci) / (1 + exp(model.logodds.uci))
    probs.ci <- cbind(model.probs.lci, model.probs.uci)
    colnames(probs.ci) <- c(as.character(100 * (1 - alpha2.level)),
                            as.character(100 * alpha2.level))
    list(probs.ci)
  }
}

confusion.glm <- function(model, cutoff = 0.5) {
  predicted <- ifelse(predict(model, type = 'response') > cutoff,
                      1, 0)
  observed <- model$y
  confusion <- table(observed, predicted)
  agreement <- (confusion[1, 1] + confusion[2, 2]) / sum(confusion)
  specificity <- confusion[1, 1] / rowSums(confusion)[1]
  sensitivity <- confusion[2, 2] / rowSums(confusion)[2]
  list("Confusion Table" = confusion,
       "Agreement" = agreement,
       "Sensitivity" = sensitivity,
       "Specificity" = specificity)
}

McFR2 <- function(model) {
  G2 <- model$deviance
  G2null <- model$null.deviance
  McFR2 <- 1 - G2 / G2null
  McFR2
}

# Like many of their species, wolf spiders are known to practice cannibalism, with female spiders eating male spiders
# either before, during or after mating. However, since cannibalism does not occur after every act of mating,
# researchers have been interested in determiningfactors associated with the occurrence of cannibalism. In one such
# study, 52 female-male pairs were measured and then observed mating. Does the size difference between the female
# and male spiders help explain whether or not cannibalism occurred? The file wolfspiders.csv contains information
# about the presence or absence of cannibalism for each pair and the size difference between the female and male
# spiders (in mm)

# Problem 1
# In what proportion of the 52 matings did cannibalism occur?
wolfspiders <- read.csv("Homework/Homework 7/Material/wolfspiders.csv")
names(wolfspiders) <- c("Difference", "Cannibalism")
wolfspiders$Cannibalism <- as.factor(wolfspiders$Cannibalism)

# Calculate sample proportion for cannibalism variable
prop.table(table(wolfspiders$Cannibalism))
#        No       Yes
# 0.7884615 0.2115385

# Calculate sample proportion for cannibalism variable
prop.table(table(wolfspiders$Cannibalism))
#        No       Yes
# 0.7884615 0.2115385

# Problem 2
# Write the equation for predicting the log odds of cannibalism from the size difference between the female and male
# spiders.
# Log odds of cannibalism = β0 + β1 * Difference

# Fit the logistic regression model
model <- glm(Cannibalism ~ Difference, data = wolfspiders, family = binomial)

# Problem 4

# Calculate exp(slope)
exp(coef(model)["Difference"])
## Difference
## 21.52642

# Calculate exp(intercept)
exp(coef(model)["(Intercept)"])
## (Intercept)
## 0.04554546

# Problem 5
# Calculate predicted probability for difference = -0.2mm
predict(model, newdata = data.frame(Difference = -0.2), type = "response")
##       1
## 0.02405882

# Calculate predicted probability for difference = 0.4mm
predict(model, newdata = data.frame(Difference = 0.4), type = "response")
## 1
## 0.1345479

# Problem 6
# Calculate confidence interval for probability for difference = 0mm
glm.prob.ci(model, newdata = data.frame(Difference = 0), conf.level = 0.95)
#         2.5      97.5
# 0.008894204 0.1877545

# Calculate confidence interval for probability for difference = 0.8mm
glm.prob.ci(model, newdata = data.frame(Difference = 0.8), conf.level = 0.95)
#       2.5      97.5
# 0.1831188 0.5567838

# Problem 7

# Wald test information is in summary(model)
# Calculate Likelihood Ratio Test statistic and p-value
lr.test <- anova(model, test = "Chisq")
lr.test

# Analysis of Deviance Table
#
# Model: binomial, link: logit
#
# Response: Cannibalism
#
# Terms added sequentially (first to last)
#
#
# Df Deviance Resid. Df Resid. Dev  Pr(>Chi)
# NULL                          51     53.663
# Difference  1   18.942        50     34.721 1.348e-05 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

lr.test <- anova(model, test = "Chisq")

# Extract likelihood ratio test statistic and p-value
lr.test_statistic <- lr.test$Deviance[2]  # Extract the Deviance associated with the Difference variable
lr.test_p_value <- lr.test$'Pr(>Chi)'[2]  # Extract the p-value associated with the Difference variable

# Print the likelihood ratio test statistic and p-value
cat("Likelihood Ratio Test Statistic:", lr.test_statistic, "\n")
cat("Likelihood Ratio Test p-value:", lr.test_p_value, "\n")

# Conclusion
if (lr.test_p_value < 0.05) {
  cat("Based on the Likelihood Ratio Test, we reject the null hypothesis. The model is significant.\n")
} else {
  cat("Based on the Likelihood Ratio Test, we fail to reject the null hypothesis. The model is not significant.\n")
}

# Problem 8

# Use function McFR2 to calculate McFadden's R^2
McFR2(model)
# 0.3529793

# Problem 9

# Use function hoslem.test to calculate test statistic
# and p-value for Hosmer-Lemeshow test
predicted_probs <- predict(model, type = "response")

hoslem.test(predicted_probs, as.numeric(wolfspiders$Cannibalism), g = 5)

# Hosmer and Lemeshow goodness of fit (GOF) test
#
# data:  predicted_probs, as.numeric(wolfspiders$Cannibalism)
# X-squared = Inf, df = 0, p-value < 2.2e-16


# Problem 10

# Use function confusion.glm to obtain confusion table
# and associated statistics
confusion.glm(model)
# $`Confusion Table`
#         predicted
# observed  0  1
#        0 39  2
#        1  8  3
#
# $Agreement
# [1] 0.8076923
#
# $Sensitivity
#         1
# 0.2727273
#
# $Specificity
#         0
# 0.9512195

# Problem 11
roc.curve <- roc(wolfspiders$Cannibalism, fitted(model))
plot(roc.curve, col = "blue", main = "ROC Curve")

auc <- with(roc.curve, sum(diff(specificities) * (sensitivities[-1] + sensitivities[-length(sensitivities)]) / 2))
auc
# 0.886918


# Run the functions to calculate and graph the ROC Curve

# Run the function aoc() to find the area under ROC Curve