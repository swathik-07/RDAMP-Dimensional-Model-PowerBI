USE ace_superstore;

CREATE OR REPLACE VIEW vw_clean_sales AS
SELECT
    TRIM(order_id) AS order_id,
    order_date,
    TRIM(customer_id) AS customer_id,
    TRIM(product_id) AS product_id,
    TRIM(city) AS city,
    TRIM(postal_code) AS postal_code,
    TRIM(region) AS region,
    TRIM(country) AS country,
    TRIM(category) AS category,
    TRIM(sub_category) AS sub_category,
    TRIM(segment) AS segment,
    TRIM(order_mode) AS order_mode,
    quantity,
    total_sales,
    total_cost,
    profit,
    discount_amount,
    profit_margin
FROM staging_sales
WHERE 
    order_id IS NOT NULL AND
    customer_id IS NOT NULL AND
    product_id IS NOT NULL AND
    order_date IS NOT NULL;



INSERT INTO fact_sales (
    order_id,
    customer_id,
    product_id,
    location_id,
    date_id,
    category_id,
    segment_id,
    order_mode_id,
    quantity,
    total_sales,
    total_cost,
    profit,
    discount_amount,
    profit_margin
)
SELECT 
    TRIM(s.order_id),

    dc.customer_id,
    dp.product_id,
    dl.location_id,
    dd.date_id,
    dcat.category_id,
    ds.segment_id,
    dom.order_mode_id,

    s.quantity,
    s.total_sales,
    s.total_cost,
    s.profit,
    s.discount_amount,
    s.profit_margin

FROM staging_sales s

-- JOIN dim_customer using customer_code
JOIN dim_customer dc
  ON TRIM(s.customer_id) = dc.customer_code

-- JOIN dim_product using product_id
JOIN dim_product dp
  ON TRIM(s.product_id) = dp.product_id

-- JOIN dim_location using full location match
JOIN dim_location dl
  ON TRIM(s.city) = dl.city
 AND TRIM(s.postal_code) = dl.postal_code
 AND TRIM(s.region) = dl.region
 AND TRIM(s.country) = dl.country

-- JOIN dim_date using order_date
JOIN dim_date dd
  ON s.order_date = dd.order_date

-- JOIN dim_category using category + sub_category
JOIN dim_category dcat
  ON TRIM(s.category) = dcat.category_name
 AND TRIM(s.sub_category) = dcat.sub_category

-- JOIN dim_segment using segment name
JOIN dim_segment ds
  ON TRIM(s.segment) = ds.segment_name

-- JOIN dim_order_mode
JOIN dim_order_mode dom
  ON TRIM(s.order_mode) = dom.order_mode

-- filter out invalid records
WHERE s.total_sales IS NOT NULL
  AND s.total_cost IS NOT NULL
  AND s.discount_amount IS NOT NULL
  AND s.profit IS NOT NULL
  AND s.quantity IS NOT NULL;

SELECT COUNT(*) FROM fact_sales;
