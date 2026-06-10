-- store procedure/ Function
select * from store_tb;
-- 1. Region Wise Sales Function
CREATE OR REPLACE FUNCTION GetSalesByRegion(p_region VARCHAR)

RETURNS TABLE (
    region VARCHAR,
    totalsales NUMERIC
)

AS $$

BEGIN

RETURN QUERY

SELECT 
    store_tb.region,
    SUM(store_tb.sales) AS totalsales

FROM store_tb

WHERE store_tb.region = p_region

GROUP BY store_tb.region;

END;

$$ LANGUAGE plpgsql;


SELECT * FROM GetSalesByRegion('West');

-- 2. Function 2 — Top Profitable Products

CREATE OR REPLACE FUNCTION TopProfitableProducts()

RETURNS TABLE (
    product_name TEXT,
    totalprofit NUMERIC
)

AS $$

BEGIN

RETURN QUERY

SELECT 
    store_tb.product_name,
    SUM(store_tb.profit) AS totalprofit

FROM store_tb

GROUP BY store_tb.product_name

ORDER BY totalprofit DESC

LIMIT 10;

END;

$$ LANGUAGE plpgsql;


SELECT * FROM TopProfitableProducts();

-- 3. Category Wise Sales

CREATE OR REPLACE FUNCTION CategoryWiseSales()

RETURNS TABLE (
    product_category VARCHAR,
    totalsales NUMERIC
)

AS $$

BEGIN

RETURN QUERY

SELECT 
    store_tb.product_category,
    SUM(store_tb.sales) AS totalsales

FROM store_tb

GROUP BY store_tb.product_category

ORDER BY totalsales DESC;

END;

$$ LANGUAGE plpgsql;

select * from CategoryWiseSales();

-- 4. Customer Order Count

CREATE OR REPLACE FUNCTION CustomerOrderCount(p_customer VARCHAR)

RETURNS TABLE (
    customer_name VARCHAR,
    totalorders BIGINT
)

AS $$

BEGIN

RETURN QUERY

SELECT 
    store_tb.customer_name,
    COUNT(store_tb.order_id) AS totalorders

FROM store_tb

WHERE store_tb.customer_name = p_customer

GROUP BY store_tb.customer_name;

END;

$$ LANGUAGE plpgsql;

SELECT * FROM CustomerOrderCount('John Doe');

-- 5. Loss Making Products
CREATE OR REPLACE FUNCTION LossMakingProducts()

RETURNS TABLE (
    product_name TEXT,
    totalloss NUMERIC
)

AS $$

BEGIN

RETURN QUERY

SELECT 
    store_tb.product_name,
    SUM(store_tb.profit) AS totalloss

FROM store_tb

GROUP BY store_tb.product_name

HAVING SUM(store_tb.profit) < 0

ORDER BY totalloss;

END;


$$ LANGUAGE plpgsql;


select * from LossMakingProducts();

-------------------------------------------------
-- VIEW
------------------------------------------------
-- VIEW 1 — Profitable Orders
CREATE VIEW profitable_orders AS

SELECT
    order_id,
    customer_name,
    product_name,
    sales,
    profit

FROM store_tb

WHERE profit > 0;

SELECT * FROM profitable_orders;

-- VIEW 2 — Region Sales Summary

CREATE VIEW region_sales_summary AS

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit

FROM store_tb

GROUP BY region;

SELECT * FROM region_sales_summary;

-- VIEW 3 — Loss Products

CREATE VIEW loss_products AS

SELECT
    product_name,
    SUM(profit) AS total_loss

FROM store_tb

GROUP BY product_name

HAVING SUM(profit) < 0;

SELECT * FROM loss_products;

----------------------------------------------------------------
-- Triggers
----------------------------------------------------------------
-- TRIGGER 1 — Insert Log Trigger- New order insert hone pe message show karega.

CREATE OR REPLACE FUNCTION order_insert_trigger()

RETURNS TRIGGER

AS $$

BEGIN

RAISE NOTICE 'New order inserted successfully';

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

----------------------------------------

CREATE TRIGGER trg_order_insert

AFTER INSERT

ON store_tb

FOR EACH ROW

EXECUTE FUNCTION order_insert_trigger();

----------------------------------------------
INSERT INTO store_tb
(order_id, customer_name, product_name, sales, profit)

VALUES
('1240', 'Dakshata', 'Laptop', 50000, 5000);

--------------------------------------------------

-- TRIGGER 2 — Prevent Negative Sales -Negative sales insert hone se rokna.
CREATE OR REPLACE FUNCTION check_sales()

RETURNS TRIGGER

AS $$

BEGIN

IF NEW.sales < 0 THEN

RAISE EXCEPTION 'Sales cannot be negative';

END IF;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

-----------------------------------------------------
CREATE TRIGGER trg_check_sales

BEFORE INSERT

ON store_tb

FOR EACH ROW

EXECUTE FUNCTION check_sales();

-------------------------------------------------------
INSERT INTO store_tb
(order_id, customer_name, product_name, sales, profit)

VALUES
('1244', 'ABC', 'Mouse', -1000, 100);
