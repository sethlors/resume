##Homework 8 Template

##Required Libraries
library(ggplot2)
library(pROC)
library(ResourceSelection)

##Required Functions
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

##Problem 1 - Fit Model with GPA and MCAT
data <- read.csv("Homework/Homework8/Material/Med.csv")
model <- glm(Acceptance ~ MCAT + GPA, data = data, family = binomial)
summary(model)

##Part b - Prediction
coef <- coef(model)
gpa <- 3.54
mcat <- 38

logodds <- coef[1] + coef[2] * mcat + coef[3] * gpa

probability <- 1 / (1 + exp(-logodds))
probability

##Part c - Confidence interval for probability
prediction <- glm.prob.ci(model, newdata = data.frame(GPA = 3.54, MCAT = 38))
prediction

##Part d - test for overall significance
lr_test <- anova(model, test = "LRT")
lr_test

null_deviance <- model$null.deviance
full_deviance <- model$deviance
test_statistic <- null_deviance - full_deviance
test_statistic

# part e - Test for GPA variable (use Wald Test)
coef_gpa <- coef(model)["GPA"]
std_err_gpa <- summary(model)$coefficients["GPA", "Std. Error"]
wald_stat_gpa <- (coef_gpa / std_err_gpa)^2
p_value_gpa <- 1 - pchisq(wald_stat_gpa, df = 1)
if (p_value_gpa < 0.05) {
  conclusion_gpa <- "Reject null hypothesis"
} else {
  conclusion_gpa <- "Fail to reject null hypothesis"
}
print("Test for GPA variable (Wald Test)")
print("Null Hypothesis: Coefficient for GPA is zero")
print("Alternative Hypothesis: Coefficient for GPA is not zero")
print(paste("Test statistic:", wald_stat_gpa))
print(paste("P-value:", p_value_gpa))
print(conclusion_gpa)
coef_mcat <- coef(model)["MCAT"]
std_err_mcat <- summary(model)$coefficients["MCAT", "Std. Error"]
wald_stat_mcat <- (coef_mcat / std_err_mcat)^2
p_value_mcat <- 1 - pchisq(wald_stat_mcat, df = 1)
if (p_value_mcat < 0.05) {
  conclusion_mcat <- "Reject null hypothesis"
} else {
  conclusion_mcat <- "Fail to reject null hypothesis"
}
print("Test for MCAT variable (Wald Test)")
print("Null Hypothesis: Coefficient for MCAT is zero")
print("Alternative Hypothesis: Coefficient for MCAT is not zero")
print(paste("Test statistic:", wald_stat_mcat))
print(paste("P-value:", p_value_mcat))
print(conclusion_mcat)

##Problem 2 - Fit Model with GPA, MCAT, and Sex

##part

##part
model_sex <- glm(Acceptance ~ MCAT + GPA + Sex, data = data, family = binomial)
summary(model_sex)
coef_sex <- coef(model_sex)["SexM"]
std_err_sex <- summary(model_sex)$coefficients["SexM", "Std. Error"]

lower_bound <- coef_sex - 1.96 * std_err_sex
upper_bound <- coef_sex + 1.96 * std_err_sex
print("Part b: Confidence interval for slope coefficient of Sex variable")
print("95% Confidence Interval:")
print(paste("Lower Bound:", lower_bound))
print(paste("Upper Bound:", upper_bound))

## part c - Test for sex variabl
wald_stat_sex <- (coef_sex / std_err_sex)^2
p_value_sex <- 1 - pchisq(wald_stat_sex, df = 1)
if (p_value_sex < 0.05) {
  conclusion_sex <- "Reject null hypothesis"
} else {
  conclusion_sex <- "Fail to reject null hypothesis"
}
print("Part c: Test for Sex variable (Wald Test)")
print("Null Hypothesis: Coefficient for Sex variable is zero")
print("Alternative Hypothesis: Coefficient for Sex variable is not zero")
print(paste("Test statistic:", wald_stat_sex))
print(paste("P-value:", p_value_sex))
print(conclusion_sex)

##Problem 3 - Fit Model with GPA, MCAT, and Interaction

