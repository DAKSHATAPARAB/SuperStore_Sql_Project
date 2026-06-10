-- INDEXES
-------------------------------------------------------------
select * from store_tb;
-----------------------------------
-- 1. INDEX 1 — Region Index

CREATE INDEX idx_region
ON store_tb(region);
--------------------
SELECT *
FROM store_tb
WHERE region = 'West';

--------------------------------------------------------------

-- 2. INDEX 2 — Customer Name Index

CREATE INDEX idx_customer_name
ON store_tb(customer_name);
-----------------------

SELECT *
FROM store_tb
WHERE customer_name = 'Carlos Daly';

--------------------------------------------------------------
-- INDEX 3 — Product Name Index

CREATE INDEX idx_product_name
ON store_tb(product_name);

---------------------------------
SELECT *
FROM store_tb
WHERE product_name = 'g520';

---------------------------------

-- Existing Indexes Check Karne Ke Liye

SELECT *
FROM pg_indexes
WHERE tablename = 'store_tb';

------------------------------------------------------------
------------------------------------------------------------
-- PART 2 — TRANSACTION
------------------------------------------------------------
------------------------------------------------------------
BEGIN;

UPDATE store_tb
SET sales = sales + 1000
WHERE order_id = 515;

UPDATE store_tb
SET profit = profit + 500
WHERE order_id = 515;

COMMIT;

------------------------
ROLLBACK;

----------------------------------------------------------------
----------------------------------------------------------------
-- — ERROR HANDLING
----------------------------------------------------------------
----------------------------------------------------------------

CREATE OR REPLACE FUNCTION divide_numbers(a NUMERIC, b NUMERIC)

RETURNS NUMERIC

AS $$

DECLARE
    result NUMERIC;

BEGIN

    result := a / b;

    RETURN result;

EXCEPTION

WHEN division_by_zero THEN

    RAISE NOTICE 'Cannot divide by zero';

    RETURN NULL;

END;

$$ LANGUAGE plpgsql;

---------------------------------------------------------
SELECT divide_numbers(10, 2);
--------------------------------------------------
SELECT divide_numbers(10, 0);