#### Preamble ####
# Purpose: test analysis data
# Author: Sophia Brothers
# Date: November 14th, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The 'DBI', 'testthat', 'RSQLite', and 'here' packages must be installed
# Any other information needed? Make sure you are in the `groceryprices` rproj


# Load libraries
library(DBI)
library(RSQLite)
library(here)
library(testthat)

# Define needed paths
db_path <- here("data", "raw_data", "hammer-2-processed.sqlite")
sql_file_path <- here("scripts", "02-query.sql")

# Test that the SQL query runs
test_that("SQL query returns expected results", {
  # Connect to the SQLite database
  con <- dbConnect(SQLite(), dbname = db_path)
  
  # Load query from file
  sql_query <- paste(suppressWarnings(readLines(sql_file_path)), collapse = " ")
  
  # Execute the query
  query_result <- dbGetQuery(con, sql_query)
  
  # Disconnect from database
  dbDisconnect(con)
  
  # Check that query_result is a data frame
  expect_s3_class(query_result, "data.frame")
  
  # Check that the result has expected columns
  expect_true(all(c("vendor", "most_expensive_count") %in% colnames(query_result)))
  
  # Check that there are rows in the result
  expect_gt(nrow(query_result), 0)
  
})
