/*
===> Queries with the table Products Search
*/

-- 1.1 Top 10 products based by approximate sales
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
-- 1.2 Top 10 Products per Category by approximate sales
SELECT *
FROM (
    SELECT
        category,
        asin,
        RANK() OVER (PARTITION BY category ORDER BY recent_sales_approx DESC) AS rank_sales,
        recent_sales_approx,
        title, 
        price_primary,
        page
    FROM products_search
    WHERE recent_sales_approx IS NOT NULL 
) ranked
WHERE rank_sales <= 10
ORDER BY category, rank_sales;

/*  Insight: Beauty & Personal Care leads the top 10 products by sales
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
/*  Insight: Beauty Personal Care also leads in the average rating with 4.5 but
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
/*  Insight: There are 458 discounted prices and 480 whithout discount, regardless
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
/*  Insight: Sponsored products are 223 and the organics are 715, the average rating is similar (4.49 vs 4.44)
    But for the sponsored ones sell more (3.570 vs 3.198) and has more reviews (10.351 vs 9.298).
    In general terms its convenient sponsor the products to reach more sells
*/

-- 5. Search Position vs sales
--  The result of this query has a limitation, search_position reflects ranking within a broad category query
--  (e.g best electronics), not within specific subcategories. Products from different niches compete in the same ranking
--  making a position-to-sales correlation analysis less meaningful. */
SELECT
    category,
    CASE
        WHEN search_position <= 10  THEN '1-10'
        WHEN search_position <= 20  THEN '11-20'
        WHEN search_position <= 30  THEN '21-30'
        WHEN search_position <= 40  THEN '31-40'
        ELSE '40+'
    END AS position_range,
    ROUND(AVG(recent_sales_approx), 0) AS avg_sales,
    COUNT(*) AS product_count
FROM products_search
WHERE recent_sales_approx IS NOT NULL
AND search_position IS NOT NULL
GROUP BY category, position_range
ORDER BY category, position_range;

-- 6. Products above their average sales
SELECT 
    ps.asin,
    ps.title,
    ps.category,
    ps.recent_sales_approx,
    ROUND(cat_avg.avg_sales, 0) AS category_avg_sales
FROM products_search AS ps
JOIN (
    SELECT 
        category,
        AVG(recent_sales_approx) AS avg_sales
    FROM products_search
    WHERE recent_sales_approx IS NOT NULL
    GROUP BY category
) AS cat_avg ON ps.category = cat_avg.category
WHERE ps.recent_sales_approx > cat_avg.avg_sales
ORDER BY ps.category, ps.recent_sales_approx DESC;

---- ===================================
---- Queries with the table Products Top
---- ___________________________________

-- 1. Top products by BSR
SELECT DISTINCT asin
    asin,
    bsr_main,
    bsr_sub,
    recent_sales_approx,
    brand,
    category,
    subcategory,
    review_count,
    rating
FROM products_top
WHERE recent_sales_approx IS NOT NULL
ORDER BY bsr_main ASC, bsr_sub ASC
LIMIT 10;
/* Insight: Low BSR correlates with higher monthly sales — BSR #2 leads with 100K units.
   Top BSR products span all categories, as BSR ranks within subcategories not globally.
   High review counts (65K-144K) among top products suggest sales and social proof reinforce each other.
*/

--2. Distribution FBA vs. non-FBA
SELECT *
FROM products_top
WHERE is_fba = false;

SELECT is_fba, COUNT(*) 
FROM products_top 
GROUP BY is_fba;
/* Note: All top products (33/33) are fulfilled by Amazon (FBA).
   This suggests that FBA is a near-mandatory requirement to reach 
   top sales volume on Amazon — non-FBA sellers do not appear among 
   the best performers in this dataset.
*/

-- 3. Frecuent sellers 
SELECT
    brand,
    COUNT(*) AS product_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(recent_sales_approx), 0) AS avg_sales,
    ROUND(AVG(price_primary), 2) AS avg_price
FROM products_top
WHERE brand IS NOT NULL
GROUP BY brand
HAVING COUNT(*) > 1
ORDER BY product_count DESC, avg_sales DESC;
/* Insight: eos leads in sales volume (85K units/month at $9.98) but Nintendo generates 
   ~6x more estimated revenue ($998K vs $169K monthly) despite identical unit sales (10K).
   This highlights the difference between volume leaders and revenue leaders —
   a key distinction for marketplace strategy.
*/

-- 4. Engagment Score by products & by category
-- 4.1. Top products by engagement score (sales volume x rating)
SELECT
    asin,
    title,
    brand,
    category,
    subcategory,
    engagement_score,
    recent_sales_approx,
    rating,
    price_primary
FROM products_top
WHERE engagement_score IS NOT NULL
ORDER BY engagement_score DESC
LIMIT 10;

/* Insight: the engagment score is the multiplication of rating and monthly sales, this 
determintes the product with the best
*/
-- 4.2. Avg engagement score by category
SELECT
    category,
    ROUND(AVG(engagement_score), 0)  AS avg_engagement,
    ROUND(AVG(rating), 2)            AS avg_rating,
    ROUND(AVG(recent_sales_approx),0) AS avg_sales
FROM products_top
WHERE engagement_score IS NOT NULL
GROUP BY category
ORDER BY avg_engagement DESC;

-- 5. Category revenue estimate
WITH revenue AS (
    SELECT
        category,
        SUM(price_primary * recent_sales_approx) AS revenue_estimated
    FROM products_top
    WHERE recent_sales_approx IS NOT NULL AND price_primary IS NOT NULL
    GROUP BY category
    ORDER BY revenue_estimated DESC
)
SELECT *, RANK() OVER (ORDER BY revenue_estimated DESC) AS revenue_rank
FROM revenue
ORDER BY revenue_rank ASC;
/* Insight: Despite Beauty & Personal Care leading in sales volume across previous queries,
   Electronics generates the highest estimated monthly revenue ($14.7M) due to significantly 
   higher price points (~$80-$499 vs ~$10 Beauty).
   
   Revenue ranking: Electronics $14.7M > Beauty $10M > Home Kitchen $2.7M > Sports $606K
   
   This highlights a key distinction for sellers: high-volume categories (Beauty) 
   don't necessarily generate the most revenue — premium categories (Electronics) 
   can outperform despite lower unit sales.
*/
