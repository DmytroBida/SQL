SELECT *
FROM portfolio..sales

-- Searching for a column with unique value using the first method

WITH unique_id (item_id, first_name, last_name, row_num)
AS (
SELECT item_id, first_name, last_name, ROW_NUMBER() OVER (PARTITION BY item_id ORDER BY item_id) AS row_num
FROM portfolio..sales
)
SELECT *
FROM unique_id
WHERE row_num > 1
ORDER BY item_id DESC

-- Searching for a column with unique value using the second method
-- Returning same count of rows that were in the initial document

SELECT COUNT(DISTINCT(item_id))
FROM portfolio..sales

-- Adding new column

ALTER TABLE sales
ADD price_new float

-- Changing type of data and adding data in new column


SELECT CAST(price AS float) AS price_float
FROM portfolio..sales

UPDATE portfolio..sales
SET price_new = CAST(price AS float)

-- Looking on order status

SELECT DISTINCT(status), COUNT(status)
FROM portfolio..sales
GROUP BY status

-- Changing order status to 3 types 

WITH statusCTE (status, total, order_status)
AS (
SELECT status, total, (CASE WHEN status='paid' AND total!='0' THEN 'complete'  
                WHEN status='holded' AND total!='0' THEN 'complete'
				WHEN status='closed' AND total!='0' THEN 'complete'
				WHEN status='cod' AND total!='0' THEN 'complete'
				WHEN status='received' AND total!='0' THEN 'complete'
				WHEN status='pending' AND total!='0' THEN 'complete'
				WHEN status='pending' AND total='0' THEN 'processing'
				WHEN status='paid' AND total='0' THEN 'processing'
				WHEN status='received' AND total='0' THEN 'complete'
				WHEN status='cod' AND total='0' THEN 'processing'
				WHEN status='payment_review' AND total='0' THEN 'processing'
				WHEN status='pending_paypal' AND total='0' THEN 'processing'
				WHEN status='pending_paypal' AND total!='0' THEN 'processing'
				WHEN status='payment_review' AND total!='0' THEN 'processing'
				WHEN status='closed' AND total='0' THEN 'processing'
				WHEN status='order_refunded' THEN 'canceled'
				WHEN status='orded_refunded' THEN 'canceled'
				WHEN status='refund' THEN 'canceled' ELSE status END) AS order_status	
FROM portfolio..sales
)
SELECT order_status, COUNT(order_status)
FROM statusCTE
GROUP BY order_status

ALTER TABLE portfolio..sales
ADD order_status NVARCHAR(255)

UPDATE portfolio..sales
SET order_status = (CASE WHEN status='paid' AND total!='0' THEN 'complete'  
                WHEN status='holded' AND total!='0' THEN 'complete'
				WHEN status='closed' AND total!='0' THEN 'complete'
				WHEN status='cod' AND total!='0' THEN 'complete'
				WHEN status='received' AND total!='0' THEN 'complete'
				WHEN status='pending' AND total!='0' THEN 'complete'
				WHEN status='pending' AND total='0' THEN 'processing'
				WHEN status='paid' AND total='0' THEN 'processing'
				WHEN status='received' AND total='0' THEN 'complete'
				WHEN status='cod' AND total='0' THEN 'processing'
				WHEN status='payment_review' AND total='0' THEN 'processing'
				WHEN status='pending_paypal' AND total='0' THEN 'processing'
				WHEN status='pending_paypal' AND total!='0' THEN 'processing'
				WHEN status='payment_review' AND total!='0' THEN 'processing'
				WHEN status='closed' AND total='0' THEN 'processing'
				WHEN status='order_refunded' THEN 'canceled'
				WHEN status='orded_refunded' THEN 'canceled'
				WHEN status='refund' THEN 'canceled' ELSE status END)

-- Creating new column with full name

SELECT name_prefix, first_name, middle_initial, last_name, CONCAT(name_prefix,' ', first_name,' ',middle_initial,' ', last_name)
FROM portfolio..sales

ALTER TABLE portfolio..sales
ADD full_name VARCHAR(255)

UPDATE portfolio..sales
SET full_name = CONCAT(name_prefix,' ', first_name,' ',middle_initial,' ', last_name)

-- Rounding column values with 2 decimal places

UPDATE portfolio..sales
SET discount_amount = ROUND((discount_amount), 2)

UPDATE portfolio..sales
SET discount_percent = ROUND((discount_percent), 2)

--discount amount was higher than total and I'am update column with discount amount with formula from below

