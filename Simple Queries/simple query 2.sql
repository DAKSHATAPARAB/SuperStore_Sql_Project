-- simple queries

-- 5.Show records where quantity is greater than 5
select  order_id, order_quantity from store_tb where order_quantity > 5;

-- 6. Find all orders from the West region.
select  * from store_tb where region = 'West';

-- 7.Display orders sorted by profit from lowest to highest.
select order_id, profit from store_tb order by profit ASC;

-- 8. Show customers sorted alphabetically.
SELECT Customer_Name
FROM store_tb
ORDER BY Customer_Name ASC;

-- 9. Show first 20 rows from the dataset.
SELECT *
FROM store_tb
LIMIT 20;

-- 10. Display 10 products with lowest profit.
select product_name, profit 
from store_tb
order by profit ASC
LIMIT 10;

-- 11. Display orders where quantity is greater than or equal to 10.
select order_id,  order_quantity from store_tb where  order_quantity >= 10;

-- 12. Show records where shipping cost is greater than 50.
select * from store_tb where  shipping_cost> 50; 

-- 13. Show Furniture products with profit greater than 100.
select * from store_tb where product_category='Furniture' and profit > 100;

-- 14. Find orders from East OR South region.
select * from store_tb where region = 'East' OR region = 'South';

-- 15. Find all product names containing the word “Chair”.
select * from store_tb where  product_name LIKE '%chair%';

-- 16. Show customer names where second letter is “a”.
select customer_name from store_tb where customer_name LIKE '_a%';
-- 17. Find all orders where sales are greater than 5000.
select * from store_tb where sales > 5000;
-- 18. Display products sorted by discount in descending order.
select product_name, discount from store_tb order by discount DESC;
-- 19. Show orders where profit is not equal to 0.
SELECT *
FROM store_tb
WHERE Profit != 0;
-- 20. Display orders where sales are greater than 1000 AND discount is less than 0.2.
SELECT *
FROM store_tb
WHERE Sales > 1000
  AND Discount < 0.2;