
-- 01_schema.sql
-- Creates the database schema for the Amazon Analytics project

CREATE TABLE products_search (
    asin                VARCHAR(20),
    title               TEXT,
    rating              NUMERIC(3,1),
    review_count        INTEGER,
    sponsored           BOOLEAN,
    is_prime            BOOLEAN,
    search_position     INTEGER,
    recent_sales        VARCHAR(50),
    price_primary       NUMERIC(10,2),
    price_rrp           NUMERIC(10,2),
    category            VARCHAR(50),
    page                INTEGER,
    recent_sales_approx INTEGER,
    has_discount        BOOLEAN,
    discount_pct        NUMERIC(5,1)
);

CREATE TABLE products_top (
    asin                VARCHAR(20),
    title               TEXT,
    rating              NUMERIC(3,1),
    review_count        INTEGER,
    sponsored           BOOLEAN,
    is_prime            BOOLEAN,
    search_position     INTEGER,
    recent_sales        VARCHAR(50),
    price_primary       NUMERIC(10,2),
    price_rrp           NUMERIC(10,2),
    category            VARCHAR(50),
    page                INTEGER,
    recent_sales_approx INTEGER,
    brand               VARCHAR(100),
    subcategory         VARCHAR(100),
    image               TEXT,
    is_fba              BOOLEAN,
    bsr_main            INTEGER,
    bsr_sub             INTEGER,
    seller_name         VARCHAR(100),
    discount_pct        NUMERIC(5,1),
    engagement_score    NUMERIC(10,1),
    has_discount        BOOLEAN
);
-- To load data, use pgAdmin Import/Export on each table
-- Source files: data/processed/products_search_clean.csv
--               data/processed/products_top_clean.csv
SELECT COUNT(*) FROM products_search;
SELECT COUNT(*) FROM products_top;

SELECT * FROM products_search LIMIT 5;
SELECT * FROM products_top LIMIT 5;
