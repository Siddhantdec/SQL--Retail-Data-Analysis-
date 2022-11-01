-----------------------------------BASIC SQL CASE STUDY-----------------------------------------------------------------------------------------------------------------------------------------------------

use [DB_Project_one]

select * from [dbo].[Customers]
select * from [dbo].[prod_cat_info]
select * from [dbo].[Transactions1]
select * from [dbo].[Transactions2]

-----------------------------DATA PREPARATION AND UNDERSTANDING----------------------------------------------------------------------------------------------------------------------------------

-- Total number of rows in each table.

select count(*) as Cust_rows from [dbo].[Customers] 
select count(*) as Prod_rows from [dbo].[prod_cat_info] 
select count(*) as Tran_rows from [dbo].[Transactions1]


-- Number of transactions that have a return

select count(transaction_id) as Transactions_returned from [dbo].[Transactions2]
where total_amt < 0
select * from [dbo].[Transactions2]
where total_amt < 0


-- Time range of the transaction data available for analysis.

select distinct year(tran_date) from [dbo].[Transactions1]

select distinct datename(month,tran_date) from [dbo].[Transactions1]

select tran_date, day(tran_date) as Days, month(tran_date) as Month, year(tran_date) as Years 
from [dbo].[Transactions1]


select tran_date from [dbo].[Transactions1]
order by tran_date desc


select top 1 datediff(year,'2011-01-02','2014-12-02') as Years,
datediff(month,'2011-01-02','2014-12-02') as Months,
datediff(day,'2011-01-02','2014-12-02') as Days from [dbo].[Transactions1]



SELECT DATEDIFF(year, '2011-01-02','2014-12-02')as Years,
DATEDIFF(month, '2011-01-02','2014-12-02')as Months,
DATEDIFF(day, '2011-01-02','2014-12-02')as Days 
  
select * from [dbo].[Transactions1]
select distinct year(tran_date) from [dbo].[Transactions1]

select distinct datename(month,tran_date) from [dbo].[Transactions1]

select tran_date, day(tran_date) as Days, month(tran_date) as Month, year(tran_date) as Years 
from [dbo].[Transactions1]


select tran_date from [dbo].[Transactions1]
order by tran_date desc


select top 1 datediff(year,'2011-01-02','2014-12-02') as Years,
datediff(month,'2011-01-02','2014-12-02') as Months,
datediff(day,'2011-01-02','2014-12-02') as Days from [dbo].[Transactions1]


SELECT DATEDIFF(year, '2011-01-02','2014-12-02')as Years,
DATEDIFF(month, '2011-01-02','2014-12-02')as Months,
DATEDIFF(day, '2011-01-02','2014-12-02')as Days 


-- The product category does the sub-category DIY belong to?

select prod_subcat, prod_cat from [dbo].[prod_cat_info]
where prod_subcat ='DIY'

-------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------DATA ANALYSIS---------------------------------------------------------------------------------

--1. The most frequently used channel for transaction.


select top 1 Store_type, count(store_type) as Count_of_stores from [dbo].[Transactions1]
group by store_type 
order by Count_of_stores desc



--2. Count of male and female customers in the database

update [dbo].[Customers]
set gender = 'Unknown'
where gender = ' '

select top 2 (gender), count(gender) as Total_count from [dbo].[Customers]
group by gender
order by case when gender = 'M' then 1
when gender = 'F' then 2
else 3
end


--3. city having the maximum number of customers from the database

select top 1 (city_code), count(city_code) as Count_city from [dbo].[Customers]
group by city_code
order by Count_city desc


--4. number of sub-categories under category Books

select prod_cat, count(prod_subcat) as No_of_subcat  from [dbo].[prod_cat_info]
where prod_cat = 'Books'
group by prod_cat

select prod_cat, prod_subcat from [dbo].[prod_cat_info]
where prod_cat = 'Books'


--5. maximum quantity of products ever ordered

select top 1(tran_date), count(prod_cat) as No_of_products from [dbo].[Transactions1] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code
group by tran_date
order by No_of_products desc


--Check the products ordered on that particular day.

select tran_date, prod_cat, prod_subcat from [dbo].[Transactions1] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_subcat_code = P.prod_sub_cat_code
where tran_date = '2012-08-25'
order by prod_cat,prod_subcat
 

--6. net total revenue for Books and Electronics
 
select sum(total_amt) as Total_amount from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_subcat_code = P.prod_sub_cat_code
where prod_cat in ('Books','Electronics')


--7. number of customers having more than 10 transactions,excluding the returns.

with ABC
as (select cust_id ,count(transaction_id)as Count_of_trans from [dbo].[Transactions2]
where total_amt > 0 
group by cust_id
having count(transaction_id)>10)
select count(cust_id) as Num_of_customers from ABC


--8. Combined revenue earned from Electronics and Clothing categories from Flagship stores.

use [DB_Project_one]
--select prod_subcat, count(prod_cat) as Counting from [dbo].[Transactions1] as T
--inner join [dbo].[prod_cat_info] as P 
--on T. prod_cat_code = P.prod_cat_code
--where prod_cat in ('Electronics','Clothing')
--group by prod_subcat
--order by Counting desc


