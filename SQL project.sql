---top 10 highest revenue products
select product_id, sum(sale_price) as revenue from orders
group by product_id
order by sum(sale_price) DESC
limit 10

---top 5 by region
With cte as (
select product_id, sum(sale_price) as sales, region
from orders
group by product_id, region

)
select * from(
select * , row_number() over(partition by region order by sales desc) as rn
from cte) bichdan
where rn<=5

----find month over month growth comparison for 2022 and 2023 sales eg: jan 22 vs jan 23
with cte as(
select extract(year from order_date) as year, extract( month from order_date) as month, 
sum(sale_price) sales from orders
group by year, month
)
select month, sum(case when year = 2022 then sales else 0 end) as sales_2022,
sum(case when year = 2023 then sales else 0 end) as sales_2023
from cte
group by month
order by month

---for each category which month had highest sales
with cte as (
select category, to_char(order_date, 'yyyy-mm') as date, sum(sale_price) as sales from orders
group by category, date
-- order by category, date
)
select * from(
select *, row_number() over(partition by category order by sales desc) as rn
from cte )as cat
where rn =1

-----which sub category has highest growth by profit in 2023 compare to 2022

with cte as(
select sub_category, extract(year from order_date) as year, 
sum(sale_price) sales from orders
group by sub_category, year
),

cte2 as(
select sub_category, sum(case when year = 2022 then sales else 0 end) as sales_2022,
sum(case when year = 2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
order by sub_category
)
select *, round((sales_2023-sales_2022)*100/sales_2022,2) as growth
from cte2
order by growth desc
limit 1

