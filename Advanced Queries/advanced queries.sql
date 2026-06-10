

select * from store_tb;
-- advanced queries
-- 1. Display customers whose total sales are higher than the average customer sales.

SELECT Customer_Name,
       SUM(Sales) AS Total_Sales
FROM store_tb
GROUP BY Customer_Name
HAVING SUM(Sales) >
(
    SELECT AVG(Customer_Total_Sales)
    FROM
    (
        SELECT SUM(Sales) AS Customer_Total_Sales
        FROM store_tb
        GROUP BY Customer_Name
    ) AS Avg_Sales
);
-- 2. Show regions whose total sales are greater than the company’s average regional sales.
SELECT Region,
       SUM(Sales) AS Total_Regional_Sales
FROM store_tb
GROUP BY Region
HAVING SUM(Sales) >
(
    SELECT AVG(Regional_Sales)
    FROM
    (
        SELECT SUM(Sales) AS Regional_Sales
        FROM store_tb
        GROUP BY Region
    ) AS Avg_Regional_Sales
);
-- 3. Display sub-categories whose total quantity sold is greater than the average quantity of their category.
SELECT product_sub_category,
       SUM(order_quantity) AS Total_Quantity
FROM store_tb s1
GROUP BY product_category, product_sub_category
HAVING SUM(order_quantity) >
(
    SELECT AVG(Category_Quantity)
    FROM
    (
        SELECT SUM(order_quantity) AS Category_Quantity
        FROM store_tb s2
        WHERE s2.product_category = s1.product_category
        GROUP BY product_sub_category
    ) AS Avg_Qty
);
-- 4. Find products whose sales are higher than the average sales within their category.
SELECT Product_Name,
       product_category,
       Sales
FROM store_tb s1
WHERE Sales >
(
    SELECT AVG(Sales)
    FROM store_tb s2
    WHERE s1.product_category = s2.product_category
);
-- 5. Rank products based on sales in descending order.
SELECT Product_Name,
       Sales,
       RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank
FROM store_tb;
-- 6. Find the top 3 highest sales products in each category.
SELECT *
FROM
(
    SELECT Product_Name,
           product_category,
           Sales,
           RANK() OVER
           (
               PARTITION BY product_category
               ORDER BY Sales DESC
           ) AS Product_Rank
    FROM store_tb
) ranked_products
WHERE Product_Rank <= 3;
-- 7. Find highest profit order within each region.

SELECT *
FROM
(
    SELECT Order_ID,
           Region,
           Profit,
           RANK() OVER
           (
               PARTITION BY Region
               ORDER BY Profit DESC
           ) AS Profit_Rank
    FROM store_tb
) ranked_profit
WHERE Profit_Rank = 1;
-- 8. Find lowest shipping cost order within each ship mode.

SELECT *
FROM
(
    SELECT Order_ID,
           Ship_Mode,
           Shipping_Cost,
           RANK() OVER
           (
               PARTITION BY Ship_Mode
               ORDER BY Shipping_Cost ASC
           ) AS Shipping_Rank
    FROM store_tb
) ranked_shipping
WHERE Shipping_Rank = 1;
-- 9. Find products contributing to top 10% sales.
SELECT Product_Name,
       Sales
FROM store_tb
WHERE Sales >=
(
    SELECT PERCENTILE_CONT(0.9)
    WITHIN GROUP (ORDER BY Sales)
    FROM store_tb
);
-- 10. Find second highest sales value in the dataset.
SELECT MAX(Sales) AS Second_Highest_Sales
FROM store_tb
WHERE Sales <
(
    SELECT MAX(Sales)
    FROM store_tb
);

-- 11. Calculate percentage of discounted orders.
SELECT 
(
    COUNT(CASE WHEN Discount > 0 THEN 1 END) * 100.0
    / COUNT(*)
) AS Discounted_Order_Percentage
FROM store_tb;
-- 12. Find profit margin for each sub-category.
SELECT product_sub_category,
       SUM(Profit) AS Total_Profit,
       SUM(Sales) AS Total_Sales,
       (SUM(Profit) / SUM(Sales)) * 100 AS Profit_Margin_Percentage
FROM store_tb
GROUP BY product_sub_category;
-- 13. Find the month with maximum profit.
SELECT EXTRACT(MONTH FROM Order_Date) AS Profit_Month,
       SUM(Profit) AS Total_Profit
FROM store_tb
GROUP BY EXTRACT(MONTH FROM Order_Date)
ORDER BY Total_Profit DESC
LIMIT 1;
-- 14. Compare current month sales with previous month sales.
WITH monthly_sales AS
(
    SELECT EXTRACT(MONTH FROM Order_Date) AS Month_No,
           SUM(Sales) AS Total_Sales
    FROM store_tb
    GROUP BY EXTRACT(MONTH FROM Order_Date)
)

SELECT Month_No,
       Total_Sales,
       LAG(Total_Sales) OVER (ORDER BY Month_No) AS Previous_Month_Sales
FROM monthly_sales;

-- 15. Create a CTE to calculate average discount by category.
WITH category_discount AS
(
    SELECT product_category,
           AVG(Discount) AS Average_Discount
    FROM store_tb
    GROUP BY product_category
)

SELECT *
FROM category_discount;
-- 16. Create a CTE for monthly sales trends.
WITH monthly_sales AS
(
    SELECT EXTRACT(MONTH FROM Order_Date) AS Month_No,
           SUM(Sales) AS Total_Sales
    FROM store_tb
    GROUP BY EXTRACT(MONTH FROM Order_Date)
)

SELECT *
FROM monthly_sales
ORDER BY Month_No;
-- 17. Find the customer who generated the highest total profit.
SELECT Customer_Name,
       SUM(Profit) AS Total_Profit
FROM store_tb
GROUP BY Customer_Name
ORDER BY Total_Profit DESC
LIMIT 1;
-- 18. Show customers whose profit is greater than the average profit of their region.
SELECT Customer_Name,
       Region,
       Profit
FROM store_tb s1
WHERE Profit >
(
    SELECT AVG(Profit)
    FROM store_tb s2
    WHERE s1.Region = s2.Region
);
-- 19. Calculate cumulative sales for each month.
WITH monthly_sales AS
(
    SELECT EXTRACT(MONTH FROM Order_Date) AS Month_No,
           SUM(Sales) AS Total_Sales
    FROM store_tb
    GROUP BY EXTRACT(MONTH FROM Order_Date)
)

SELECT Month_No,
       Total_Sales,
       SUM(Total_Sales)
       OVER (ORDER BY Month_No) AS Cumulative_Sales
FROM monthly_sales;
-- 20. Show running total of profit within each region.

SELECT Region,
       Order_ID,
       Profit,
       SUM(Profit)
       OVER
       (
           PARTITION BY Region
           ORDER BY Order_ID
       ) AS Running_Total_Profit
FROM store_tb;