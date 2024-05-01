# HW 4 Template

# Required Libraries
library(ggplot2)
library(ggmosaic)

# Required Functions
n2prop.test <- function(p1, p2, alternative, alpha, power) {

  ztwo <- qnorm(1 - alpha / 2)
  zone <- qnorm(1 - alpha)
  zpower <- qnorm(power)

  p0 <- (p1 + p2) / 2
  R <- sqrt((2 * p0 * (1 - p0)) / ((p1 * (1 - p1) + p2 * (1 - p2))))

  switch(alternative, two.sided = ceiling((zpower + R * ztwo)^2 * (p1 * (1 - p1) + p2 * (1 - p2)) / (p1 - p2)^2), greater = ceiling((zpower + R * zone)^2 * (p1 * (1 - p1) + p2 * (1 - p2)) / (p1 - p2)^2), less = ceiling((zpower + R * zone)^2 * (p1 * (1 - p1) + p2 * (1 - p2)) / (p1 - p2)^2))
}

n2prop.ci <- function(p1, p2, m, conf.level) {
  alpha <- 1 - conf.level
  z <- qnorm(1 - alpha / 2)
  ceiling((z / m)^2 * (p1 * (1 - p1) + p2 * (1 - p2)))
}

# Required Functions
rr.ci <- function(y, n, conf.level) {
  y1 <- y[1]
  y2 <- y[2]
  n1 <- n[1]
  n2 <- n[2]
  alpha <- 1 - conf.level
  z <- qnorm(1 - alpha / 2)

  phat1 <- y1 / n1
  phat2 <- y2 / n2
  rr <- phat1 / phat2

  selogrr <- sqrt((1 - phat1) / (n1 * phat1) + (1 - phat2) / (n2 * phat2))

  logrr.lower <- log(rr) - z * selogrr
  logrr.upper <- log(rr) + z * selogrr

  rr.lower <- exp(logrr.lower)
  rr.upper <- exp(logrr.upper)

  cat("Estimated Relative Risk = ", rr, "\n")
  cat("Confidence Interval for Population Relative Risk = ", rr.lower, rr.upper, "\n")
}

or.ci <- function(y, n, conf.level) {
  y1 <- y[1]
  y2 <- y[2]
  n1 <- n[1]
  n2 <- n[2]
  alpha <- 1 - conf.level
  z <- qnorm(1 - alpha / 2)

  phat1 <- y1 / n1
  phat2 <- y2 / n2

  or <- (phat1 / (1 - phat1)) / (phat2 / (1 - phat2))

  selogor <- sqrt(1 / (n1 * phat1) +
                    1 / (n1 * (1 - phat1)) +
                    1 / (n2 * phat2) +
                    1 / (n2 * (1 - phat2)))

  logor.lower <- log(or) - z * selogor
  logor.upper <- log(or) + z * selogor

  or.lower <- exp(logor.lower)
  or.upper <- exp(logor.upper)

  cat("Estimated Odds Ratio = ", or, "\n")
  cat("Confidence Interval for Population Odds Ratio = ", or.lower, or.upper, "\n")
}


# Problem 1
# The Women’s Health Initiative conducted a randomized experiment to see if hormone therapy was helpful for
# post-menopausal women. The women were randomly assigned to receive the estrogen plus progestin hormone therapy or a
# placebo. After 5 years, the number of women who developed cancer in each group was determined. The datacan be found
# in the WHI.csv file

# Part a
# Obtain a contingency table of the two variables. What proportion of women developed cancer in each group?
whi <- read.csv("Homework/Homework 4/Material/WHI.csv")
names(whi) <- c("Group", "Cancer")
whi$Cancer <- factor(whi$Cancer, levels = c("No", "Yes"))
whi$Group <- factor(whi$Group, levels = c("Placebo", "Hormone"))
whi_table <- table(whi$Group, whi$Cancer)
prop_cancer_group <- prop.table(whi_table, margin = 1)  # Calculate proportions by row (by Group)
p_hat_hormone <- prop_cancer_group["Hormone", "Yes"]
p_hat_placebo <- prop_cancer_group["Placebo", "Yes"]
print(prop_cancer_group)
p_hat_hormone
p_hat_placebo

