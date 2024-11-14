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
    