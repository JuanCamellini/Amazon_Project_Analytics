-- 03_views.sql
-- Views created for Power BI consumption
-- Each view corresponds to a specific dashboard visual

-- =============================================
-- SECTION 1: products_search — General Dashboard
-- =============================================
/*
Para products_search — dashboard general:

vw_category_summary — KPIs por categoría (ventas, rating, precio, conteo)
vw_discount_analysis — productos con y sin descuento por categoría
vw_sponsored_analysis — sponsored vs organic por categoría
vw_price_ranges — distribución de productos por rango de precio

Para products_top — dashboard específico:

vw_top_products — productos enriquecidos con brand, bsr, revenue estimado
vw_brand_performance — métricas por marca (las que tienen más de 1 producto)
vw_revenue_by_category — revenue estimado por categoría con rank
*/

-- 1. Category KPIs
CREATE OR REPLACE VIEW vw_category_summary AS
SELECT 
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(price_primary), 2) AS avg_price,
    SUM(recent_sales_approx) AS total_sales,
    ROUND(AVG(rating),2) AS avg_rating,
    ROUND(AVG(review_count),0) AS avg_review,
    SUM(CASE WHEN price_rrp IS NOT NULL THEN 1 ELSE 0 END) AS discounted_products,
    SUM(CASE WHEN sponsored THEN 1 ELSE 0 END)    AS sponsored_products
FROM products_search
WHERE recent_sales_approx IS NOT NULL
GROUP BY category
ORDER BY total_sales DESC;

SELECT * FROM vw_category_summary;

-- 2. Discount analysis by categories
CREATE OR REPLACE VIEW vw_discount_analysis AS
SELECT 
    category as category,
    CASE
        WHEN price_rrp IS NOT NULL THEN true
        ELSE false
    END AS has_discount,
    ROUND(AVG(recent_sales_approx),0) AS avg_sales,
    COUNT(*) AS product_count,
    ROUND(AVG(price_primary), 2) AS avg_price,
    ROUND(AVG(review_count),0 ) AS avg_review
FROM products_search
GROUP BY category, CASE
        WHEN price_rrp IS NOT NULL THEN true
        ELSE false
    END
ORDER BY category, has_discount;

SELECT * FROM vw_discount_analysis;

-- 3. Sponsored vs organic
DROP VIEW IF EXISTS vw_sponsored_analysis;
CREATE OR REPLACE VIEW vw_sponsored_analysis AS
SELECT
    category,
    sponsored,
    COUNT(*) AS product_count,
    ROUND(AVG(recent_sales_approx), 0)  AS avg_sales,
    ROUND(AVG(rating),2) AS avg_rating,
    ROUND(AVG(review_count), 0) AS avg_review
FROM products_search
WHERE recent_sales_approx IS NOT NULL
GROUP BY category, sponsored
ORDER BY category, sponsored;

SELECT * FROM vw_sponsored_analysis;

-- 4. Price ranges
CREATE OR REPLACE VIEW vw_price_ranges AS
SELECT
    category,
    CASE
        WHEN price_primary < 25  THEN '$0 - $25'
        WHEN price_primary < 50  THEN '$25 - $50'
        WHEN price_primary < 100 THEN '$50 - $100'
        WHEN price_primary < 250 THEN '+$100 - $250'
        ELSE '+$250'
    END AS price_range,
    COUNT (*) AS product_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(recent_sales_approx), 0) AS avg_sales
FROM products_search
WHERE price_primary IS NOT NULL
GROUP BY category, CASE
        WHEN price_primary < 25  THEN '$0 - $25'
        WHEN price_primary < 50  THEN '$25 - $50'
        WHEN price_primary < 100 THEN '$50 - $100'
        WHEN price_primary < 250 THEN '+$100 - $250'
        ELSE '+$250'
    END
ORDER BY category, price_range;

SELECT * FROM vw_price_ranges;

-- =============================================
-- SECTION 2: products_top — Top Products Dashboard
-- =============================================

-- 5. Top products enriched
DROP VIEW IF EXISTS vw_top_products;
CREATE OR REPLACE VIEW vw_top_products AS
SELECT
    (price_primary * recent_sales_approx) AS revenue_estimated,
    *
FROM products_top
ORDER BY revenue_estimated DESC;

SELECT * FROM vw_top_products;

-- 6. Brand performance
DROP VIEW IF EXISTS IF EXISTS vw_brand_performance;
CREATE OR REPLACE VIEW vw_brand_performance AS
SELECT
    brand,
    COUNT(*) AS product_count,
    ROUND(AVG(recent_sales_approx),0) AS avg_sales,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(review_count),0) AS avg_reviews,
    ROUND(AVG(price_primary), 2) AS avg_price,
    SUM(price_primary * recent_sales_approx) AS revenue_estimated
FROM products_top 
WHERE brand IS NOT NULL
GROUP BY brand
HAVING COUNT(brand) > 1
ORDER BY revenue_estimated DESC;

SELECT * FROM vw_brand_performance;

-- 7. Revenue by category
DROP VIEW IF EXISTS vw_revenue_by_category;
CREATE OR REPLACE VIEW vw_revenue_by_category AS
SELECT
    category,
    SUM(price_primary * recent_sales_approx) AS revenue_estimated,
    ROUND(AVG(engagement_score),0) AS avg_engagement,
    RANK() OVER (ORDER BY SUM(price_primary * recent_sales_approx) DESC) AS revenue_rank,
    ROUND(
        SUM(price_primary * recent_sales_approx) * 100.0 / 
        SUM(SUM(price_primary * recent_sales_approx)) OVER (), 1
        ) AS revenue_pct
FROM products_top
GROUP BY category;

SELECT * FROM vw_revenue_by_category;