# Part b
# Conduct a hypothesis test to determine if the proportion of women with canceris different between the two groups
# Null hypothesis: There is no association between treatment group and occurrence of cancer
# Alternative hypothesis: There is an association between treatment group and occurrence of cancer
chi_squared_test <- chisq.test(whi_table)
chi_squared_test

# Part c
conf_interval <- prop.test(x = c(sum(whi$Group == "Hormone" & whi$Cancer == "Yes"),
                                 sum(whi$Group == "Placebo" & whi$Cancer == "Yes")),
                           n = c(sum(whi$Group == "Hormone"), sum(whi$Group == "Placebo")),
                           conf.level = 0.90)$conf.int
conf_interval
# We cannot be confident that there is a true difference in proportions of women with cancer between the hormone
# therapy group and the placebo group with the confidence level of 90%.

# Part d
# Calculate a 90% confidence interval for the relative risk of developing cancer whentaking hormone therapy and
# interpret this confidence interval.
# Calculate the relative risk and its confidence interval
rr.ci(c(sum(whi$Group == "Hormone" & whi$Cancer == "Yes"),
        sum(whi$Group == "Placebo" & whi$Cancer == "Yes")),
      c(sum(whi$Group == "Hormone"), sum(whi$Group == "Placebo")),
      conf.level = 0.90)
# This suggests that the risk of developing cancer is about 1.158 times higher in the hormone therapy group compared to
# the placebo group

# Part e
# Calculate a 90% confidence interval for the odds ratio of developing cancer whentaking hormone therapy and interpret
# this confidence interval
or.ci(c(sum(whi$Group == "Hormone" & whi$Cancer == "Yes"),
        sum(whi$Group == "Placebo" & whi$Cancer == "Yes")),
      c(sum(whi$Group == "Hormone"), sum(whi$Group == "Placebo")),
      conf.level = 0.90)
# This indicates that the odds of developing cancer are about 1.160 times higher in the hormone therapy group compared
# to the placebo group.

# Problem 2
# On the night of April 14, 1912, the luxury liner RMW Titanic hit an iceberg and sank in the North Atlantic Ocean.
# In the popular movie from 1997 about this disaster, first class passengers appeared to be able to get to the life
# boats, while third class passengers were kept away. Is there truth to this appearance? Was the proportion of
# passengers rescued different for each class of ticket? The data containing information about the number of people
# with each class of ticket, including crew, and whether or not the person was rescued or lost can be found in the
# titanic.csv file

# Part a
# Obtain a mosaic plot that compares the proportion of passengers rescued amongthe four ticket classes. Interpret the
# mosaic plot.
titanic <- read.csv("Homework/Homework 4/Material/titanic.csv")
titanic$Status <- factor(titanic$Status, levels = c("Lost", "Rescued"))

titanic$Ticket <- factor(titanic$Ticket, levels = c("First", "Second", "Third", "Crew"))

rescued_color <- c("Rescued" = "blue", "Lost" = "red")

mosaicplot(table(titanic$Ticket, titanic$Status), color = rescued_color, main = "Passengers Rescued by Ticket Class")
# As your class of ticket decreases, the proportion of passengers rescued decreases. This suggests that the class of
# ticket a passenger held was correlated with the likelihood of being rescued.

# Part b
# Conduct a hypothesis test to determine if the proportion of passengers rescuedwas the same across all ticket classes.
# Null Hypothesis: The proportion of passengers rescued is the same across all ticket classes.
# Alternative Hypothesis: The proportion of passengers rescued differs across at least one ticket class.
contingency_table <- table(titanic$Ticket, titanic$Status)

chi_squared_test <- chisq.test(contingency_table)
chi_squared_test

# The null hypothesis is rejected, suggesting that the proportion of passengers rescued differs across at least one
# ticket class.

