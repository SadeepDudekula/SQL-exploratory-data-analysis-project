/*
CHANGE OVER TIME ANALYZE
It is a technic to analyze how a ,easure evolves over time
helps to track the trends and identify seasonality in our data
*/

--Analyze sales performance over time
select
datetrunc(month,order_date) order_year,
sum(sales_amount) total_sale,
count(distinct customer_key) total_customers,
sum(quantity) total_quantity
from gold.fact_sales
where order_date is not null
group by datetrunc(month,order_date)
order by datetrunc(month,order_date)
