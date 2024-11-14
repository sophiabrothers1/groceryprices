# Load libraries
library(DBI)
library(RSQLite)
library(here)

# Connect to the SQLite database
con <- dbConnect(SQLite(), dbname = here("data", "raw_data", "hammer-2-processed.sqlite"))

# Run the SQL query and store the results in a data frame
query_result <- dbGetQuery(con, "
WITH product_vendor_count AS (
    SELECT 
        p.product_name,
        COUNT(DISTINCT p.vendor) AS vendor_count
    FROM 
        product p
    JOIN 
        raw r ON p.id = r.product_id
    GROUP BY 
        p.product_name
    HAVING 
        COUNT(DISTINCT p.vendor) >= 3
),
ranked_products AS (
    SELECT
        p.vendor,
        p.product_name,
        r.current_price,
        RANK() OVER (PARTITION BY p.product_name ORDER BY r.current_price DESC) AS price_rank
    FROM 
        product p
    JOIN 
        raw r ON p.id = r.product_id
    JOIN 
        product_vendor_count pvc ON p.product_name = pvc.product_name
)
SELECT
    vendor,
    COUNT(*) AS most_expensive_count
FROM
    ranked_products
WHERE
    price_rank = 1
GROUP BY
    vendor
ORDER BY
    most_expensive_count DESC;
")

# Write to a CSV file
write.csv(query_result, here("data", "analysis_data", "average_prices_by_vendor.csv"), row.names = FALSE)

# Close the connection
dbDisconnect(con)