UPDATE portfolio..sales
SET discount_amount = value-total

-- but some rows with discount amount was with misstakes, and I updated value with using discount percent column

UPDATE portfolio..sales
SET discount_amount = ROUND(((value*discount_percent)/100), 2)

UPDATE portfolio..sales
SET total = value-discount_amount

SELECT AVG(discount_percent)
FROM portfolio..sales

SELECT *
FROM portfolio..sales
WHERE discount_percent > '100'

-- Nearly 600 rows with discount were broken and I will ignore rows with discount_percent > 100

-- some order id was duplikaded, but with unique item id

SELECT COUNT(DISTINCT(order_id))
FROM portfolio..sales
WHERE order_id IS NOT NULL

-- I will group total sum of order by order id, full name and order date, so I will know the amount of the order by the order id

WITH total_orderCTE (order_id, order_status, full_name, order_date_new, total_order_value) 
AS (
SELECT order_id, order_status, full_name, order_date_new, SUM(total) AS total_order_value
FROM portfolio..sales
WHERE order_id IS NOT NULL AND discount_percent < '100'
GROUP BY order_id, full_name, order_date_new, order_status
)

--checking current table with previous table to make sure our unique order values match in quantity

SELECT COUNT(DISTINCT(order_id))
FROM total_orderCTE

--Create new table with total_order_value per order id

SELECT order_id, order_status, full_name, order_date_new, SUM(total) AS total_order_value
INTO portfolio..total_amountOfOrder
FROM portfolio..sales
WHERE order_id IS NOT NULL AND discount_percent < '100' AND order_status ='complete'
GROUP BY order_id, full_name, order_date_new, order_status

SELECT *
FROM portfolio..total_amountOfOrder

--Create new table with total order value per day

WITH total_per_dateCTE(order_status, order_date_new, total_per_date) 
AS (
SELECT order_status, order_date_new, ROUND(SUM(total), 2) AS total_per_date
FROM portfolio..sales
WHERE order_status = 'complete' AND discount_percent < '100'
GROUP BY order_date_new, order_status
)

SELECT *
FROM total_per_dateCTE
ORDER BY order_date_new


SELECT order_status, order_date_new, ROUND(SUM(total), 2) AS total_per_date
INTO portfolio..totalAmount_per_date
FROM portfolio..sales
WHERE order_status = 'complete' AND discount_percent < '100'
GROUP BY order_date_new, order_status

--delete unnecessary for use columns

ALTER TABLE portfolio..sales
DROP COLUMN order_date, year, month, ref_num, name_prefix, first_name, middle_initial, last_name, customer_sience, ssn, price, status

-- Create table with locations

SELECT DISTINCT(state)
FROM portfolio..sales

SELECT *
FROM portfolio..sales
WHERE LEN(state) > 3

-- There are 2 rows with errors in state column, we will ignore them with function LEN

SELECT SUM(total) AS total_sales_byState, order_date_new, state
INTO portfolio..sales_by_location
FROM portfolio..sales
WHERE order_status = 'complete' AND discount_percent < '100' AND LEN(state) < 3
GROUP BY state, order_date_new
ORDER BY order_date_new, state

-- Change type of data another column

ALTER TABLE portfolio..sales
ADD item_id_new float

UPDATE portfolio..sales
SET item_id_new = CAST(item_id AS float)


ALTER TABLE portfolio..sales
ADD age_new float

UPDATE portfolio..sales
SET age_new = CAST(age AS float)

-- Have a problem with change type of data with age

SELECT age,COUNT(age)
FROM portfolio..sales
GROUP BY age

-- There are 2 row with age M

UPDATE portfolio..sales
SET age_new = (CASE WHEN age = 'M' THEN NULL ELSE CAST(age AS float) END)

SELECT age_new, COUNT(age_new)
FROM portfolio..sales
GROUP BY age_new

ALTER TABLE portfolio..sales
DROP COLUMN age, item_id

-- Create table with metrics for vizualization

SELECT ROUND(SUM(total)/COUNT(username), 2) AS revenue_per_account, order_date_new
--INTO portfolio..AVGrevenue_per_account
FROM portfolio..sales
WHERE order_status = 'complete' AND discount_percent < '100'
GROUP BY order_date_new


