/*
comulative analysis
it aggregates the data progressively over the time
helps to understand that our bussiness is growing or declining
*/

--calculate the total sales per month
--and the running of total sales over time

select
order_date,
total_sales,
sum(total_sales) over(order by order_date) running_total_sales
from(
select
datetrunc(year,order_date) order_date,
sum(sales_amount) total_sales
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
)t
