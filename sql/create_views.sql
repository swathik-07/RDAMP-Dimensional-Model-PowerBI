-- vw_product_seasonality

CREATE OR REPLACE VIEW vw_product_seasonality AS
SELECT 
    dp.product_id,
    dp.product_name,
    dd.year,
    dd.month,
    dd.quarter,
    SUM(fs.quantity) AS total_quantity_sold,
    SUM(fs.total_sales) AS total_sales,
    SUM(fs.profit) AS total_profit,
    ROUND(AVG(fs.profit_margin), 2) AS avg_profit_margin
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY 
    dp.product_id, dp.product_name, dd.year, dd.month, dd.quarter
ORDER BY 
    dp.product_id, dd.year, dd.month;

SELECT VERSION();

-- vw_discount_impact_analysis

CREATE OR REPLACE VIEW vw_discount_impact_analysis AS
SELECT 
    c.category_name,
    c.sub_category,
    ROUND(AVG(fs.discount_amount), 2) AS avg_discount_amount,
    ROUND(AVG(fs.discount_amount / NULLIF(fs.total_sales, 0)) * 100, 2) AS avg_discount_pct,
    ROUND(AVG(fs.profit), 2) AS avg_profit,
    ROUND(AVG(fs.profit_margin), 2) AS avg_profit_margin,
    COUNT(fs.sales_id) AS sales_count
FROM fact_sales fs
JOIN dim_category c ON fs.category_id = c.category_id
GROUP BY 
    c.category_name,
    c.sub_category;

-- vw_customer_order_patterns

CREATE OR REPLACE VIEW vw_customer_order_patterns AS
SELECT 
    s.segment_name,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    COUNT(DISTINCT fs.customer_id) AS unique_customers,
    ROUND(SUM(fs.total_sales) / COUNT(DISTINCT fs.order_id), 2) AS avg_order_value,
    ROUND(SUM(fs.profit) / COUNT(DISTINCT fs.customer_id), 2) AS avg_profit_per_customer,
    ROUND(AVG(fs.profit_margin), 2) AS avg_profit_margin
FROM fact_sales fs
JOIN dim_segment s ON fs.segment_id = s.segment_id
GROUP BY s.segment_name;


-- vw_channel_margin_report

CREATE OR REPLACE VIEW vw_channel_margin_report AS
SELECT 
    om.order_mode AS sales_channel,
    COUNT(DISTINCT fs.order_id) AS total_orders,
    SUM(fs.quantity) AS total_quantity,
    ROUND(SUM(fs.total_sales), 2) AS total_sales,
    ROUND(SUM(fs.total_cost), 2) AS total_cost,
    ROUND(SUM(fs.profit), 2) AS total_profit,
    ROUND(AVG(fs.profit_margin), 2) AS avg_profit_margin,
    ROUND(SUM(fs.profit) / NULLIF(SUM(fs.total_sales), 0) * 100, 2) AS profit_percentage
FROM fact_sales fs
JOIN dim_order_mode om ON fs.order_mode_id = om.order_mode_id
GROUP BY om.order_mode;


-- vw_region_category_rankings

CREATE OR REPLACE VIEW vw_region_category_rankings AS
SELECT 
    dl.region,
    dc.category_name,
    ROUND(SUM(fs.profit), 2) AS total_profit,
    ROUND(SUM(fs.total_sales), 2) AS total_sales,
    ROUND(SUM(fs.profit) / NULLIF(SUM(fs.total_sales), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (PARTITION BY dl.region ORDER BY SUM(fs.profit) / NULLIF(SUM(fs.total_sales), 0) DESC) AS category_rank
FROM fact_sales fs
JOIN dim_location dl ON fs.location_id = dl.location_id
JOIN dim_category dc ON fs.category_id = dc.category_id
GROUP BY dl.region, dc.category_name;

