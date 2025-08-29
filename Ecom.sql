use olist_db;

-- Distribution of Payments
select payment_type as Payment_Mode, count(payment_type) as Payment_Mode_Counts
from payments
group by Payment_Mode;

-- Order by Payments
select order_id as OrderID, sum(payment_value) as Total_Payment
from payments
group by OrderID
order by total_payment;

-- Top 10 Customers
select c.customer_unique_id as CustomerID, sum(p.payment_value) as Total_Payment
from customers c
join orders o on c.customer_id = o.customer_id
join payments p on o.order_id = p.order_id
group by CustomerID
order by Total_Payment desc
limit 10;

-- State by Revenue
select c.customer_state as State, round(sum(p.payment_value),2) as Total_Payments
from payments p
join orders o on p.order_id = o.order_id
join customers c on o.customer_id = c.customer_id
group by State
order by Total_Payments desc;

-- Correlation between high order value and payment type
select p.payment_type as Payment_Mode, round(avg(total_payment),2) as Average_Value
from(
    select order_id, sum(payment_value) as total_payment
    from payments
    group by order_id
)sub
join payments p on sub.order_id = p.order_id
group by Payment_Mode
order by Average_Value desc;

-- Total Orders by Month and Year
with cte as(
select
	month(order_purchase_timestamp) as Month_No,
    monthname(order_purchase_timestamp) as Month_Name,
    count(order_id) as Total_Orders_2017
from orders
where year(order_purchase_timestamp) = 2017
group by Month_No, Month_Name
),
cte1 as(
select
	month(order_purchase_timestamp) as Month_No,
    monthname(order_purchase_timestamp) as Month_Name,
    count(order_id) as Total_Orders_2016
from orders
where year(order_purchase_timestamp) = 2016
group by Month_No, Month_Name
),
cte2 as(
select
	month(order_purchase_timestamp) as Month_No,
    monthname(order_purchase_timestamp) as Month_Name,
    count(order_id) as Total_Orders_2018
from orders
where year(order_purchase_timestamp) = 2018
group by Month_No, Month_Name
)
select
	cte.Month_No,
    cte.Month_Name,
    cte1.Total_Orders_2016, cte.Total_Orders_2017, cte2.Total_Orders_2018
from cte
left join cte1 on cte.month_no = cte1.month_no
left join cte2 on cte.month_no = cte2.month_no
order by cte.month_no;

-- Unique Customers
select count(distinct customer_unique_id) as Unique_Customers
from customers;

-- Repeat Customers (customers who placed >1 order)
select customer_unique_id as Customer_UniqueID, count(order_id) as Total_Orders
from orders o
join customers c on o.customer_id = c.customer_id
group by customer_unique_id
having count(order_id) > 1
order by total_orders desc;

-- Customer distribution by state/city.
select customer_state as State, count(customer_id) as Total_Customers
from customers
group by customer_state
order by Total_Customers desc;

-- New vs Returning Customers

-- New vs Returning Customers by Year
with first_purchase as (
select customer_unique_id, min(order_purchase_timestamp) as first_purchase_date
from orders o
join customers c on o.customer_id = c.customer_id
group by customer_unique_id
)
select
	'2017' as Year,
	count(case when year(first_purchase_date) = 2017 then 1 end) as New_Customers,
    count(case when year(first_purchase_date) < 2017 then 1 end) as Returning_Customers
from first_purchase
union all
select
	'2018' as Year,
	count(case when year(first_purchase_date) = 2018 then 1 end) as New_Customers,
    count(case when year(first_purchase_date) < 2018 then 1 end) as Returning_Customers
from first_purchase;

-- Total New and Returning Customers
with first_purchase as (
    select 
        c.customer_unique_id, 
        min(o.order_purchase_timestamp) as first_purchase_date
    from orders o
    join customers c on o.customer_id = c.customer_id
    group by c.customer_unique_id
),
customer_orders as (
    select 
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        fp.first_purchase_date
    from orders o
    join customers c on o.customer_id = c.customer_id
    join first_purchase fp on c.customer_unique_id = fp.customer_unique_id
)
select
    case 
        when order_purchase_timestamp = first_purchase_date then 'New Customer'
        else 'Returning Customers'
    end as Customer_Type,
    count(distinct order_id) as Total_Orders,
    count(distinct customer_unique_id) as Total_Customers
from customer_orders
group by Customer_Type
order by Total_Customers desc;

-- Total Sales
(select '2016' as Year, count(o.order_id) as Total_Orders, round(sum(p.payment_value)) as Revenue
from orders o
join payments p on o.order_id = p.order_id
where year(o.order_delivered_customer_date) = 2016)
union all
(select '2017' as Year, count(o.order_id) as Total_Orders, round(sum(p.payment_value)) as Revenue
from orders o
join payments p on o.order_id = p.order_id
where year(o.order_delivered_customer_date) = 2017)
union all
(select '2018' as Year, count(o.order_id) as Total_Orders, round(sum(p.payment_value)) as Revenue
from orders o
join payments p on o.order_id = p.order_id
where year(o.order_delivered_customer_date) = 2018)
union all
(select 'ALL' as Year, count(o.order_id) as Total_Orders, round(sum(p.payment_value)) as Revenue
from orders o
join payments p on o.order_id = p.order_id);


