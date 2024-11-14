#### Preamble ####
# Purpose: Test the simulated grocery price data
# Author: Bruce Zhang
# Date: November 14th, 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The 'dplyr', 'tibble', and 'ggplot2' packages must be installed
# Any other information needed? Make sure you are in the `groceryprices` rproj

#### Workspace setup ####
library(dplyr)
library(tibble)
library(ggplot2)

#### Simulate data ####
set.seed(21)

# Define vendors based on the sample file
vendors <- c("Metro", "Loblaws", "NoFrills", "Voila", "TandT", "Walmart", "Costco", "Sobeys", "FreshCo", "Superstore")

# Set the number of observations per vendor
num_vendors <- length(vendors)
observations_per_vendor <- 30

# Generate simulated dataset
simulated_data <- tibble(
  vendor = rep(vendors, each = observations_per_vendor),
  most_expensive_count = round(rnorm(num_vendors * observations_per_vendor, mean = 15000, sd = 5000))
)

# Display first few rows of the simulated data
print(head(simulated_data))

#### Exploratory Data Analysis ####
# Summary statistics by vendor
summary_stats <- simulated_data %>%
  group_by(vendor) %>%
  summarise(
    mean_count = mean(most_expensive_count),
    sd_count = sd(most_expensive_count),
    count = n()
  )
print(summary_stats)

# Visualize data distribution
ggplot(simulated_data, aes(x = vendor, y = most_expensive_count)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Distribution of Most Expensive Counts by Vendor", y = "Count", x = "Vendor")

#### Statistical Tests ####

# One-way ANOVA to compare means between different vendors
anova_result <- aov(most_expensive_count ~ vendor, data = simulated_data)
summary(anova_result)

# Pairwise t-tests with p-value adjustment
pairwise_result <- pairwise.t.test(
  simulated_data$most_expensive_count,
  simulated_data$vendor,
  p.adjust.method = "bonferroni"
)
print(pairwise_result)