# Part c
# Determine the pairwise hypothesis tests for the proportion of passengers rescued for the four ticket classes. Which
# class(es) appear to have a significantly different proportion rescued?
pairwise_tests <- list()

for (i in 1:(length(levels(titanic$Ticket)) - 1)) {
  for (j in (i + 1):length(levels(titanic$Ticket))) {
    subset_data <- titanic[titanic$Ticket %in% levels(titanic$Ticket)[c(i, j)],]

    contingency_table <- table(subset_data$Ticket, subset_data$Status)

    x_first <- contingency_table[levels(titanic$Ticket)[i], "Rescued"]
    n_first <- sum(contingency_table[levels(titanic$Ticket)[i],])

    x_second <- contingency_table[levels(titanic$Ticket)[j], "Rescued"]
    n_second <- sum(contingency_table[levels(titanic$Ticket)[j],])

    test_result <- prop.test(c(x_first, x_second), c(n_first, n_second),
                             alternative = "two.sided", correct = TRUE)

    pairwise_tests[[paste(levels(titanic$Ticket)[i], levels(titanic$Ticket)[j], sep = " vs. ")]] <- test_result
  }
}
pairwise_tests
# These results suggest that passengers in the first class generally had a higher proportion rescued compared to
# passengers in the second and third classes, and crew members had a significantly different proportion rescued
# compared to passengers in all other classes.

# Part d
# Was the movie correct: Did the proportion of passengers rescued differ among ticket classes?
# The movie was correct. The proportion of passengers rescued differed among ticket classes.

# Problem 3
# In 1996, in the General Social Survey of 1,895 adults in the United States conducted by the National Opinion Research
# Center, respondents were asked about their attitudes towards premarital sex. The question asked was When is
# premarital sex wrong? and  the  possible  answers  were Always Wrong, Almost Always Wrong, Some-times Wrong, Not
# Wrong at All. People’s attitudes about social behaviors tend to be related to other more general background variables
# about the individual. Among other questions, respondents were asked about one such variable, their religious
# affiliation. Possible answers were Catholic, Protestant, Jewish, Other, None. The data can be found in the GSS.csv
# file.

# Part a
# Calculate  the  conditional  distribution  of  attitude  towards  premarital  sex  givenreligious affiliation is
# Catholic.
gss <- read.csv("Homework/Homework 4/Material/GSS.csv")
catholic_data <- subset(gss, Religion == "Catholic")

attitude_distribution <- table(catholic_data$Wrong) / nrow(catholic_data)
attitude_distribution

# Part b
# Calculate the conditional distribution of attitude towards premarital sex given religious affiliation is Protestant.
protestant_data <- subset(gss, Religion == "Protestant")

attitude_distribution_protestant <- table(protestant_data$Wrong) / nrow(protestant_data)
attitude_distribution_protestant

# Part c
# Obtain a mosaic plot that compares the attitudes towards premarital sex among the five religious affiliation groups.
# Interpret the mosaic plot.
attitude_colors <- c("Always" = "red", "Almost Always" = "blue", "Sometimes" = "green", "Never" = "orange")
mosaicplot(table(gss$Religion, gss$Wrong), color = attitude_colors, main = "Attitudes Towards Premarital Sex by Religious Affiliation")
# The mosaic plot suggests that the distribution of attitudes towards premarital sex differs among the five religious

# Part d
# Conduct a hypothesis test to determine if attitudes towards premarital sex is thesame for all five groups.
# Null Hypothesis:
# There is no association between religious affiliation and attitudes towards premarital sex.

# Alternative Hypothesis:
# There is an association between religious affiliation and attitudes towards premarital sex.

chi_squared_test <- chisq.test(table(gss$Religion, gss$Wrong))
chi_squared_test

# The null hypothesis is rejected, suggesting that there is an association between religious affiliation and attitudes

# Part e
# In conducting the hypothesis test, you will find at least one of the cells in the table has an expected value less
# than 5. Identify the cell(s)
chi_squared_test$expected
# The cell with the expected value less than 5 is the cell with the combination of "Jewish" and "Almost Always" in the
# table.