select sum(total_amt) as Total_Amount from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P 
on T. prod_subcat_code = P.prod_sub_cat_code
where prod_cat in ('Electronics','Clothing') and store_type = 'Flagship store'


--9. Total revenue generated from Male customers in Electronics category. 

select sum(total_amt) as Amount_ME from [dbo].[Transactions2] as T
inner join [dbo].[Customers] as C
on T.cust_id = C.customer_Id
inner join [dbo].[prod_cat_info] as P 
on P.prod_sub_cat_code = T.prod_subcat_code
where gender = 'M' and prod_cat = 'Electronics'

select prod_subcat,sum(total_amt) as Amount_ME from [dbo].[Transactions2] as T
inner join [dbo].[Customers] as C
on T.cust_id = C.customer_Id
inner join [dbo].[prod_cat_info] as P 
on P.prod_cat_code = T.prod_cat_code
where gender = 'M' and prod_cat = 'Electronics'
group by prod_subcat



--10. Percentage of sales and returns by product sub category.

select top 5 (prod_subcat),sum(total_amt) as Sales_amount from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code
where T.total_amt > 0
group by prod_subcat
order by Sales_amount desc



with perABS 
as(select top 5 (prod_subcat), 
    ABS(sum(case when Qty < 0 then Qty else 0 end)) as Returns, 
    sum(case when Qty > 0 then Qty else 0 end) as Sales
from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code
group by prod_subcat
order by Sales desc)
select prod_subcat,round(((Returns /(Returns + Sales))*100),2) as Return_percent,
round(((Sales /(Returns + Sales))*100),2) as Sales_percent from perABS


--11. finding the total revenue generated by customers aged between 25 to 35 in the last 30 
-- days of transactions.

select top 30 (tran_date) from [dbo].[Transactions2]
group by tran_date
order by tran_date desc


with ABC 
as(select top 30 (tran_date), sum(total_amt) as Total_amount from [dbo].[Customer] as C
inner join [dbo].[Transactions2] as T
on T.cust_id = C.customer_id
where datediff(year,DOB,getdate()) between 25 and 35
group by tran_date
order by tran_date desc)
select sum(Total_amount) as Final_revenue from ABC



--12. product category having maximum number of returns in last three months

select prod_cat,count(Qty) as No_of_returns
from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code
where total_amt < 0 and datediff(month,'2014-09-01',tran_date)= 3
group by prod_cat 

-- product category having maximum value of returns in last three months

with ABC 
as(select prod_cat,transaction_id,total_amt
from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code 
where total_amt <0 and datediff(month,'2014-09-01',tran_date)= 3)
select abs(sum(total_amt)) as Return_amount_cat from ABC


--product subcategories having maximum number of returns in last three months

select prod_cat,count(Qty) as No_of_ids_return
from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_subcat_code = P.prod_sub_cat_code
where total_amt < 0 and datediff(month,'2014-09-01',tran_date)= 3
group by prod_cat

-- product subcategories having maximum value of returns in last three months

with ABC 
as(select prod_cat,Qty,total_amt
from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_subcat_code = P.prod_sub_cat_code 
where total_amt <0 and datediff(month,'2014-09-01',tran_date)= 3)
select abs(sum(total_amt)) as Return_value_subcat from ABC




--13. store-type selling maximum quantity of products in value as well as quantity sold

select top 1(Store_type),count(Qty) as No_of_products,
sum(total_amt) as Amount from [dbo].[Transactions2]
where total_amt > 0
group by Store_type
order by No_of_products desc


--14. Product categories having average revenues greater than the overall average revenue.

select prod_cat,round(avg(total_amt), 2) as Averages from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code
group by prod_cat
having avg(total_amt) > (select avg(total_amt) from [dbo].[Transactions2])

--Product subcategories having average revenues greater than the overall average revenue.

select P.prod_subcat,round(avg(total_amt),2) as Averages from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_subcat_code = P.prod_sub_cat_code
group by prod_subcat
having avg(total_amt) > (select avg(total_amt) from [dbo].[Transactions2])
order by Averages desc



--15. average and total revenue by each subcategory belonging to top five categories as 
-- per quantity sold.

select top 5(prod_cat),count(Qty)as Quantity_sold from [dbo].[Transactions2] T
inner join [dbo].[prod_cat_info] P
on T.prod_cat_code = T. prod_cat_code
where total_amt > 0
group by prod_cat
order by Quantity_sold desc
select prod_cat, prod_subcat,
round(sum(total_amt),3) as Total_amount,round(avg(total_amt),3) as Avg_amount from [dbo].[Transactions2] as T
inner join [dbo].[prod_cat_info] as P
on T.prod_cat_code = P.prod_cat_code
where total_amt > 0 and prod_cat in ('Books','Electronics','Home and kitchen','Footwear','Clothing') 
group by prod_cat, prod_subcat
order by case when prod_cat = 'Books' then 1
              when prod_cat = 'Electronics' then 2
			  when prod_cat = 'Home and kitchen' then 3
			  when prod_cat = 'Footwear' then 4
			  else 5
			  end

