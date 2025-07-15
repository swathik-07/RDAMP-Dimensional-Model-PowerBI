-- Top 10 best-selling products by total profit
-- Shows most profitable products by combining sales and profit metrics
SELECT 
    dp.product_name,
    SUM(fs.total_sales) AS total_sales,
    SUM(fs.profit) AS total_profit
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY dp.product_name
ORDER BY total_profit DESC
LIMIT 10;

-- Monthly total sales trend for the latest year in data
SELECT 
    dd.year,
    dd.month,
    SUM(fs.total_sales) AS monthly_sales
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
WHERE dd.year = (SELECT MAX(year) FROM dim_date)
GROUP BY dd.year, dd.month
ORDER BY dd.year, dd.month;

-- Region-wise Category Performance
-- Compares product categories by region
SELECT 
    dl.region,
    dc.category_name,
    SUM(fs.total_sales) AS total_sales,
    SUM(fs.profit) AS total_profit
FROM fact_sales fs
JOIN dim_location dl ON fs.location_id = dl.location_id
JOIN dim_category dc ON fs.category_id = dc.category_id
GROUP BY dl.region, dc.category_name
ORDER BY dl.region, total_profit DESC;

-- Profit Margin by Customer Segment
-- Compare average profit margin across customer segments, how different segments contribute to margins and profitability
SELECT 
    ds.segment_name,
    ROUND(AVG(fs.profit_margin), 2) AS avg_profit_margin,
    ROUND(SUM(fs.profit), 2) AS total_profit,
    COUNT(DISTINCT fs.customer_id) AS total_customers
FROM fact_sales fs
JOIN dim_segment ds ON fs.segment_id = ds.segment_id
GROUP BY ds.segment_name
ORDER BY avg_profit_margin DESC;

-- Medium Discount, Low-Profit Products
--  analyze medium discount and low profit combos
SELECT 
    dp.product_name,
    fs.discount_amount,
    fs.total_sales,
    fs.profit
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
WHERE fs.discount_amount > 5
  AND fs.profit < 50
ORDER BY fs.discount_amount DESC;
