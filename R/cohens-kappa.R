# Required Libraries
install.packages("irr")
library(irr)

# Required Functions

# Problem 1
# In 1990, a random sample of 1,600 adults in the United States were asked whether ornot they approved of the job
# George H.W. Bush was doing as president. One month later, the same people were asked the same question.  The data are
# given in the file Bushapproval.csv

# part a
# Calculate the contingency table for the two approval ratings President Bush was doing for each time period
fileBushapproval <- read.csv("Homework/Homework 6/Material/Bushapproval.csv")
contingency_table <- table(fileBushapproval$First, fileBushapproval$Second)
contingency_table


# part b
# Use the contingency table to calculate an estimate of the proportion of adults inthe U.S. who approved of the job
# President Bush was doing for each time period
# First Period
first_period_approval <- prop.table(table(fileBushapproval$First))[2]
first_period_approval
# 55% of the adults in the U.S. approved of the job President Bush was doing during the first time period

# Second Period
second_period_approval <- prop.table(table(fileBushapproval$Second))[2]
second_period_approval
# 59% of the adults in the U.S. approved of the job President Bush was doing during the second time period

# proportion of approval for First time period
prop.table(table(fileBushapproval$First))[2]

# proportion of approval for Second time period
prop.table(table(fileBushapproval$Second))[2]

# part c
# Explain why the two estimates you calculated in part (b) are not independent from each other
# The two estimates are not independent from each other because the same individuals were asked the same question in
# the two time periods

# part d
# Use McNemar’s test to determine if the proportion of adults in the U.S. who approved of the job President Bush was
# doing is different between the two time periods.
mcnemar_test_result <- mcnemar.test(contingency_table)
mcnemar_test_result
# Null Hypothesis: The proportion of adults in the U.S. who approved of the job President Bush was doing is the same
# between the two time periods
# Alternative Hypothesis: The proportion of adults in the U.S. who approved of the job President Bush was doing is different
# p-value = 0.0001
# Test Statistic = 16.8
# Conclusion: Since the p-value is less than 0.05, we reject the null hypothesis and conclude that the proportion of adults in
# the U.S. who approved of the job President Bush was doing is different between the two time periods

# part e
# Calculate a 95% confidence interval for the difference in the proportion of adultsin the U.S. who approved of the job
# President Bush was doing between the two time periods. Interpret this confidence interval
# Interpretation: We are 95% confident that the difference in the proportion of adults in the U.S. who approved of the job
# President Bush was doing between the two time periods is between -0.009 and 0.089
total_approvals_first_period <- sum(fileBushapproval$First == "Approve")
total_approvals_second_period <- sum(fileBushapproval$Second == "Approve")
total_observations <- nrow(fileBushapproval)
conf_int_first_period <- binom.test(total_approvals_first_period, total_observations)$conf.int
conf_int_second_period <- binom.test(total_approvals_second_period, total_observations)$conf.int

conf_int_difference <- c(conf_int_first_period[1] - conf_int_second_period[2], conf_int_first_period[2] - conf_int_second_period[1])
conf_int_difference


# Problem 2
#  During the 1970’s, 80’s and 90’s, Gene Siskel and Roger Ebert worked as film critics for the Chicago Tribune and
#  Chicago Sun Times, respectively. In their syndicated TV show, At the Movies, they presented their reviews of
#  recently released movies using a Thumbs Up/Thumbs Down system. This system also allowed them to give a mixed review.
#  Their reviews for 160 movies from April 1995 through September 1996 are given in the file AttheMovies.csv in Canvas

# part a
# Calculate the contingency table of the reviews from Siskel and Ebert. Make sure to use an appropriate order for the
# categories of the two variables
at_the_movies <- read.csv("Homework/Homework 6/Material/AttheMovies.csv")
contingency_table <- table(at_the_movies$Siskel, at_the_movies$Ebert)
contingency_table

# part b
# Calculate the distribution of reviews for Siskel and the distribution of reviews for Ebert on these 160 movies. Who
# gave a higher percentage of movies a Thumbs Up review? Who have a higher percentage of movies a Thumbs Down review?

# distribution of reviews for Siskel
siskel_distribution <- prop.table(table(at_the_movies$Siskel))
siskel_distribution

# distribution of reviews for Ebert
ebert_distribution <- prop.table(table(at_the_movies$Ebert))
ebert_distribution

# part c
# Use the extension to McNemar’s test to determine if there was a difference in the distribution of reviews between the
# two critics
mcnemar_test_result <- mcnemar.test(contingency_table)
mcnemar_test_result
# Null Hypothesis: There is no difference in the distribution of reviews between the two critics
# Alternative Hypothesis: There is a difference in the distribution of reviews between the two critics
# p-value = 0.8984
# Chi-squared = 0.5913
# Conclusion: Since the p-value is greater than 0.05, we fail to reject the null hypothesis and conclude that there is no
# difference in the distribution of reviews between the two critics

# part d - Proportion of movies where reviews matched
proportion_matched <- sum(at_the_movies$Siskel == at_the_movies$Ebert) / nrow(at_the_movies)
proportion_matched

# part e - Cohen's kappa
ratings_matrix <- matrix(c(at_the_movies$Siskel, at_the_movies$Ebert), ncol = 2)
cohen_kappa <- kappa2(ratings_matrix)
cohen_kappa

# part f - weighted Cohen's kappa
weighted_cohen_kappa <- kappa2(ratings_matrix, weight = "squared")
weighted_cohen_kappa

# part g - agreement?
# Are the two critics in agreement?
# Yes, the two critics are in agreement because the proportion of movies where the reviews matched is 0.725 and the Cohen's
# kappa is 0.45

# Problem 3
#  In educational assessment, open-ended questions (called free-response questions) tend to provide more information
#  about learning than multiple choice questions. However,these open-ended questions are more difficult and time
#  consuming to grade than multiple choice questions. In an on-going project, researchers at a large
#  university are studying the accuracy of computer scored open-ended responses by comparing them to person scored
#  responses. In this example, the computer and a person scored the same 1,011 student responses to the same
#  open-ended question. Each question was scored as either a 1 = minimal understanding of concept, 2 = moderate
#  understanding of concept, or 3 = full understanding of concept. These scores can be found in the fileScores.csvin
#  Canvas.

# Part a - contingency table
scores <- read.csv("Homework/Homework 6/Material/Scores.csv")
contingency_table <- table(scores$Computer, scores$Person)
contingency_table

# part b - Proportion of scores that matched
proportion_matched <- sum(scores$Computer == scores$Person) / nrow(scores)
proportion_matched

# part c - Cohen's kappa
ratings_matrix <- matrix(c(scores$Computer, scores$Person), ncol = 2)
cohen_kappa <- kappa2(ratings_matrix)
cohen_kappa

# part d - weighted Cohen's kappa
weighted_cohen_kappa <- kappa2(ratings_matrix, weight = "squared")
weighted_cohen_kappa

# part 3 - agreement?
# Are the computer and person in agreement?
# Yes, the computer and person are in agreement because the proportion of scores that matched is 0.75 and the Cohen's kappa is 0.5