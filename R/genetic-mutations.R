# HW 1 Template
# Necessary Libraries
library(plyr)
library(ggplot2)

# Problem 1
# Read in the data set
survey_data <- read.csv(file.choose(), header = T)

# Variable 1 - Eye Color
eye_color <- survey_data$EyeColor

# Set levels for Eye Color variable
eye_color <- factor(eye_color, levels = c("Blue", "Hazel", "Green", "Brown", "Other"))

# Summary Table
eyecolor_count <- count(survey_data, var = 'EyeColor')
eyecolor_table <- mutate(eyecolor_count, prop = freq / sum(eyecolor_count[2]))
eyecolor_table <- rbind(eyecolor_table, data.frame(EyeColor = 'Total', t(colSums(eyecolor_table[, -1]))))
eyecolor_table

# Bar Graph
ggplot(survey_data, aes(x = eye_color)) +
  geom_bar(fill = "blue") +
  ylim(0, 275) +
  labs(x = "Eye Color",
       y = "Number of Students",
       title = "Eye Colors of STAT 101 Students") +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6)))

# Variable 2 - Hair Color
hair_color <- survey_data$HairColor

# Set levels for Hair Color variable
hair_color <- factor(hair_color, levels = c("Blonde", "Brown", "Black", "Red", "Other"))

# Summary Table
hair_color_count <- count(survey_data, var = 'HairColor')
hair_color_table <- mutate(hair_color_count, prop = freq / sum(hair_color_count[2]))
hair_color_table <- rbind(hair_color_table, data.frame(HairColor = 'Total', t(colSums(hair_color_table[, -1]))))

hair_color_table

# Bar Graph
ggplot(survey_data, aes(x = hair_color)) +
  geom_bar(fill = "blue") +
  ylim(0, 400) +
  labs(x = "Hair Color",
       y = "Number of Students",
       title = "Hair Colors of STAT 101 Students") +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6)))

# Variable 3 - Year in School
year_in_school <- survey_data$YearinSchool

# Set levels for Year in School variable
year_in_school <- factor(year_in_school, levels = c("Freshman", "Sophomore", "Junior", "Senior", "Other"))

# Summary Table
year_in_school_count <- count(survey_data, var = 'year_in_school')
year_in_school_table <- mutate(year_in_school_count, prop = freq / sum(year_in_school_count[2]))
year_in_school_table <- rbind(year_in_school_table, data.frame(year_in_school = 'Total',
                                                               t(colSums(year_in_school_table[, -1]))))

year_in_school_table

# Bar Graph
ggplot(survey_data, aes(x = year_in_school)) +
  geom_bar(fill = "blue") +
  ylim(0, 275) +
  labs(x = "Year in School",
       y = "Number of Students",
       title = "Year in School of STAT 101 Students") +
  theme_bw() +
  theme(axis.title.y = element_text(size = rel(1.4)),
        axis.title.x = element_text(size = rel(1.4)),
        axis.text.x = element_text(size = rel(1.2)),
        axis.text.y = element_text(size = rel(1.2)),
        plot.title = element_text(hjust = 0.5, size = rel(1.6)))

# Problem 2

# Part a
two_n <- 40 # number of members
two_p <- 0.05 # probability of genetic mutation

# Part b
# Probability that at least 1 person in the sample of 40 has the genetic mutation
1 - dbinom(0, two_n, two_p)

# Part c
# Probabilty that no more than 3 people in the sample of 40 has the genetic mutation
pbinom(3, two_n, two_p)

# Part d
# Mean number of people with the genetic mutation in the sample of 40 people
two_mean <- two_n * two_p
two_mean

# Part e
# Variance and Standard Deviation of the number of people with the genetic mutation
two_variance <- two_n * two_p * (1 - two_p)
two_sd <- sqrt(two_variance)
two_variance
two_sd

# Part f
# Graph of the distribution of the number of people with the genetic mutation in the sample of 40 people
two_x <- 0:40
two_y <- dbinom(two_x, two_n, two_p)
plot(two_x, two_y, type = "h", lwd = 3, col = "blue", main = "Distribution of Number of People with Genetic Mutation",
     xlab = "Number of People with Genetic Mutation", ylab = "Probability") # The shape of the distribution is skewed right.

# Problem 3

# Part a
three_n <- 40 # number of cocker spaniels
three_p <- 0.3 # probability of having anemia

# Part b
# Probability that at least 13 of the dogs in the sample of 40 will have anemia
1 - pbinom(12, three_n, three_p)

# Part c
# Probability that no more than 8 dogs in the sample of 40 will have anemia
pbinom(8, three_n, three_p)

# Part d
# Mean number of dogs with anemia in the sample of 40 dogs
three_mean <- three_n * three_p
three_mean

# Part e
# Variance and Standard Deviation of the number of dogs with anemia in the sample of 40 dogs
three_variance <- three_n * three_p * (1 - three_p)
three_sd <- sqrt(three_variance)
three_variance
three_sd

# Part f
# Graph of the distribution of the number of dogs with anemia in the sample of 40 dogs
three_x <- 0:40
three_y <- dbinom(three_x, three_n, three_p)
plot(three_x, three_y, type = "h", lwd = 3, col = "blue", main = "Distribution of Number of Dogs with Anemia",
     xlab = "Number of Dogs with Anemia", ylab = "Probability") # The shape of the distribution is skewed right.

# Problem 4

# Part a
player_a_wins <- 0.4 # probability of player A winning a game
player_b_wins <- 0.35 # probability of player B winning a game
draw <- 0.25 # probability of a draw

prob <- c(player_a_wins, player_b_wins, draw)
y <- c(7, 2, 3)


# Player A wins 7 games, Player B wins 2 games, and 3 games are ties, with 12 games played in total
dmultinom(y, 12, prob)

# Part b
# Expected number of games A would win and the expected number of games B would win if they played 12 games
expected_a <- player_a_wins * 12
expected_b <- player_b_wins * 12
expected_a
expected_b

# Part c
# Find the variance of the number of games Player A would win and the variance of the number of games PLayer B would win if the two plaeyrs playe 12 games
variance_a <- 12 * player_a_wins * (1 - player_a_wins)
variance_b <- 12 * player_b_wins * (1 - player_b_wins)
variance_a
variance_b

# Part d
# Find the correlation of the number of games won between Player A and Player B
correlation <- draw / sqrt(variance_a * variance_b)
correlation

