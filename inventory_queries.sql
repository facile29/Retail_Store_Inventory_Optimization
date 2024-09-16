use inventory;

select* from inventory;
select* from products;
select* from sales;
select* from store;
select* from supplier;

-- "inventory management"

-- 1. What is the total value of the current inventory?
select round(sum((i.current_stock * p.price_per_unit)), 2) as inventory_value
from inventory i
join product p on i.product_id = p.product_id;

-- 2. Which products need immediate restocking based on current stock and reorder point?
select p.product_name, i.current_stock, p.reorder_point 
from inventory as i
join product as p on i.product_id = p.product_id
where i.current_stock < p.reorder_point;

-- 3. How quickly are products being sold and replaced?
select p.product_name, round(SUM(s.quantity_sold) / AVG(i.current_stock), 2) as "turnover_ratio"
from sales as s
join inventory as i on s.product_id = i.product_id
join product as p on p.product_id = s.product_id
group by p.product_name
order by turnover_ratio desc;

-- "sales peformance"

-- 4. Which products generate the most sales revenue?
select s.product_id, p.product_name, round(sum(s.sales_amount), 2) as "Total_sales"
from sales as s
join product as p 
on s.product_id = p.product_id
group by product_id
order by Total_sales desc;

-- 5. Which are the best-selling products across stores?
select st.store_name, p.product_name , sum(s.quantity_sold) as "Total_Quantity_Sold"
from sales as s 
join product as p ON s.product_id= p.product_id 
join store as st ON s.store_id= st.store_id 
group by st.store_name, p.product_name 
order by Total_Quantity_Sold desc 
limit 10;

-- 6. Which stores are generating the most sales revenue?
select st.store_name, SUM(s.sales_amount) as "total_sales" 
from sales as s
join store as st on s.store_id = st.store_id
group by st.store_name
order by total_sales desc;

-- "profitability analysis"

-- 7. Which products provide the highest profit margins?
select p.product_name, (SUM(s.sales_amount) - SUM(p.price_per_unit * s.quantity_sold)) as "profit"
from sales s
join product p on s.product_id = p.product_id
group by p.product_name
order by profit desc
limit 3;

-- "seasonality and trends"

-- 8. Are there seasonal patterns in sales for specific products?
select p.product_name, EXTRACT(month from s.sale_date) as "sale_month", SUM(s.sales_amount) as "total_sales"
from sales as s
join product as p on s.product_id = p.product_id
group by p.product_name, sale_month
order by p.product_name, sale_month desc;

-- "supplier performance"

-- 9. Which suppliers’ products are selling the most?
select sp.supplier_name, SUM(s.quantity_sold) as "total_sold"
from sales as s
join product as p on s.product_id = p.product_id
join supplier as sp on p.supplier_id = sp.supplier_id
group by sp.supplier_name
order by total_sold desc;


