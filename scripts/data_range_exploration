/*
DATE EXPLORATION

Identify the earliest and latest dates(boundaries)
understand the scope od data and time span
*/

--find the date of first and last order
--how many years of sales are avaiable

select
  min(order_date) first_order_date,
  max(order_date) last_order_date,
datediff(month,min(order_date),max(order_date)) order_range_months
from gold.fact_sales
