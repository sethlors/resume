# HW 3 Template
# Necessary Libraries
library(plyr)
library(ggplot2)

# Required Functions
prop.ci <- function(y, n, type, conf.level) {
  phat <- y / n
  alpha <- 1 - conf.level
  z <- qnorm(1 - alpha / 2)
  newy <- y + z^2 / 2
  newn <- n + z^2
  newphat <- newy / newn


  if (type == "normal") {
    lowerci <- phat - z * sqrt(phat * (1 - phat) / n)
    upperci <- phat + z * sqrt(phat * (1 - phat) / n)
  }

  else if (type == "score") {
    lowerci <- (phat + (1 / (2 * n)) * z^2 - z * sqrt(phat * (1 - phat) / n + z^2 / (4 * n^2))) / (1 + (1 / n) * z^2)
    upperci <- (phat +
      (1 / (2 * n)) * z^2 +
      z * sqrt(phat * (1 - phat) / n + z^2 / (4 * n^2))) / (1 + (1 / n) * z^2)
  }

  else {
    lowerci <- newphat - z * sqrt(newphat * (1 - newphat) / newn)
    upperci <- newphat + z * sqrt(newphat * (1 - newphat) / newn)
  }
  cat(lowerci, upperci, "\n")
}

nprop.ci <- function(p, m, conf.level) {
  alpha <- 1 - conf.level
  z <- qnorm(1 - alpha / 2)
  ceiling((z / m)^2 * p * (1 - p))
}

# Data
floor13 <- read.csv("Homework/Homework 3/floor13.csv")
zodiac <- read.csv("Homework/Homework 3/zodiac.csv")

# Problem 1
# Many people are superstitious about the number 13. But does triskaidekaphobia (fear of the number 13) have economic
# implications for large high-rise hotels? A USA Today/Gallup poll conducted February 9-11, 2007 asked 1,006 randomly
# selected people 18 years old and older in telephone interviews “Suppose you checked into a hotel and were given a
# room on the thirteenth floor. Would this bother you or not?” Their responses are given in the file floor13.csv
# in Canvas

# Part a
# Use R to give the summary table and bar graph of the sample data
# Summary Table
floor13_summary <- ddply(floor13, .(Bothered), summarise, count = length(Bothered))
floor13_summary

# Bar Graph
floor13_bar_graph <- ggplot(floor13, aes(x = Bothered)) +
  geom_bar() +
  labs(title = "Bothered by Staying on the 13th Floor", x = "Bothered", y = "Count")
floor13_bar_graph

# Part b
# Our category of interest is being bothered by staying on the 13th floor.  Use R to calculate a 95% confidence interval
# for the population proportion p using the normal approximation method
prop.ci(137, 1006, "rto", 0.95)

# Part c
# Give the interpretation of the 95% confidence interval you calculated in part (b) in context
# The 95% confidence interval for the population proportion of people who would be bothered by staying on the 13th floor is between 11.6% and 15.2%

# Part d
# Use R to calculate a 95% confidence interval for the population proportion p using Wilson’s score method. Compare
# this interval to the one you calculated in part(b)
prop.ci(137, 1006, "score", 0.95)
# Comparing the two intervals, the Wilson’s score method interval is wider than the normal approximation method interval

# Part e
# If the USA Today/Gallup Poll were conducted again using this question, what sample size would be needed in order to
# guarantee a 90% confidence interval would have a margin of error of no more than 2%?
nprop.ci(0.137, 0.02, 0.90)

# Problem 2
# According to a Gallup poll, of 1,019 randomly selected adults aged 18 or older in the United States, 662 believe that
# global warming is more a result of human actions than natural causes


# Part a
# Describe the population proportion of interest p in words
# The population proportion of interest p is the proportion of adults in the United States who believe that global warming is more a result of human actions than natural causes

# Part b
# Give the value of the sample proportion p-hat
# The value of the sample proportion p-hat is 662/1019 = 0.6497

# Part c
# Calculate a 95% confidence interval for the population proportion of interest using Wilson’s score method
prop.ci(662, 1019, "score", 0.95)

# Part d
# Give the interpretation of the 95% confidence interval you calculated in part(c) in context
# The 95% confidence interval for the population proportion of adults in the United States who believe that global warming is more a result of human actions than natural causes is (0.620 0.678)

# Part e
# Gallup is planning to conduct another poll on global warming. They would like to have a 95% confidence interval
# with a margin of error of no more than 2.5%. What sample size do they need to obtain this margin of error?
nprop.ci(0.6497, 0.025, 0.95)

