select * from pizza_sales
--Find out Total revenue---
select sum(total_price) as Total_Revenue from pizza_sales

---Total average values---
select sum(total_price)/count(distinct order_id) as Avg_ordervalue from pizza_sales

---total pizza sold---
select sum(quantity) as Total_sales from pizza_sales 

--total order placed---
select count(distinct order_id) as Total_orders from pizza_Sales

-- average pizzas per order---
select cast(sum(quantity) as decimal(10,2))/CAST(count(distinct order_id) AS DECIMAL(10,2)) from pizza_sales

---CHARTS REQUIREMENTS-----
--Daily trends for our total order---
SELECT DATENAME(DW,order_date) as order_day,count(distinct order_id) as total_orders
from pizza_sales
group by DATENAME(DW,order_date)

---MONTHLY TRENDS FOR OUR TOTAL ORDERS---

SELECT DATENAME(month,order_date) as order_month,COUNT(DISTINCT ORDER_ID) from pizza_sales
group by DATENAME(MONTH,ORDER_DATE) 
ORDER BY COUNT(DISTINCT ORDER_ID) desc

----percentage of sales by pizza category---
select pizza_category,sum(total_price) as total_sales,sum(total_price)*100/(select sum(total_price) from pizza_Sales) as pct_sales
from pizza_sales 
group by pizza_category

----for a particular month---
select pizza_category,sum(total_price) as total_sales,sum(total_price)*100/(select sum(total_price) from pizza_Sales where month(order_date)=1) as pct_sales
from pizza_sales 
where month(order_date)=1
group by pizza_category

 -- percentage of sales by pizza size--
 select pizza_size,cast(sum(total_price) as decimal(10,2)) as total_sales,cast(sum(total_price)*100/(select sum(total_price) from pizza_Sales where datepart(quarter,order_date)=1) as decimal(10,2)) as pct_sales
from pizza_sales 
where datepart(quarter,order_date)=1
group by pizza_size
order by pct_sales desc

-- top 5 best sellers by revenue,total quantity and total orders---
select top 5 pizza_name,sum(total_price) as total_revenue from pizza_sales
group by pizza_name
order by total_revenue ASC

-- TOP 5 BEST SELLING BY QUANTITY---
select top 5 pizza_name,sum(quantity) as total_quantity from pizza_sales
group by pizza_name
order by total_quantity desc

---top 5 best selling pizza by total orders---
select top 5 pizza_name,count(distinct order_id) as total_orders from pizza_sales
group by pizza_name
order by total_orders asc








