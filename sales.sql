select * from sales;

update sales
set status = 'Order Placed'
where status = 'Order';

select * from sales order by total_sales desc;

#top three records#

select * from(select sales.*,dense_rank()over(order by total_sales desc)as rn from sales)m
where rn <=3;

#lowest three records#

select * from
(select sales.*,dense_rank()over(order by total_sales asc)as rn from sales)m
where rn <=3;

# second highest record#

select * from (select sales.* ,dense_rank()over(order by total_sales desc)as rn from sales)
m where rn=2;

#third lowest record#

select * from (select sales.*,dense_rank()over(order by total_sales asc)as rn from sales)
m where rn=3;

#monthly sales by total_sales#

select to_char(order_date,'yyyy-mm')as sales_month,sum(total_sales)as monthly_revenue
from sales
group by to_char(order_date,'yyyy-mm')
order by sales_month;

#total sales by quantity#

select to_char(order_date,'yyyy-mm')as month,sum(quantity)as total_quantity from sales
group by to_char(order_date,'yyyy-mm')
order by month;

#month in which quantity is more than 500#

(select * from (select to_char(order_date,'yyyy-mm')as month,sum(quantity)as total_quantity from sales
group by to_char(order_date,'yyyy-mm')
order by total_quantity desc)where total_quantity >500);

#top three month by quantity#
create view quantity as (select * from (select to_char(order_date,'yyyy-mm')as month,sum(quantity)as total_quantity from sales
group by to_char(order_date,'yyyy-mm')
order by total_quantity desc)where total_quantity >500);

select * from (select quantity.* ,rownum as rn from quantity)where rn <=3;

# top three month by total_sales#

create view sale as select to_char(order_date,'yyyy-mm')as sales_month,sum(total_sales)as monthly_revenue
from sales
group by to_char(order_date,'yyyy-mm')
order by monthly_revenue desc;

select * from(select sale.*,rownum as rn from sale)where rn <=3;

# total_sales according to state#

select state_code , sum(total_sales)as total_revenue
from sales 
group by state_code
order by total_revenue desc; 

# top three state having largest revenue#
create view state as select state_code , sum(total_sales)as total_revenue
from sales 
group by state_code
order by total_revenue desc;

select * from(select state.*,rownum as rn from state)where rn <=3;

select *from sales;

#sales by product#

select product , sum(quantity)as total_quantity from sales
group by product
order by total_quantity desc;

# top 10 selling product#

create view product as select product , sum(quantity)as total_quantity from sales
group by product
order by total_quantity desc;

select * from (select product.* , rownum as rn from product)where rn <=10;

select state_code,product,sum(quantity) as quantity from sales
group by state_code,product
order by quantity desc;

select product from 
(select * from (select product.* , rownum as rn from product)where rn <=10);

# top 10 selling products sales according to state#

select state_code,product,sum(quantity) as quantity from sales
group by state_code,product
having product in (select product from 
(select * from (select product.* , rownum as rn from product)where rn <=10))
order by quantity desc;