# Problem 3
# In lecture, we discussed issues with the confidence interval for the population proportion p. Unlike confidence
# intervals for other parameters, several methods have been developed for calculating this confidence interval.
# For confidence intervals, you want to have a coverage rate, the percentage of confidence intervals containing the
# true population parameter from a large number of samples, close to the stated confidence level for the confidence
# intervals. For example, if you generate 100,000 samples from a population and calculate a 95% confidence interval
# from each sample’s data, you want approximately 95,000 of the 100,000 confidence intervals (or 95%) to contain the
# population parameter.
# In this problem, we will study the coverage rate of 95% confidence intervals for the two methods from lecture: the
# normal approximation and Wilson’s score method. Since the binomial distribution depends on the sample size n and the
# population proportion p, I simulated 100,000 samples from the binomial distribution with each combination of three
# values of sample size n = 25, 500, 1000 and three values of probability of success p = 0.05, 0.25, 0.5, for a total
# of 9 conditions. For each of the 100,000 simulated samples, I determined whether or not the value of p is located
# within the confidence interval and used this information to calculate the coverage rate. The table below contains the
# coverage rates for each of these 9 trials for the two methods

#       |     Normal Approximation    |   Wilson’s Score Method   |
#   p   | n = 25   n = 500   n = 1000 | n = 25  n = 500  n = 1000 |
#  0.05 |  72.133%  93.283%  94.091%  | 96.664%  94.938%  95.027% |
#  0.25 |  89.397%  94.312%  94.559%  | 93.853%  94.386%  94.813% |
#  0.50 |  95.695%  94.598%  94.645%  | 95.661%  94.620%  94.642% |

# Part a
# Does the Normal approximation method for calculating the confidence interval for p have any coverage rates different than the expected 95%?
# If so, for which combinations of n and p?
# The normal approximation method for calculating the confidence interval for p has coverage rates different than the expected 95% for the following combinations of n and p: n = 25, p = 0.05; n = 25, p = 0.25; n = 25, p = 0.50

# Part b
# Does Wilson’s score method for calculating the confidence interval for p have any coverage rates different than the expected 95%? If so, for which combinations of n and p?
# Wilson’s score method for calculating the confidence interval for p has coverage rates different than the expected 95% for the following combinations of n and p: n = 25, p = 0.05

# Part c
# In this simulation, I included two values of p below 0.5, Would we gain any new information by adding the values of p = 0.75 and p = 0.95 to the simulation? Explain  your answer.
# We would not gain any new information by adding the values of p = 0.75 and p = 0.95 to the simulation. The coverage rates for the normal approximation method and Wilson’s score method for calculating the confidence interval for p are all close to the expected 95% for the values of p = 0.5. Since the values of p = 0.75 and p = 0.95 are greater than p = 0.5, we would expect the coverage rates to be close to the expected 95% for these values of p as well.

# Problem 4
#  In astrology, people are assigned one of 12 zodiac signs based on their birthday. For example, my birthday is May 26
#  and so I am assigned the zodiac sign Gemini, which is for people born on May 21 through June 20. Does your zodiac
#  sign have any additional meaning for, influence on, or ability to predict your life path? In one small study,
#  Fortune magazine collected the zodiac signs of 265 heads of the largest 400 companies. The data are given in the
#  file zodiac.csv. Based on these data, does it appear that some zodiac signs are more likely to be represented in
#  heads of these types of companies than others?

# Part a
# Use R to give the summary table and bar graph of the sample data
# Summary Table
zodiac_summary <- ddply(zodiac, .(Sign), summarise, count = length(Sign))
zodiac_summary

# Bar Graph
zodiac_bar_graph <- ggplot(zodiac, aes(x = Sign)) +
  geom_bar() +
  labs(title = "Zodiac Signs of Heads of the Largest 400 Companies", x = "Zodiac Sign", y = "Count")
zodiac_bar_graph

# Part b
# Give the null and alternative hypotheses for answering the question posed. Assume each zodiac sign covers an equal
# number of birthdays in the year
# The null hypothesis is that the zodiac signs are equally likely to be represented in heads of the largest 400 companies. The alternative hypothesis is that the zodiac signs are not equally likely to be represented in heads of the largest 400 companies.

# Part c
# Calculate the expected number of births in each zodiac sign under the null hypothesis.
# The expected number of births in each zodiac sign under the null hypothesis is 265/12 = 22.08333

# Part d
# Calculate the contribution of the category Scorpio to the test statistic X^2. Only calculate this value for the
# category Scorpio, not for all the other categories.
# The contribution of the category Scorpio to the test statistic X^2 is (22 - 22.08333)^2 / 22.08333 = 0.000329

# Part e
# Determine the value of the test statistic X^2 for this hypothesis test
# The value of the test statistic X^2 for this hypothesis test is 11.08

# Part f
# What is the number of degrees of freedom for the test statisticX2?
# The number of degrees of freedom for the test statistic X^2 is 11 - 1 = 10

# Part g
# Determine the p-value for this hypothesis test
1 - pchisq(11.08, 10)

# Part h
# Write a conclusion for the hypothesis test
# Since the p-value for the hypothesis test is less than 0.05, we reject the null hypothesis. There is evidence to suggest that the zodiac signs are not equally likely to be represented in heads of the largest 400 companies.
