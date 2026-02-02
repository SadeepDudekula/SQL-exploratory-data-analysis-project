/*
part to whole analysis
analyze how an induvidual part is performance compared to the whole part
it allows us to understande which part has greater impact on bussiness
*/

--which category contributes the most to the overall sales

with category_sales as (
select
category,
sum(sales_amount) total_sales
from gold.fact_sales s
left join gold.dim_product p
on s.product_key = p.product_key
group by p.category
)

select
category,
total_sales,
sum(total_sales) over () overall_sales,
concat(round(cast(total_sales as float) / sum(total_sales) over () * 100,2),'%') percentage_sales
from category_sales
order by total_sales desc
