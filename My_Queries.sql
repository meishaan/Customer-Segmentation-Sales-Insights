CREATE DATABASE sales_db; 
USE sales_db;

-- Table Creation

CREATE TABLE sales_data (
    sales_year INT,
    sales_month VARCHAR(20),
    supplier_name VARCHAR(255),
    product_code VARCHAR(50),
    product_description TEXT,
    product_type VARCHAR(100),
    retail_sales INT,
    retail_transfers INT,
    warehouse_sales INT
);

-- data was imported using a csv file

-- OPERATIONS

-- 1 Checking the overall range of sales values in retail and warehouse  
SELECT  
    MIN(retail_sales) AS min_retail_sales,  
    MAX(retail_sales) AS max_retail_sales,  
    AVG(retail_sales) AS avg_retail_sales,  
    MIN(warehouse_sales) AS min_warehouse_sales,  
    MAX(warehouse_sales) AS max_warehouse_sales,  
    AVG(warehouse_sales) AS avg_warehouse_sales  
FROM sales_data;

-- 2 Investigating negative sales values  
SELECT *  
FROM sales_data  
WHERE retail_sales < 0 OR warehouse_sales < 0;

-- 3 Checking how many negative values exist in retail and warehouse sales  
SELECT  
    COUNT(*) AS negative_sales_count,  
    SUM(CASE WHEN retail_sales < 0 THEN 1 ELSE 0 END) AS negative_retail_sales,  
    SUM(CASE WHEN warehouse_sales < 0 THEN 1 ELSE 0 END) AS negative_warehouse_sales  
FROM sales_data;

-- 4️ Checking if negative values are concentrated in specific months  
SELECT  
    sales_year, sales_month,  
    COUNT(*) AS negative_sales_count  
FROM sales_data  
WHERE retail_sales < 0 OR warehouse_sales < 0  
GROUP BY sales_year, sales_month  
ORDER BY sales_year, sales_month;

-- 5️ Checking for duplicate product records  
SELECT product_code, COUNT(*)  
FROM sales_data  
GROUP BY product_code  
HAVING COUNT(*) > 1;

-- 6️ Checking for missing supplier names  
SELECT *  
FROM sales_data  
WHERE supplier_name IS NULL;

-- 7️ Identifying best-selling products / worst selling products 
    -- best selling
SELECT product_code, product_description, SUM(retail_sales) AS total_sales  
FROM sales_data  
GROUP BY product_code, product_description  
ORDER BY total_sales DESC limit 10;

    -- worst selling
SELECT product_code, product_description, SUM(retail_sales) AS total_sales  
FROM sales_data  
GROUP BY product_code, product_description  
ORDER BY total_sales ASC limit 10;


-- 8️ Identifying slow-moving inventory (high warehouse stock but low sales)  
SELECT product_code, product_description, warehouse_sales, retail_sales  
FROM sales_data  
WHERE warehouse_sales > 5000 AND retail_sales < 100  
ORDER BY warehouse_sales DESC;

-- 9 Generating a month-wise sales summary report  
SELECT  
    sales_year, sales_month,  
    SUM(retail_sales) AS total_retail_sales,  
    SUM(warehouse_sales) AS total_warehouse_stock,  
    COUNT(CASE WHEN retail_sales < 0 THEN 1 END) AS negative_sales_count  
FROM sales_data  
GROUP BY sales_year, sales_month  
ORDER BY sales_year, sales_month;


-- for exporting data with no negative values
SELECT * FROM sales_data 
WHERE retail_sales >= 0 AND warehouse_sales >= 0;  -- Ensures no negative values
