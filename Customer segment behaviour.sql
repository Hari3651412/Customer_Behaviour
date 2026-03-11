create database Customer_Behaviour;
use Customer_Behaviour;
select * from customer;
#1. Total revenue by gender
select gender,sum(purchase_amount) as Total_revenue
from customer
group by gender;

#2. Customers who used discount but spent more than average?
select customer_id,purchase_amount
from customer
where discount_applied='Yes'
and purchase_amount>(
select avg(purchase_amount) as avg
from customer);

#3. Top 5 products with highest average rating

select item_purchased,round(avg(review_rating),2) as avg_rating 
from customer
group by item_purchased
order by avg_rating desc
limit 5;

#4. 4. Average purchase by shipping type
select shipping_type,round(avg(purchase_amount),2) as Avgpurchase 
from customer
group by shipping_type;

#5. Subscribers vs Non-subscribers (Avg + Total Revenue)
select subscription_status,
round(avg(purchase_amount),2) as Avg,
sum(purchase_amount) as Total_Revenue
from customer
group by subscription_status;

#6. Top 5 products with highest % of discounts

select item_purchased,
round(sum(discount_applied='Yes')*100/count(*),2) as discount_percentage
from customer
group by item_purchased
order by discount_percentage DESC
limit 5;

#7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 
with Customer_Segment as (
select customer_id,
CASE 
    WHEN previous_purchases=1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
end as Segment 
from customer
)
select segment,count(*) as NO_ofcustomers
from Customer_Segment
group by segment
order by NO_ofcustomers DESC;

# 8– Top 3 Most Purchased Products Within Each Category
with item_count as(
select category,item_purchased,count(*) as total_orders,ROW_NUMBER() over( PARTITION BY category order by count(*) DESC 
)AS RANKNO
from customer 
group by category,item_purchased
)
select category,item_purchased,total_orders
from item_count
where RANKNO<=3;

#9. Are Repeat Buyers Likely to Subscribe? Customers with more than 5 previous purchases — how many subscribed?

select subscription_status,
count(*) as Repeat_Buyers
from customer
where previous_purchases>=5
group by subscription_status;

#10 Revenue Contribution by Age Group
-- Find total revenue and revenue % contribution by each age group.



SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue,
    ROUND(
        SUM(purchase_amount) * 100.0 /
        SUM(SUM(purchase_amount)) OVER(),
        2
    ) AS revenue_percentage
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;
show databases;








