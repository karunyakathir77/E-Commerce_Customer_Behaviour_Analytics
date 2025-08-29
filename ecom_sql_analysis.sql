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

-- Customer distribution by State
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

-- Top 10 most sold product categories
select pd.product_category_name_english as Categories, count(i.order_id) as Total
from product_table pd
join items i on pd.product_id = i.product_id
group by pd.product_category_name_english
order by total desc
limit 10;

-- Categories with highest Revenue
select pd.product_category_name_english as Categories, round(sum(p.payment_value),2) as Revenue
from product_table pd
join items i on pd.product_id = i.product_id
join payments p on p.order_id = i.order_id
group by product_category_name_english
having Revenue >= 150000
order by Revenue desc;

-- Categories with low/mod/high/avg review scores
select 
	pd.product_category_name_english as Categories,
    sum(case when r.review_score > 3 then 1 else 0 end) as High_Review_Score,
    sum(case when r.review_score = 3 then 1 else 0 end) as Moderate_Review_Score,
	sum(case when r.review_score < 3 then 1 else 0 end) as Low_Review_Score,
    avg(r.review_score) as Average_Review_Score
from product_table pd
join items i on pd.product_id = i.product_id
join reviews r on i.order_id = r.order_id
group by pd.product_category_name_english
order by High_Review_Score desc;

-- Categories with longest/shortest/average delivery time
select 
	pd.product_category_name_english as Categories,
    max(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Most_Delayed_Delivery,
    min(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Fastest_Delivery,
    avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) as Average_Delivery_Time
from orders o
join items i on o.order_id = i.order_id
join product_table pd on i.product_id = pd.product_id
where o.order_delivered_customer_date is not null
group by pd.product_category_name_english
order by Most_Delayed_Delivery desc;

-- Unique Sellers
select count(distinct seller_id) as Total_Sellers
from sellers;

-- Top Sellers by Revenue
select s.seller_id as Seller_ID, round(sum(p.payment_value), 2) as Total_Revenue, round(avg(p.payment_value), 2) as Average_Revenue
from items i
join payments p on i.order_id = p.order_id
join sellers s on i.seller_id = s.seller_id
group by s.seller_id
having Total_Revenue > 100000
order by Total_Revenue desc;

-- Distribution of Review Scores (1–5)
select review_score as Scores, count(review_id) as Count
from reviews
group by review_score
order by Scores desc;

-- % of Orders Delivered Late (after Estimated Date)
(select 
	'Correct Delivery' as Status,
	concat(round((count(order_id) / (select count(order_id) from orders))*100, 2), '%') as Percentage
from orders
where order_estimated_delivery_date > order_delivered_customer_date)
union
(select 
	'Late Delivery' as Status,
	concat(round((count(order_id) / (select count(order_id) from orders))*100, 2), '%') as Percentage
from orders
where order_estimated_delivery_date < order_delivered_customer_date)
union
(select 
	'On Time' as Status,
	concat(round((count(order_id) / (select count(order_id) from orders))*100, 2), '%') as Percentage
from orders
where order_estimated_delivery_date = order_delivered_customer_date)
union
(select 
	'Null' as Status,
	concat(round((count(order_id) / (select count(order_id) from orders))*100, 2), '%') as Percentage
from orders
where order_estimated_delivery_date is null or order_delivered_customer_date is null);

-- States by Late Delivery
select 
	c.customer_state as State,
    count(*) as Total_Delayed_Orders
from orders o
join customers c on o.customer_id = c.customer_id
where o.order_estimated_delivery_date < o.order_delivered_customer_date
group by c.customer_state
order by Total_Delayed_Orders desc;

-- Delivery Delays
with cte as(
select
	o.order_id as order_id,
    datediff(o.order_delivered_customer_date, o.order_purchase_timestamp) as delivery_days,
    r.review_score as score
from orders o
join reviews r on o.order_id = r.order_id
where o.order_delivered_customer_date is not null
)
select
    case when score < 3 then 'Delay Matters' else 'Delay Doesn’t Matter' end as Impact,
    count(case when delivery_days > 7 then 1 end) as Delivery_Above_7days,
    count(case when delivery_days > 10 then 1 end) as Delivery_Above_10days,
    count(case when delivery_days > 15 then 1 end) as Delivery_Above_15days
from cte
group by Impact;

-- Overall Correlation Delivery Delays and Review Scores
with cte as(
select
	o.order_id as order_id,
    datediff(o.order_delivered_customer_date, o.order_purchase_timestamp) as Delivery_Days,
    r.review_score as Score
from orders o
join reviews r on o.order_id = r.order_id
),
cte1 as(
select
	order_id, delivery_days, score,
    case when delivery_days > 7 and score < 3 then 'Delay Matters' else 'Delay Doesn’t Matter' end as Delivery_Above_7days,
    case when delivery_days > 10 and score < 3 then 'Delay Matters' else 'Delay Doesn’t Matter' end as Delivery_Above_10days,
    case when delivery_days > 15 and score < 3 then 'Delay Matters' else 'Delay Doesn’t Matter' end as Delivery_Above_15days
from cte
where delivery_days is not null)
select
	Delivery_Days, Score, Delivery_Above_7days, Delivery_Above_10days, Delivery_Above_15days, 
	case
		when Delivery_Above_7days = 'Delay Matters' and Delivery_Above_10days = 'Delay Matters' then 'Negative Influence'
		when Delivery_Above_10days = 'Delay Matters' and Delivery_Above_15days = 'Delay Matters' then 'Negative Influence'
		when Delivery_Above_7days = 'Delay Matters' and Delivery_Above_15days = 'Delay Matters' then 'Negative Influence' 
        else 'No Significant Influence'
	end as Final_Impact
from cte1

-- Customer Churn Rate
with customer_orders as(
select c.customer_unique_id, count(o.order_id) as Total_Orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_unique_id
)
select
	round(sum(case when total_orders = 1 then 1 else 0 end) / count(*) * 100, 2) as Churn_Rate_Percentage
from customer_orders;

-- Revenue Rank by state
select rank() over(order by revenue desc) as Revenue_Rank, State, Revenue
from(
select c.customer_state as State, round(sum(p.payment_value),2) as Revenue
from customers c
join orders o on c.customer_id = o.customer_id
join payments p on p.order_id = o.order_id
group by State
) sub
order by Revenue_Rank;

-- Avg Delivery by Month
select
	date_format(order_purchase_timestamp, '%m') as Month,
	round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp))) as Average_Delivery_Days
from orders
where order_delivered_customer_date is not null
group by month
order by month asc;

-- Most Popular Product Category by Quarter
with category_quarter as(
select
	concat(year(o.order_purchase_timestamp), '-Q', quarter(o.order_purchase_timestamp)) as Quarter,
    ct.product_category_name_english as Categories, count(o.order_id) as Total_Orders
from orders o
join items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
join category_translation ct on p.product_category_name = ct.product_category_name
group by quarter, categories
),
ranked as (
select quarter, categories, total_orders, row_number() over(partition by quarter order by total_orders desc) as rn
from category_quarter
)
select Quarter, Categories, Total_Orders
from ranked
where rn=1
order by quarter;
