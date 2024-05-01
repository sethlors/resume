# HW 2 Template
# Necessary Libraries
library(plyr)
library(ggplot2)

# Required Functions
powerprop_test <- function(n, p0, pa, alternative, alpha) {
  diff <- p0 - pa
  adiff <- abs(diff)
  sep0 <- sqrt(p0 * (1 - p0) / n)
  sepa <- sqrt(pa * (1 - pa) / n)
  probone <- 1 - alpha
  probtwo <- 1 - alpha / 2

  switch(alternative,
         two_sided =
           2 * (1 - pnorm((adiff + qnorm(probtwo) * sep0) / sepa)),
         greater = 1 - pnorm((diff + qnorm(probone) * sep0) / sepa),
         less = pnorm((diff - qnorm(probone) * sep0) / sepa))
}

npowerprop_test <- function(p0, pa, alternative, alpha, power) {

  diff <- p0 - pa
  sep0 <- sqrt(p0 * (1 - p0))
  sepa <- sqrt(pa * (1 - pa))
  probone <- 1 - alpha
  probtwo <- 1 - alpha / 2
  powerone <- power
  powertwo <- power / 2

  switch(alternative,
         two_sided = ceiling((qnorm(powertwo) * sepa
           + qnorm(probtwo) * sep0)^2 / diff^2),
         greater = ceiling((qnorm(powerone) * sepa
           + qnorm(probone) * sep0)^2 / diff^2),
         less = ceiling((qnorm(powerone) * sepa
           + qnorm(probone) * sep0)^2 / diff^2))
}


# Problem 1
# According to the company’s website, the proportion of Green milk chocolate M&Msproduced is 0.16.  Let the sample
# proportion p^ be the proportion of Green milk choco-late M&Ms in a large bag of 100 of the candies

# Part a
# Determine the sampling distribution of the sample proportion p^
# The sampling distribution of the sample proportion p^ is approximately normal with a mean of 0.16.
shape <- "Normal"
mean <- 0.16
variance <- 0.16 * (1 - 0.16) / 100
standard_deviation <- sqrt(0.16 * (1 - 0.16) / 100)
shape
mean
variance
standard_deviation

# Part b
# Find the probability a large bag of 100 of the candies would have more than 20% green M&Ms.
1 - pnorm(0.20, 0.16, sqrt(0.16 * (1 - 0.16) / 100)) # 0.1376168

# Part c
# Find the probability a large bag of 100 of the candies would have less than 10% green M&Ms.
pnorm(0.10, 0.16, sqrt(0.16 * (1 - 0.16) / 100)) # 0.05085347

# Problem 2
# Many dog owners teach their dogs to “shake hands”. Your friend has a dog and you notice over time that the dog seems
# to favor his right paw in doing this trick. You decide to test the accuracy of your perception. For 15 consecutive
# times the trick is done in the same way with the same person, you find that the dog extended his right paw 10 times.
dogs <- read.csv("Module 1/Homework 2/Dogs.csv")

# Part a
# Use R to give the summary table and bar graph of the sample data. You can usethe data fileDogs.csv.
# Summary Table
dog_count <- count(dogs, var = "Paw")
dog_table <- mutate(dog_count, prop = freq / sum(dog_count[2]))
dog_table <- rbind(dog_table, data.frame(Paw = 'Total', t(colSums(dog_table[, -1]))))
dog_table

# Bar Graph
ggplot(dogs, aes(x = Paw)) +
  geom_bar(fill = "blue") +
  ylim(0, 15) +
  labs(x = "Paw",
       y = "Number of Times",
       title = "Paw Preference of Dog") +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6)))


# Part b
# Use R to conduct a binomial exact test for determining whether the dog favors his right paw when “shaking hands”.
# Make sure to include the null and alternative hypotheses, test statistic, p-value, and conclusion.
# Null Hypothesis: The dog does not favor his right paw when "shaking hands"
# Alternative Hypothesis: The dog favors his right paw when "shaking hands"
# Test Statistic: 10
# P-Value: 0.3769531
# Conclusion: There is not enough evidence to suggest that the dog favors his right paw when "shaking hands"
binom.test(10, 15, 0.5, alternative = "greater")

# Part c
# Use R to find the rejection region for this test.  Use α = 0.05
qbinom(0.95, 15, 0.5)

# Part d
# Based on the rejection region you found in part (c), what is the observed Type Ierror rate for this test?
1 - pbinom(9, 15, 0.5)