##Part b - Prediction
model_interaction <- glm(Acceptance ~ MCAT * GPA, data = data, family = binomial)
intercept <- coef(model_interaction)[1]
coef_mcat <- coef(model_interaction)[2]
coef_gpa <- coef(model_interaction)[3]
coef_interaction <- coef(model_interaction)[4]
cat("Equation for predicting log odds of acceptance:")
cat("\n")
cat(paste("Log Odds of Acceptance = ", intercept, " + ", coef_mcat, " * MCAT + ", coef_gpa, " * GPA + ", coef_interaction, " * (MCAT * GPA)"))

acceptance_prob <- exp(intercept +
                         coef_mcat * 38 +
                         coef_gpa * 3.54 +
                         coef_interaction * (38 * 3.54)) / (1 + exp(intercept +
                                                                      coef_mcat * 38 +
                                                                      coef_gpa * 3.54 +
                                                                      coef_interaction * (38 * 3.54)))
acceptance_prob

##Part c - Confidence interval for probability
confidence_interval <- glm.prob.ci(model_interaction, newdata = data.frame(GPA = 3.54, MCAT = 38))
confidence_interval

## part d Test for interaction term
std_err_interaction <- summary(model_interaction)$coefficients["MCAT:GPA", "Std. Error"]
coef_interaction <- coef(model_interaction)["MCAT:GPA"]
wald_stat_interaction <- (coef_interaction / std_err_interaction)^2
p_value_interaction <- 1 - pchisq(wald_stat_interaction, df = 1)
if (p_value_interaction < 0.05) {
  conclusion_interaction <- "Reject null hypothesis"
} else {
  conclusion_interaction <- "Fail to reject null hypothesis"
}
cat("Test for Interaction Term (Wald Test)")
cat("\n")
cat("Null Hypothesis: Coefficient of the interaction term between GPA and MCAT is zero")
cat("\n")
cat("Alternative Hypothesis: Coefficient of the interaction term between GPA and MCAT is not zero")
cat("\n")
cat("Test statistic:", wald_stat_interaction)
cat("\n")
cat("P-value:", p_value_interaction)
cat("\n")
cat("Conclusion:", conclusion_interaction)


##Problem 4 - Model selection using all 4 explanatory variables

full_model <- glm(Acceptance ~ MCAT + GPA + Sex + Apps, family = binomial, data = data)
stepwise_model_AIC <- step(full_model, direction = "both", trace = 0, k = 2, criterion = "aic")
stepwise_model_BIC <- step(full_model, direction = "both", trace = 0, k = log(nrow(data)), criterion = "bic")
final_model <- stepwise_model_AIC
pseudo_R2 <- McFR2(final_model)
hl_test <- hoslem.test(final_model$y, fitted(final_model), g = 10)
confusion_table <- confusion.glm(final_model)
roc_curve <- roc(final_model$y, fitted(final_model))
auc <- auc(roc_curve)

# Step 4: Print Results
cat("Final Model:", "\n")
print(summary(final_model))
cat("\n")

cat("Pseudo R^2:", pseudo_R2, "\n")
cat("\n")

cat("Hosmer-Lemeshow Goodness of Fit Test:", "\n")
cat("Null Hypothesis: The model fits the data well.", "\n")
cat("Alternative Hypothesis: The model does not fit the data well.", "\n")
cat("Test Statistic:", hl_test$chisq, "\n")
cat("P-value:", hl_test$p.value, "\n")
if (hl_test$p.value < 0.05) {
  cat("Conclusion: Reject null hypothesis\n")
} else {
  cat("Conclusion: Fail to reject null hypothesis\n")
}
cat("\n")

cat("Confusion Table:", "\n")
print(confusion_table$Confusion)
cat("Agreement:", confusion_table$Agreement, "\n")
cat("Sensitivity:", confusion_table$Sensitivity, "\n")
cat("Specificity:", confusion_table$Specificity, "\n")
cat("\n")

cat("ROC Curve:", "\n")
plot(roc_curve, main = "ROC Curve", col = "blue")
cat("Area under ROC Curve (AUC):", auc, "\n")