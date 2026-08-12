--1. Total number of order:

SELECT 
	COUNT(DISTINCT order_id) AS total_orders
		FROM orders;

--2. Total sales value:

SELECT 
	SUM(price) AS total_sales_value
		FROM order_items;
		
--3. Total freight values:

SELECT 
	SUM(freight_value) AS total_freight_value
		FROM order_items;
		
--4. Average order value:
	
SELECT 
	ROUND(AVG(order_value),2)AS average_order_value
		FROM ( SELECT order_id, SUM(price) AS order_value
		FROM order_items
		GROUP BY order_id);

--5. Which product category generates the highest sales?

SELECT 
	p.product_category_name,
		SUM(oi.price) AS highest_sales
		FROM order_items oi
		JOIN products p
		ON oi.product_id=p.product_id
	GROUP BY p.product_category_name
	ORDER BY highest_sales DESC
LIMIT 1;

--6. Which states have the highest number of customers?

SELECT 
	customer_state, COUNT(DISTINCT customer_id) AS customer_count
		FROM customers
	GROUP BY customer_state
	ORDER BY customer_count DESC
LIMIT 1;

--7. Which payment method is most commonly used?

SELECT 
	payment_type, COUNT(payment_type) AS payment_count
		FROM order_payments
	GROUP BY payment_type
	ORDER BY payment_count DESC
LIMIT 1;

--8. Calculate month-over month sales value growth.

WITH monthly_sales
	AS 
	( SELECT TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS Months, 
		SUM(oi.price) AS total_sales
		FROM order_items oi
		JOIN orders o
		ON oi.order_id=o.order_id
		GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
	),
			previous_month_sale AS (
			SELECT * ,
			COALESCE (LAG(total_sales) OVER(ORDER BY Months), 0) AS previous_month_sale
			FROM monthly_sales
			)
SELECT * ,
	(total_sales - previous_month_sale) AS MOM_sales_value_growth
FROM previous_month_sale;

--9. Top 10 products by sales

SELECT 
	oi.product_id, p.product_category_name, SUM(oi.price) AS total_sales
		FROM order_items oi
		JOIN products p
		ON oi.product_id=p.product_id
	GROUP BY oi.product_id, p.product_category_name
	ORDER BY total_sales DESC
LIMIT 10;

--10. Which seller generate the highest sales?

SELECT 	
	seller_id, SUM(price) AS total_sales
		FROM order_items
	GROUP BY seller_id
	ORDER BY total_sales DESC
LIMIT 1;

--11. Percentage of orders are delivered

SELECT 
	COUNT(order_status) 
		FILTER(WHERE order_status='delivered')*100/
		SUM(COUNT(order_status)) OVER() AS delivered_percentage
	FROM orders;

--12. What is the average delivery time?

WITH delivery_time 
		AS (
			SELECT order_delivered_customer_date - order_purchase_timestamp 
			AS delivery_time
		FROM orders)
SELECT 
	AVG(delivery_time) AS average_delivery_time
FROM delivery_time;
		
--13. Which product categories have the highest average review score?

SELECT 
	p.product_category_name, 
	AVG(ore.review_score) AS average_review_score
		FROM order_reviews ore
			JOIN order_items oi
			ON ore.order_id=oi.order_id
			JOIN products p
			ON oi.product_id=p.product_id
	GROUP BY p.product_category_name
	ORDER BY average_review_score DESC
LIMIT 1;

--14. Which states genearte the highest sales?

SELECT 
	c.customer_state, SUM(oi.price) AS total_sales
		FROM order_items oi
		JOIN orders o
		ON o.order_id=oi.order_id
		JOIN customers c
		ON c.customer_id=o.customer_id
	GROUP BY c.customer_state
	ORDER BY total_sales DESC
LIMIT 1;
		
--15. Which customers have places multiple orders?

SELECT 
	c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
		FROM orders o
		JOIN customers c
		ON o.customer_id = c.customer_id
		GROUP BY c.customer_unique_id
		HAVING COUNT(DISTINCT o.order_id) > 1
	ORDER BY order_count DESC;

--16. What is the average freight cost by product category?

SELECT 
	p.product_category_name, pc.product_category_name_english ,
		AVG(oi.freight_value) AS average_freight_cost
		FROM order_items oi
		JOIN products p
		ON oi.product_id=p.product_id
		JOIN product_category pc
		ON p.product_category_name=pc.product_category_name
	GROUP BY p.product_category_name, pc.product_category_name_english;