# Part e
# Based on the rejection region you found in part (c), what is the power of your hypothesis test if the dog favors his
# right paw with probability 0.6
powerprop_test(15, 0.5, 0.6, "greater", 0.05)
# Probability is 0.75
powerprop_test(15, 0.5, 0.75, "greater", 0.05)
# Probability is 0.9
powerprop_test(15, 0.5, 0.9, "greater", 0.05)

# Problem 3
# A company’s old antacid formula provided relief from heartburn for 75% of the people who used it. The company
# develops a new formula in hopes of improving on the proportion of users who obtain relief. In a random
# sample of 400 people, 312 had reliefof their heartburn.
antacid <- read.csv("Module 1/Homework 2/Antacid.csv")

# Part a
# Use R to give the summary table and bar graph of the sample data. You can usethe data file Antacid.csv.
# Summary Table
antacid_count <- count(antacid, var = "Relief")
antacid_table <- mutate(antacid_count, prop = freq / sum(antacid_count[2]))
antacid_table <- rbind(antacid_table, data.frame(Relief = 'Total', t(colSums(antacid_table[, -1]))))
antacid_table

# Bar Graph
ggplot(antacid, aes(x = Relief)) +
  geom_bar(fill = "blue") +
  ylim(0, 400) +
  labs(x = "Relief",
       y = "Number of People",
       title = "Relief of Heartburn from Antacid") +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6)))

# Part b
# Explain why you can use the score test for this hypothesis test.
# The score test can be used for this hypothesis test because the sample size is large


# Part c
# Use R to conduct a score test for determining whether the new formula is better than the old formula. Make sure to
# include the null and alternative hypotheses, test statistic, p-value, and conclusion.
# Null Hypothesis: The new formula is not better than the old formula
# Alternative Hypothesis: The new formula is better than the old formula
# Test Statistic: 3.5
# P-Value: 0.000232
# Conclusion: There is enough evidence to suggest that the new formula is better than the old formula
prop.test(312, 400, 0.75, alternative = "greater")

# Part d
# Use R to calculate the power of this score test if the true proportion of users who obtain relief from their
# heartburn with the new formula is either p = 0.8, 0.85, or 0.9 and α = 0.01, 0.05, and 0.1.
# Alpha = 0.01
one <- powerprop_test(400, 0.75, 0.8, "greater", 0.01)
two <- powerprop_test(400, 0.75, 0.85, "greater", 0.01)
three <- powerprop_test(400, 0.75, 0.9, "greater", 0.01)
# Alpha = 0.05
four <- powerprop_test(400, 0.75, 0.8, "greater", 0.05)
five <- powerprop_test(400, 0.75, 0.85, "greater", 0.05)
six <- powerprop_test(400, 0.75, 0.9, "greater", 0.05)
# Alpha = 0.1
seven <- powerprop_test(400, 0.75, 0.8, "greater", 0.1)
eight <- powerprop_test(400, 0.75, 0.85, "greater", 0.1)
nine <- powerprop_test(400, 0.75, 0.9, "greater", 0.1)

one
two
three
four
five
six
seven
eight
nine

# Put all 9 results into a table
power_table <- data.frame(Alpha = c(0.01, 0.01, 0.01, 0.05, 0.05, 0.05, 0.1, 0.1, 0.1),
                          Power = c(one, two, three, four, five, six, seven, eight, nine))
power_table

# Part e
# Discuss the effect of the value of the population proportionpand the value ofαon the power of this hypothesis test.
# Effect of alpha on power of test = As alpha increases, the power of the test increases
# Effect of p on power of test = As p increases, the power of the test increases
# In conclusion, the power of this hypothesis test would increase if the true population proportion of people who find relief with the new formula is significantly different from 75% and/or if a higher significance level is used. However, using a higher significance level also increases the risk of a Type I error.


# Part f
# After the above analysis, the company decided to switch production to the new antacid formula. After several years
# in production, they found the new formula provided relief to 80% of the people who used it. Suppose the company
# would like to test another formula in the future. What sample size will they need to useto have a power of 0.9 to
# detect an improvement in the proportion of users who obtain relief of 0.05 if α = 0.05.

npowerprop_test(0.75, 0.8, "greater", 0.05, 0.9)
npowerprop_test(0.75, 0.85, "greater", 0.05, 0.9)
npowerprop_test(0.75, 0.9, "greater", 0.05, 0.9)
npowerprop_test(0.75, 0.95, "greater", 0.05, 0.9)
npowerprop_test(0.75, 1, "greater", 0.05, 0.9)