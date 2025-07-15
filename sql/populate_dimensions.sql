
CREATE TABLE staging_sales (
  order_id VARCHAR(50),
  order_date DATE,
  order_mode VARCHAR(50),
  customer_id VARCHAR(50),
  city VARCHAR(100),
  postal_code VARCHAR(20),
  product_id VARCHAR(50),
  product_name VARCHAR(255),
  category VARCHAR(100),
  sub_category VARCHAR(100),
  sales DECIMAL(10,2),
  cost_price DECIMAL(10,2),
  quantity INT,
  discount DECIMAL(5,2),
  region VARCHAR(100),
  country VARCHAR(100),
  total_sales DECIMAL(12,2),
  total_cost DECIMAL(12,2),
  discount_amount DECIMAL(12,2),
  profit DECIMAL(12,2),
  profit_margin DECIMAL(5,2),
  segment VARCHAR(100)
);

INSERT INTO dim_customer (customer_code)
SELECT DISTINCT TRIM(customer_id)
FROM staging_sales;

INSERT INTO dim_category (category_name, sub_category)
SELECT DISTINCT TRIM(category), TRIM(sub_category)
FROM staging_sales
WHERE category IS NOT NULL AND sub_category IS NOT NULL;

INSERT INTO dim_segment (segment_name)
SELECT DISTINCT TRIM(segment)
FROM staging_sales
WHERE segment IS NOT NULL;

INSERT INTO dim_order_mode (order_mode)
SELECT DISTINCT TRIM(order_mode)
FROM staging_sales
WHERE order_mode IS NOT NULL;

INSERT INTO dim_location (city, postal_code, region, country)
SELECT DISTINCT 
    TRIM(city),
    TRIM(postal_code),
    TRIM(region),
    TRIM(country)
FROM staging_sales
WHERE city IS NOT NULL 
  AND postal_code IS NOT NULL 
  AND region IS NOT NULL 
  AND country IS NOT NULL;

INSERT INTO dim_product (product_id, product_name, category_id)
SELECT DISTINCT 
    TRIM(s.product_id),
    TRIM(s.product_name),
    c.category_id
FROM staging_sales s
JOIN dim_category c 
  ON TRIM(s.category) = c.category_name 
 AND TRIM(s.sub_category) = c.sub_category
WHERE s.product_id IS NOT NULL 
  AND s.product_name IS NOT NULL
  AND s.category IS NOT NULL 
  AND s.sub_category IS NOT NULL;

INSERT INTO dim_date (order_date, year, quarter, month, day, day_of_week)
SELECT DISTINCT
    order_date,
    YEAR(order_date),
    CONCAT('Q', QUARTER(order_date)),
    MONTH(order_date),
    DAY(order_date),
    DAYNAME(order_date)
FROM staging_sales
WHERE order_date IS NOT NULL;




