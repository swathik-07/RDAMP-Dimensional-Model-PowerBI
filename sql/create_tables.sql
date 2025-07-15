CREATE DATABASE ace_superstore;
USE ace_superstore;

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dim_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100) NOT NULL
);

CREATE TABLE dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);

CREATE TABLE dim_segment (
    segment_id INT PRIMARY KEY AUTO_INCREMENT,
    segment_name VARCHAR(100) NOT NULL
);

CREATE TABLE dim_location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    region VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
);

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    year INT NOT NULL,
    quarter VARCHAR(10) NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL
);

CREATE TABLE dim_order_mode (
    order_mode_id INT PRIMARY KEY AUTO_INCREMENT,
    order_mode VARCHAR(50) NOT NULL  
);

CREATE TABLE fact_sales (
    sales_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(100) NOT NULL,

    customer_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    location_id INT NOT NULL,
    date_id INT NOT NULL,
    category_id INT NOT NULL,
    segment_id INT NOT NULL,
    order_mode_id INT NOT NULL,

    quantity INT NOT NULL,
    total_sales DECIMAL(12, 2) NOT NULL,
    total_cost DECIMAL(12, 2) NOT NULL,
    profit DECIMAL(12, 2) NOT NULL,
    discount_amount DECIMAL(12, 2) NOT NULL,
    profit_margin DECIMAL(5, 2) NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
    FOREIGN KEY (segment_id) REFERENCES dim_segment(segment_id),
    FOREIGN KEY (order_mode_id) REFERENCES dim_order_mode(order_mode_id)
);



