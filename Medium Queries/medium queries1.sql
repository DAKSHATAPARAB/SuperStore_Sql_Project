
select * from store_tb;

-- medium level queries
-- 1.Calculate total sales for each product category.

SELECT product_category,
       SUM(Sales) AS Total_Sales
FROM store_tb
GROUP BY product_category;

-- 2.Show total quantity sold for each sub-category.

SELECT product_sub_category,
       SUM(order_quantity) AS Total_Quantity
FROM store_tb
GROUP BY product_sub_category;

-- 3.Show regions sorted by total profit in descending order.
SELECT Region,
       SUM(Profit) AS Total_Profit
FROM store_tb
GROUP BY Region
ORDER BY Total_Profit DESC;
-- 4.Find top 5 sub-categories by total quantity sold.
SELECT product_sub_category,
       SUM(order_quantity) AS Total_Quantity
FROM store_tb
GROUP BY product_sub_category
ORDER BY Total_Quantity DESC
LIMIT 5;
-- 5.Find the average discount given across all orders.
SELECT AVG(Discount) AS Average_Discount
FROM store_tb;
-- 6.Count total number of orders in each region.

SELECT Region,
       COUNT(Order_ID) AS Total_Orders
FROM store_t
GROUP BY Region;
-- 7.Show categories where total sales are greater than 100000.
-- 8.Find ship modes where total shipping cost is greater than 5000.
-- 9.Find length of each product name.
-- 10.Remove extra spaces from customer names using TRIM.