WITH small_orderCTE (order_date_new, small_order)
AS(
SELECT order_date_new, COUNT(order_id) AS small_order
FROM portfolio..sales
WHERE total < '100' AND order_status = 'complete' AND discount_percent < '100'
GROUP BY order_date_new
),
middle_orderCTE (order_date_new, middle_order)
AS(
SELECT order_date_new, COUNT(order_id) AS middle_order
FROM portfolio..sales
WHERE total BETWEEN '100'AND '10000' AND order_status = 'complete' AND discount_percent < '100'
GROUP BY order_date_new
),
big_orderCTE (order_date_new, big_order)
AS(
SELECT order_date_new, COUNT(order_id) AS big_order
FROM portfolio..sales
WHERE total > '10000' AND order_status = 'complete' AND discount_percent < '100'
GROUP BY order_date_new
),
total_orderCTE (order_date_new, total_order)
AS (
SELECT order_date_new, COUNT(order_id) AS total_order
FROM portfolio..sales
WHERE order_status='complete' AND discount_percent <'100'
GROUP BY order_date_new
)

SELECT s.order_date_new, s.small_order, m.middle_order, b.big_order, t.total_order
INTO portfolio..order_size
FROM small_orderCTE s LEFT JOIN middle_orderCTE m ON s.order_date_new=m.order_date_new
                      LEFT JOIN big_orderCTE b ON m.order_date_new=b.order_date_new
					  LEFT JOIN total_orderCTE t ON b.order_date_new=t.order_date_new


SELECT age_new, ROUND(AVG(total), 2) AS avg_per_age
INTO portfolio..avg_per_age
FROM portfolio..sales
WHERE order_status = 'complete' AND discount_percent < '100'
GROUP BY age_new
ORDER BY AVG(total) DESC

--Create common table expression (CTE) for win rate by order status table. Don't forget use CAST for transfor data type for formula

WITH complete_orderCTE (order_date_new, complete_order)
AS(

SELECT order_date_new, CAST(COUNT(order_status)AS float) AS complete_order
FROM portfolio..sales
WHERE order_status='complete' AND discount_percent < '100'
GROUP BY order_date_new
),
allOrder_statusCTE (order_date_new, allOrder_status)
AS (
SELECT order_date_new, CAST(COUNT(order_status)as float) AS allOrder_status
FROM portfolio..sales
WHERE discount_percent < '100'
GROUP BY order_date_new
)

SELECT a.order_date_new, complete_order, allOrder_status, ROUND(CAST(complete_order/allOrder_status AS float), 2) AS win_rate
INTO portfolio..win_rate_byOrder_status
FROM complete_orderCTE c LEFT JOIN allOrder_statusCTE a ON c.order_date_new=a.order_date_new

SELECT category, ROUND(SUM(total), 2) AS total_per_category
INTO portfolio..bests_categories_bySales
FROM portfolio..sales
WHERE order_status ='complete' AND discount_percent < '100'
GROUP BY category
ORDER BY SUM(total) DESC

SELECT category, COUNT(order_status) AS total_canceled
INTO portfolio..topCategory_byCalceld
FROM portfolio..sales
WHERE order_status = 'canceled' AND discount_percent < '100'
GROUP BY category
ORDER BY COUNT(order_status) DESC



SELECT order_date_new, category, ROUND(SUM(total), 2) AS total_per_category
INTO portfolio..bests_categories_bySales_BI
FROM portfolio..sales
WHERE order_status ='complete' AND discount_percent < '100'
GROUP BY order_date_new, category
ORDER BY order_date_new

SELECT order_date_new, category, ROUND(SUM(total), 2) AS total_per_category, state
INTO portfolio..bests_categories_byStates
FROM portfolio..sales
WHERE order_status ='complete' AND discount_percent < '100'
GROUP BY order_date_new, category, state
ORDER BY SUM(total) DESC


WITH complete_orderCTE (complete_order, state, order_date_new)
AS(
SELECT CAST(COUNT(order_status) AS float) AS complete_order, state, order_date_new
FROM portfolio..sales
WHERE order_status ='complete' AND discount_percent<'100'
GROUP BY order_date_new, state
),
all_orders (all_orders, state, order_date_new)
AS(
SELECT CAST(COUNT(order_status) AS float) AS all_orders, state, order_date_new
FROM portfolio..sales
WHERE discount_percent<'100'
GROUP BY order_date_new, state
)

SELECT a.order_date_new, complete_order, a.state, all_orders, (CASE WHEN complete_order IS NULL THEN '0' ELSE CAST(ROUND((complete_order/all_orders), 2) AS float) END) AS win_rate
 
INTO portfolio..win_rateByState
FROM complete_orderCTE c RIGHT JOIN all_orders a ON c.order_date_new=a.order_date_new
                                                    AND c.state = a.state