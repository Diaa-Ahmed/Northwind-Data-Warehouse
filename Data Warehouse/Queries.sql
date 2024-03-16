-- Display the employee with the highest and lowest sales in each country
WITH Employee_sales AS (
    SELECT e.emp_id, e.first_name, e.last_name, e.country, o.Unitprice, o.quantity,
           ROUND(SUM(o.Unitprice * o.quantity) OVER(PARTITION BY e.country, e.emp_id)) AS emp_sales
    FROM employees_dim AS e
    INNER JOIN orders_fact AS o ON e.emp_sur = o.emp_sur
) ,
Ranked_employee_sales_tab AS (
    SELECT country, first_name, last_name, emp_sales,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY emp_sales DESC) AS sales_rank_max,
           ROW_NUMBER() OVER (PARTITION BY country ORDER BY emp_sales ASC) AS sales_rank_min
    FROM Employee_sales
)
SELECT country, first_name, last_name, emp_sales
FROM Ranked_employee_sales_tab
WHERE sales_rank_max = 1 OR sales_rank_min = 1;
--------------------------------------------------------
-- The Sppliers whose products achieve the max and min sales 
WITH supplier_sales AS (
SELECT s.supplier_id , s.company_name ,ROUND(SUM(o.Unitprice * o.quantity) OVER(PARTITION BY supplier_id)) AS Sup_sales
FROM suppliers_dim AS s , orders_fact AS o 
WHERE s.supplier_sur = o.supplier_sur),
Ranked_suppliers_sales_tab AS (
    SELECT supplier_id, company_name,  Sup_sales,
           ROW_NUMBER() OVER (ORDER BY Sup_sales DESC) AS sales_rank_max,
           ROW_NUMBER() OVER (ORDER BY Sup_sales ASC) AS sales_rank_min
    FROM supplier_sales
)
SELECT supplier_id, company_name,  Sup_sales
FROM Ranked_suppliers_sales_tab
WHERE sales_rank_max = 1 OR sales_rank_min = 1;

------------------------------------------------------------
-- Customers segmentation
WITH customer_Purchases AS (
SELECT cust.customer_id , cust.company_name 
	,ROUND(SUM(o.Unitprice * o.quantity) OVER(PARTITION BY customer_id)) AS cust_sales
FROM customer_dim AS cust , orders_fact AS o 
WHERE cust.cust_sur = o.cust_sur),
cust_category_tab AS(
SELECT customer_id , company_name ,cust_sales , NTILE(5) OVER(ORDER BY cust_sales) AS customer_categories
FROM customer_Purchases )
SELECT DISTINCT customer_id , company_name ,cust_sales ,customer_categories , 
          CASE
		      WHEN customer_categories = 1 THEN 'At Risk'
			  WHEN customer_categories = 2 THEN 'Customers Needing Attention' 
			  WHEN customer_categories = 3 THEN 'promising'
			  WHEN customer_categories = 4 THEN 'Potential Loyalists'
			  WHEN customer_categories = 5 THEN 'Loyal Customers'
		  END AS Our_Customers_categories

FROM cust_category_tab ;
---------------------------------------------------
-- Growth Rate For Every Month 

WITH MonthlySales AS (
SELECT TO_TIMESTAMP(order_date::text, 'YYYYMMDD') AS actual_date,
       quantity,
       Unitprice
FROM orders_fact 
)
SELECT EXTRACT(YEAR FROM actual_date) AS year,
 EXTRACT(MONTH FROM actual_date) AS month,
  ROUND(SUM(Unitprice * quantity)) AS total_sales,
  ROUND(LAG(SUM(Unitprice * quantity)) OVER (ORDER BY EXTRACT(YEAR FROM actual_date),
							EXTRACT(MONTH FROM actual_date))) AS prev_month_sales,
  ROUND((SUM(Unitprice * quantity) - LAG(SUM(Unitprice * quantity)) OVER (ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date))) / LAG(SUM(Unitprice * quantity)) OVER (ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date)) * 100) AS growth_rate,
       RANK() OVER(ORDER BY SUM(QUANTITY * Unitprice) DESC) AS MONTH_RANK 
FROM MonthlySales 
GROUP BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date)
ORDER BY EXTRACT(YEAR FROM actual_date), EXTRACT(MONTH FROM actual_date);

-----------------------------------------------------------------------

-- Analysis Month Sales To Catch Daily Sales Pattern

WITH MonthSales AS (
SELECT
  TO_CHAR(TO_TIMESTAMP(order_date::text, 'YYYYMMDD'), 'DD') AS actual_date,
  TO_CHAR(TO_TIMESTAMP(order_date::text, 'YYYYMMDD'), 'Mon YYYY') AS monthh,
  quantity,
  Unitprice 
FROM orders_fact 

),
avgg AS (
SELECT
  monthh,
  SUM(CASE WHEN EXTRACT(DAY FROM TO_TIMESTAMP(actual_date, 'DD')) <= 10 THEN Unitprice * Quantity ELSE 0 END) AS total_sales_of_first_10_days,
  SUM(CASE WHEN EXTRACT(DAY FROM TO_TIMESTAMP(actual_date, 'DD')) BETWEEN 11 AND 20 THEN Unitprice * Quantity ELSE 0 END) AS total_sales_of_second_10_days,
  SUM(CASE WHEN EXTRACT(DAY FROM TO_TIMESTAMP(actual_date, 'DD')) BETWEEN 21 AND 31 THEN Unitprice * Quantity ELSE 0 END) AS total_sales_of_third_10_days
FROM MonthSales
GROUP BY monthh

)
SELECT
 ROUND(sum(total_sales_of_first_10_days)) AS avg_10,
 ROUND(sum(total_sales_of_second_10_days)) AS avg_20,
 ROUND(sum(total_sales_of_third_10_days)) AS avg_30 
FROM avgg;
-------------------------------------------------------
-- Ranked Products Sales 
WITH product_sales AS (
SELECT DISTINCT
  prod_name,
  ROUND(SUM(OD.quantity * p.Unitprice) OVER (PARTITION BY prod_name)) AS stock_sales 
FROM products_dim AS P
inner join public.orders_fact AS OD
ON OD.product_sur = p.prod_sur

)
SELECT
 prod_name,
 stock_sales,
 RANK() OVER (ORDER BY stock_sales DESC) AS product_rnk 
FROM product_sales 
ORDER BY product_rnk;