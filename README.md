# RDAMP-Dimensional-Model-PowerBI

## Sales Analytics Dashboard - Power BI

### Overview

This project delivers an interactive Power BI dashboard powered by a dimensional data model sourced from a MySQL database. The dashboard is designed to provide insights into product seasonality, discount impact on profitability, customer segmentation, and regional category performance.

---

## Dimensional Schema Overview

<img width="1486" height="1154" alt="schema_diagram" src="https://github.com/user-attachments/assets/536c8162-6522-4556-812b-62ff7d454c02" />

Our star schema is composed of the following:

### Fact Table:
- **fact_sales**: This central table stores transactional sales records at the most granular level. Each row represents a unique sales transaction, capturing:

- Sales Metrics: quantity, total_sales, total_cost, profit, profit_margin, discount_amount
- Foreign Keys: Links to relevant dimension tables such as product, customer, date, category, location, segment, and order mode
- Identifiers: Includes primary identifiers like sales_id and order_id

### Dimension Tables:
- **dim_product**:
Provides descriptive information about products sold. Fields include
(product_id, product_name). 
Helps in analyzing sales and profitability at the product level.
- **dim_category**:
Contains hierarchical product classification to group and analyze sales across (category_name and sub_category). Useful for comparative performance analysis within and across categories
- **dim_customer** (used in extended views): Houses customer-level attributes such as customer_id, customer_name, segment_id. Enables customer-centric analytics like profitability and buying patterns.
- **dim_segment**: Defines customer segmentation based on behavior or demographics (segment_id, segment_name). Used in advanced customer performance breakdowns (e.g., by order value or profit).
- **dim_date**: Serves as a temporal reference for all transactions(date_id, year, month, quarter) .Enables trend analysis and time-based aggregation.
- **dim_location**: Captures the geographical context of each sale (location_id, region, country, city). Supports regional performance comparisons and rankings.
- **dim_order_mode**: Describes the channel through which an order was placed (order_mode_id, order_mode (e.g., Online, Retail)). Vital for analyzing sales and margin differences across distribution channels.

---

## Power BI Connection Steps

- Open Power BI Desktop.
- Click Home > Get Data > More > Database > MySQL database.
- Enter your server address and database name.
- Authenticate using your MySQL credentials.
- Select and load the SQL views listed above.

---

## About the Dashboard View


1. Product Seasonality Trends
-Type: Matrix with conditional formatting
-Data Source: vw_product_seasonality
-Description: Displays monthly sales (total_sales) for each product. The matrix is conditionally formatted to highlight peak and low sales months.
-Insights: Products like Acoustic Guitar show high sales in February and May, indicating seasonal buying trends.

2. Discount vs. Profit Analysis
- Type: Scatter Plot
- Data Source: vw_discount_impact_analysis
- Description: Analyzes the correlation between avg_discount_pct and avg_profit across product categories.
- Insight: Categories such as Apps and Art Supplies appear scattered across discount levels, while some categories with lower discounts maintain higher profitability.

3. Average Order Value by Channel and Segment
- Type: Combo Chart (Bar + Line)
- Data Sources: vw_customer_order_patterns + vw_channel_margin_report (combined)
- X-axis: segment_name
- Bar: avg_order_value
- Line: avg_profit_margin
- Insight: Segments like Bicycles and Home Security show the highest AOV, while segments like Shoes and Smart Home maintain lower AOV but varying margins.

4. Top 10 Customers by Profit Contribution
- Type: Horizontal Bar Chart
- Data Source: Extended from fact_sales with aggregated profit per customer
- Y-axis: customer_code
- X-axis: Sum of profit
- Insight: Customer MN066756 leads with a profit contribution of over 35K, followed by others in the 15K–25K range.

5. Category Ranking by Region
- Type: Stacked Horizontal Bar Chart
- Data Source: vw_region_category_rankings
- Description: Visualizes sum of category_rank for each category, broken down by region.
- Insight: Electronics, Garden, and Furniture consistently rank highly across regions like East Midlands, Scotland, and South East.
