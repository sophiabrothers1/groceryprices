#### Preamble ####
# Purpose: Simulate grocery price data
# Author: Bruce Zhang
# Date: November 14th, 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The 'dplyr' and 'tibble' packages must be installed
# Any other information needed? Make sure you are in the `groceryprices` rproj

#### Workspace setup ####
library(dplyr)
library(tibble)

#### Simulate data ####
set.seed(21)

# Define vendors based on the sample file
vendors <- c("Metro", "Loblaws", "NoFrills", "Voila", "TandT", "Walmart", "Costco", "Sobeys", "FreshCo", "Superstore")

# Set the number of observations to simulate
num_vendors <- length(vendors)

# Simulate the most expensive count data
simulated_data <- tibble(
  vendor = vendors,
  most_expensive_count = round(runif(num_vendors, min = 50, max = 30000))
)

# Display the simulated data
print(simulated_data)
