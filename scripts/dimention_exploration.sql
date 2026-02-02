/*
Dimention exploration

Identify the unique values (or categories) in each diagram

recognizing how data might be grouped or segmented which is usefull 
for later analysis*/

--exploring all countries our customers come from
select distinct
country
from gold.dim_customer

--explore all categories the major division
select distinct
category,
sub_category,
product_name
from gold.dim_product
