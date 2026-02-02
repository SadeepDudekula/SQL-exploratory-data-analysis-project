/*
==============================================================
Product Report
==============================================================

Purpose:
- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers (unique)
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last sale)
   - average order revenue (AOR)
   - average monthly revenue
==============================================================
*/

create view gold.report_product as

with base_query as(
select
    f.order_number,
    f.order_date,
    f.sales_amount,
    f.customer_key,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.sub_category,
    p.cost
from gold.fact_sales f
left join gold.dim_product p
on f.product_key = p.product_key
where order_date is not null
),

product_aggregatiton as(

select 
    product_key,
    product_name,
    category,
    sub_category,
    cost,
    count(distinct order_number) total_orders,
    sum(quantity) total_quantity,
    count(distinct customer_key) total_customers,
    sum(sales_amount) total_sales,
    datediff(month,min(order_date),max(order_date)) life_span,
    max(order_date) last_sale_date,
    round(avg(cast(sales_amount as float) / nullif(quantity,0)),1) avg_selling_price
from base_query
group by
    product_key,
    product_name,
    category,
    sub_category,
    cost
)


SELECT
    product_key,
    product_name,
    category,
    sub_category,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    life_span,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    CASE
        WHEN total_orders = 0 THEN 0
        else total_sales / total_orders
    end as avg_order_revenue,
    case 
        when life_span = 0 then total_orders
        else total_sales / life_span
    end as avg_monthly_revenue  
from product_aggregatiton
