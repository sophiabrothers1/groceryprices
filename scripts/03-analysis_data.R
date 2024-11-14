#### Preamble ####
# Purpose: create csv for analysis data
# Author: Sophia Brothers
# Date: November 14th, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The 'DBI', 'RSQLite', and 'here' packages must be installed
# Any other information needed? Make sure you are in the `groceryprices` rproj

# Load libraries
library(DBI)
library(RSQLite)
library(here)

# Connect to the SQLite database
con <- dbConnect(SQLite(), dbname = here("data", "raw_data", "hammer-2-processed.sqlite"))

sql_file_path <- here("scripts", "02-query.sql")
sql_query <- paste(suppressWarnings(readLines(sql_file_path)), collapse = " ")

# Execute the SQL query from the file
query_result <- dbGetQuery(con, sql_query)

# Write to a CSV file
write.csv(query_result, here("data", "analysis_data", "average_prices_by_vendor.csv"), row.names = FALSE)

# Close the connection
dbDisconnect(con)
