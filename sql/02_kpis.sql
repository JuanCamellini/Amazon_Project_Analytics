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
WHERE recent_sales_approx IS NOT NULL
ORDER BY recent_sales_approx DESC
LIMIT 10;
/* Insight: Beauty & Personal Care leads the top 10 products by sales
The top 3 products have +100.000 sales in the last month, the lowest in 
the rank have +50.000. 5th and 9 are in the page 2, the 8th in the page 7
*/

-- 2. Rating, sales and count by category
SELECT 
    ROUND(AVG(rating),2) AS avg_rating,
    SUM(recent_sales_approx) AS sales_approx,
    COUNT(asin) AS product_count,
    category
FROM products_search as ps
WHERE recent_sales_approx IS NOT NULL
GROUP BY category
ORDER BY sales_approx DESC;
/* Insight: Beauty Personal Care also leads in the average rating with 4.5 but
very close are the others categories with, 4.44, 4.45 and 4.42.
Electronics ranks last in sales but second in avg reviews per product.
*/

-- 3. Impact of Discount in Prices
SELECT
    CASE 
        WHEN price_rrp IS NOT NULL THEN true
        ELSE false
    END AS has_discount,
    COUNT(*) AS product_count,
    ROUND(AVG(price_primary), 2) AS avg_price,
    ROUND(AVG(recent_sales_approx), 0)  AS avg_sales
FROM products_search
WHERE recent_sales_approx IS NOT NULL
GROUP BY CASE 
        WHEN price_rrp IS NOT NULL THEN true
        ELSE false
    END
ORDER BY has_discount;
/* Insight: There are 458 discounted prices and 480 whithout discount, regardless
the average price is similar with 46.25 for the discounted and 47.41 for the other one.
But in the average sales the not discounted ones are winning, with 400 plus in the average sales (3.480)

This is likely explained by category composition: Beauty & Personal Care — the highest 
selling category — has the lowest discount rate (27%), inflating the avg sales of 
non-discounted products. Discount alone is not a reliable predictor of sales volume
without controlling for category.
*/

-- 4. Sponsored vs. Organic Performance
SELECT    
    sponsored,
    COUNT(*) AS product_count,
    ROUND(AVG(recent_sales_approx), 0)  AS avg_sales,
    ROUND(AVG(rating),2) AS avg_rating,
    ROUND(AVG(review_count), 0) AS avg_review
FROM products_search
WHERE recent_sales_approx IS NOT NULL
GROUP BY sponsored;
/* Insight: Sponsored products are 223 and the organics are 715, the average rating is similar (4.49 vs 4.44)
But for the sponsored ones sell more (3.570 vs 3.198) and has more reviews (10.351 vs 9.298).
In general terms its convenient sponsor the products to reach more sells
*/

-- 5. Search Position vs sales
SELECT
    search_position,
    asin,
    category,
    rating,
    review_count,
    recent_sales_approx,
    page
FROM products_search
WHERE recent_sales_approx IS NOT NULL
ORDER BY search_position ASC, recent_sales_approx DESC
LIMIT 30;

---- ===================================
---- Queries with the table Products Top
---- ___________________________________

-- 1. Top products by BSR
SELECT 
    asin,
    title,



    /*
Queries sobre products_search — análisis general:

Ventas, rating y conteo por categoría #########
Top 10 productos por ventas ########
Impacto del descuento en ventas y precio ####
Sponsored vs organic performance ####
Prime vs non-prime 

Queries sobre products_top — análisis de top productos:

Top productos por BSR
Distribución de FBA vs non-FBA
Sellers más frecuentes
Marcas con mejor rating
Precio vs BSR

Estructura de 03_views.sql:
Vistas que Power BI va a consumir directamente:

vw_category_summary — KPIs por categoría
vw_top_products — productos enriquecidos listos para dashboard
vw_discount_analysis — análisis de descuentos
vw_sponsored_analysis — sponsored vs organic
*/