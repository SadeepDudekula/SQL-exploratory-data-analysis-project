/*
==============================================================
Customer Report
==============================================================

Purpose:
- This report consolidates key customer metrics and behaviors

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order value
   - average monthly spend
==============================================================
*/

create view gold.report_customers as

with base_query as (
select
	f.order_number,
	f.order_date,
	f.sales_amount,
	f.quantity,
	f.product_key,
	c.customer_key,
	c.customer_number,
	concat(first_name,' ',last_name) full_name,
	datediff(year,c.birth_date,getdate()) age
from gold.fact_sales f
left join gold.dim_customer c
on f.customer_key = c.customer_key
where order_date is not null
)
, cutomer_aggregation  as(
select
	customer_key,
	customer_number,
	full_name,
	age,
	count(distinct product_key) total_products,
	count(distinct order_number) total_orders,
	sum(sales_amount) total_sales,
	sum(quantity) total_quantity,
	max(order_date) last_order_date,
	datediff(month,min(order_date),max(order_date)) lifespan
from base_query
group by
	customer_key,
	customer_number,
	full_name,
	age
)

select
	customer_key,
	customer_number,
	full_name,
	age,
	total_products,
	total_orders,
	total_sales,
	total_quantity,
	last_order_date,
	lifespan,
	case
		when lifespan >=12 and total_sales > 5000 then 'VIP'
		when lifespan >=12 and total_sales >= 5000 then 'Regular'
		else 'new'
	end customer_sengment,
	case
		when age > 50 then 'old age'
		when age > 30 then 'middle age'
		else 'young'
	end age_segment,
	datediff(month,last_order_date,getdate()) recency,
	case 
		when total_sales = 0 then 0
		else total_sales / total_orders
	end avg_order_value,
	case
		when lifespan = 0 then total_sales
		else total_sales / lifespan
	end avg_monthly_spend
from cutomer_aggregation
