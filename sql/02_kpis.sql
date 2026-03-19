/*
===> Queries with the table Products Search
*/

-- 1. Query 10 top products based by approximate sales
SELECT 
    asin,
    title,
    recent_sales_approx,
    price_primary as price,
    category,
    page
FROM products_search as ps
ORDER BY recent_sales_approx DESC
LIMIT 10;

-- 2. Rating, sales and count by category


/*
===> Queries with the table Products Top
*/

-- 1. Top products by BSR
SELECT 
    asin,
    title