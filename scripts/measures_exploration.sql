/*
MEASURING EXPLORATION
Calculate the key metrics of the bussiness(big numbers)
highest level of aggregations and lowest level of details
*/

--find the total sum
select sum(sales_amount) as total_sales from gold.fact_sales

--find how any items are sold
select sum(quantity) as total_quantity  from gold.fact_sales

--find the average selling price
select avg(price) as average_price from gold.fact_sales

--find the total no-of orders
select count(distinct order_number) total_orders from gold.fact_sales

--find the total no-of products
select count(distinct product_key) total_product from gold.dim_product

--find the total no-of customer that placed order
select count(distinct customer_key) total_customers from gold.fact_sales

--generate a report that shows all key metrics of the bussiness
select 'total_sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select  'total_quantity', sum(quantity)  from gold.fact_sales
union all
select 'average_price', avg(price) from gold.fact_sales
union all
select 'total_orders', count(distinct order_number)  from gold.fact_sales
union all
select 'total_products', count(distinct product_key) t from gold.dim_product
union all
select 'total_customers', count(distinct customer_key)  from gold.fact_sales
