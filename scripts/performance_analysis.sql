/*
performance analysis
it compares the current value to a target value
help measure succes and compare performance
*/

--analyze the yearly performance of the product by comparing the sales
--to both the average sales of the performance and yearly sales

with yearly_product_sales as(
select
year(s.order_date) order_year,
p.product_name,
sum(s.sales_amount) current_sales
from gold.fact_sales s
left join gold.dim_product p
on s.product_key = p.product_key
where order_date is not null
group by 
year(s.order_date),
p.product_name
)

select
order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) avg_sales ,
current_sales - avg(current_sales) over(partition by product_name) diff_avg_sales,
case
	when current_sales -  avg(current_sales) over(partition by product_name) > 0 then 'above avg'
	when current_sales -  avg(current_sales) over(partition by product_name) < 0 then 'below avg'
	else'avg'
end avg_change,
lag (current_sales) over (partition by product_name order by order_year) py_sales,
current_sales - lag (current_sales) over (partition by product_name order by order_year) py_sales,
case
	when current_sales - lag (current_sales) over (partition by product_name order by order_year) > 0 then 'increse'
	when current_sales - lag (current_sales) over (partition by product_name order by order_year) < 0 then 'decrease'
	else'no change'
end py_sales_change
from yearly_product_sales
order by product_name,order_year
