



CREATE TABLE store_tb (
    row_id SERIAL,
    order_id INT,
    order_date DATE,
    order_priority VARCHAR(20),
    order_quantity INT,
    sales NUMERIC(10,2),
    discount NUMERIC(5,2),
    ship_mode VARCHAR(50),
    profit NUMERIC(10,2),
    unit_price NUMERIC(10,2),
    shipping_cost NUMERIC(10,2),
    customer_name VARCHAR(100),
    province VARCHAR(100),
    region VARCHAR(100),
    customer_segment VARCHAR(50),
    product_category VARCHAR(100),
    product_sub_category VARCHAR(100),
    product_name TEXT,
    product_container VARCHAR(50),
    product_base_margin NUMERIC(5,2),
    ship_date DATE
);

select * from store_tb;

