-- simple queries

-- 1. Display only Customer Name and Sales columns.
Select customer_name , sales from store_tb;

-- 2.Show all products under the Technology category.
select  product_sub_category, product_category from store_tb where  product_category = 'Technology';

-- 3.Display unique product categories.
SELECT DISTINCT product_category
FROM store_tb;

-- 4.Show unique order priorities.
SELECT DISTINCT Order_Priority
FROM store_tb;