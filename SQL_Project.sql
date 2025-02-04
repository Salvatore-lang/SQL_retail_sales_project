----- All sales made in 2022-11-05

SELECT * 
FROM aaa
WHERE sale_date = '2022-11-05'

----transactions for the category 'Clothing', with quantity sold more than 10 in the month of nov-22
SELECT
	category,
	SUM(quantiy) AS quantity_sold
FROM aaa
WHERE EXTRACT(YEAR FROM sale_date) = 2022 AND EXTRACT(MONTH FROM sale_date) = 11
GROUP BY category
HAVING SUM(quantiy) >10 

----- SECOND METHOD

SELECT category, SUM(quantiy)
FROM aaa
WHERE category = 'Clothing' 
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
GROUP BY category

---- total sales for each category

SELECT 
	category,
	SUM(total_sale) AS TOTAL_SOLD
FROM aaa
GROUP BY category

----- SECOND METHOD

SELECT 
    category, 
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders,
	ROUND(SUM(total_sale::numeric) / COUNT(*)::numeric, 2)
FROM aaa
GROUP BY category;

----- average age of customers of the 'Beauty' category

SELECT
	category,
	ROUND(AVG(age), 2) as avg_beauty_age
FROM aaa
WHERE category='Beauty'
GROUP BY category

--- transactions where total_sale is greater than 1000

SELECT
	transactions_id,
	total_sale
FROM aaa
WHERE total_sale>1000

---- total number of transactions made by each gender
SELECT
	category,
	gender,
	COUNT(transactions_id)
FROM aaa
GROUP BY category, gender

-- avg sale for each month, finding the best selling month
SELECT
	year, month, avg_sale
FROM
	(SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
	    EXTRACT(MONTH FROM sale_date) AS month,
	    ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sale,
		RANK()OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)as rank
	FROM aaa
	GROUP BY year, month) AS t1
WHERE rank=1
--- ORDER BY year, month ASC

--- top 5 customers with the highest total sales

SELECT customer_id, SUM(total_sale) AS total_spent
FROM aaa
GROUP BY 1
ORDER BY SUM(total_sale) DESC
LIMIT 5

---- number of unique customers who purchased items for each category
SELECT
	category, COUNT(DISTINCT(customer_id)) as No_customers
FROM aaa
GROUP BY category
ORDER BY no_customers DESC

----- each shift and number of orders
WITH hourly_sale
AS 
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 20 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM aaa)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC

--- END of project