--17. Rank sellers based on sales

SELECT 
	seller_id, SUM(price) AS total_sales,
		DENSE_RANK() OVER(ORDER BY SUM(price) DESC) AS Ranking
		FROM order_items
	GROUP BY seller_id
	ORDER BY Ranking ;
	
--18. What are the monthly sales trends?

SELECT 
	TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS months, SUM(oi.price) AS monthly_trends
		FROM orders o
		JOIN order_items oi
		ON o.order_id=oi.order_id
	GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
	ORDER BY months;

--19. Find the top 3 product categories in each year.

WITH yearly_sales AS (
		SELECT TO_CHAR(o.order_purchase_timestamp, 'YYYY') AS years,
				p.product_category_name,
				SUM(oi.price) AS yearly_trends,
				DENSE_RANK() OVER(PARTITION BY TO_CHAR(o.order_purchase_timestamp, 'YYYY')
				ORDER BY SUM(oi.price) DESC) AS ranking
			FROM orders o
			JOIN order_items oi
			ON o.order_id=oi.order_id
			JOIN products p
			ON oi.product_id=p.product_id
		GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY'), p.product_category_name)
SELECT * FROM yearly_sales
WHERE ranking BETWEEN 1 AND 3
ORDER BY years, Yearly_trends DESC;
		
--20. Identify customer with the highest total spending.

SELECT 
	c.customer_unique_id, SUM(oi.price) AS total_spending
		FROM order_items oi
		JOIN orders o
		ON oi.order_id=o.order_id
		JOIN customers c
		ON o.customer_id=c.customer_id
	GROUP BY c.customer_unique_id
	ORDER BY total_spending DESC
LIMIT 1;

--21. Calculate the percentage contribution of each category to total sale.

WITH category_sales AS (
    SELECT
        p.product_category_name,
        SUM(oi.price) AS total_sales
    FROM order_items oi
    JOIN products p
    ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT
    product_category_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER (),
        2
    ) AS percentage_of_total_sales
FROM category_sales
ORDER BY percentage_of_total_sales DESC;

--22. Find orders delivered later than the estimated delivery date.

WITH delivery_time
	AS(
	SELECT *, EXTRACT(
				DAY FROM(order_estimated_delivery_date - 
				order_delivered_customer_date) ) AS delay_delivery
	FROM orders
	WHERE order_status ='delivered')
SELECT * 
FROM delivery_time
WHERE delay_delivery < 0 ;

--23. Analyze the relationship between delivery time & review score.
SELECT * FROM orders;
WITH delivery_time
	AS(
	SELECT ore.order_id, o.order_delivered_customer_date, 
		ore.review_score, 
			EXTRACT(
					DAY FROM(o.order_estimated_delivery_date - 
					o.order_delivered_customer_date) ) AS delivery_time
			FROM orders o
			JOIN order_reviews ore
			ON o.order_id=ore.order_id
	WHERE order_status ='delivered')
SELECT delivery_time, 
		AVG(review_score) AS review_score_avg
	FROM delivery_time
GROUP BY delivery_time
ORDER BY delivery_time;

--24. Identify customers who made their first purchase in each month.

WITH first_purchase
		AS (
			SELECT c.customer_unique_id, 
			MIN(o.order_purchase_timestamp) AS first_order_date
			FROM orders o
			JOIN customers c
			ON o.customer_id = c.customer_id
			GROUP BY c.customer_unique_id
		)
SELECT TO_CHAR(first_order_date, 'YYYY-MM') AS months,
		COUNT(customer_unique_id)
	FROM first_purchase
GROUP BY TO_CHAR(first_order_date, 'YYYY-MM')
ORDER BY TO_CHAR(first_order_date, 'YYYY-MM');

--25. Calculate customer Revenue using window functions.

WITH order_total
	AS (	
		SELECT oi.order_id, c.customer_unique_id, SUM(oi.price) AS order_value
			FROM order_items oi
			JOIN orders o
			ON oi.order_id = o.order_id
			JOIN customers c
			ON o.customer_id = c.customer_id
		GROUP BY oi.order_id, c.customer_unique_id
		)
SELECT * ,
		SUM(order_value)
			OVER(PARTITION BY customer_unique_id 
			ORDER BY customer_unique_id) AS customer_revenue
		FROM order_total
	ORDER BY customer_revenue DESC;
