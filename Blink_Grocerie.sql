--To conduct a comprehensive analysis of Blinkit's sales performance, customer satisfaction,
--and inventory distribution to identify key insights and opportunities for optimization using various KPIs and visualizations in Power BI.

select * from Blinkit_Data
select count (*) from Blinkit_Data

--Use UPDATE since part of the cleaning process 
update Blinkit_Data 
set Item_Fat_Content = 
case 
when Item_Fat_Content IN ( 'LF','low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end 

--Total sales
Select cast (sum(Total_Sales)/1000000 as decimal(10,2)) as Total_Sales_Millions from Blinkit_Data
--Avg total sales
select cast( AVG(Total_Sales) as decimal(10,0) ) as Avg_Sales from Blinkit_Data
--Total Items
Select count(Item_Identifier) from Blinkit_Data
--Avg rating
Select cast (AVG(Rating) as decimal(10,2)) as Avg_Rating from Blinkit_Data



--Total sales, number of items, avg_rating  by fat content 
Select Item_Fat_Content, cast (sum(Total_Sales)/1000 as decimal(10,2)) as Total_Sales_Thousands,cast( AVG(Total_Sales) as decimal(10,1) ) as Avg_Sales ,count ( Item_Fat_Content) as "Number of items", cast (AVG(Rating) as decimal(10,2)) as Avg_Rating   from Blinkit_Data
group by  Item_Fat_Content

--Total sales, number of items, avg_rating  by fat content when year = 2022
Select Item_Fat_Content, cast (sum(Total_Sales) as decimal(10,2)) as Total_Sales ,count ( Item_Fat_Content) as "Number of items", cast (AVG(Rating) as decimal(10,2)) as Avg_Rating   from Blinkit_Data
where Outlet_Establishment_Year = 2022
group by  Item_Fat_Content

--Total sales by item type 
Select top 5 Item_Type, cast (sum(Total_Sales)/1000 as decimal(10,2)) as Total_Sales_Thousands,cast( AVG(Total_Sales) as decimal(10,1) ) as Avg_Sales ,count ( Item_Fat_Content) as "Number of items", cast (AVG(Rating) as decimal(10,2)) as Avg_Rating   from Blinkit_Data
group by  Item_Type
order by cast (sum(Total_Sales)/1000 as decimal(10,2)) desc

-- Fat Content by Outlet for total sales 
Select  Outlet_Location_Type,Item_Fat_Content, cast (sum(Total_Sales)/1000 as decimal(10,2)) as Total_Sales_Thousands,cast( AVG(Total_Sales) as decimal(10,1) ) as Avg_Sales ,count ( Item_Fat_Content) as "Number of items", cast (AVG(Rating) as decimal(10,2)) as Avg_Rating   from Blinkit_Data
group by  Outlet_Location_Type,Item_Fat_Content
order by Total_Sales_Thousands asc


-- Compare total sales across different outlets segmented by fat content.
--Used PIVOT to use rows 'Low fat' and 'Regular' for the analysis 
--SUM for the total sales per segment by fat content
Select Outlet_Location_Type,[Low Fat],[Regular]
from( select Item_Fat_Content,Outlet_Location_Type , cast (sum(Total_Sales) as decimal (10,2)) as Total_Sales from Blinkit_Data 
group by Outlet_Location_Type,Item_Fat_Content)
as SourceTable 
PIVOT
(Sum (Total_Sales)
for Item_Fat_Content in ( [Regular], [Low Fat]))
as PivotTable
order by Outlet_Location_Type


--Total Sales by Outlet Establishment
select * from Blinkit_Data
select Outlet_Establishment_Year, cast (sum(Total_Sales) as decimal(10,2)) as Total_Sales  from Blinkit_Data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc

--Percentage of Sales by Outlet Size
select Outlet_Size, cast (sum(Total_Sales) as decimal(10,2)) as Total_Sales, cast(sum(Total_Sales)*100/ sum(sum(Total_Sales)) over() as decimal (10,2)) as 'Percentage' from Blinkit_Data
group by Outlet_Size
order by Outlet_Size asc

--Sales by Outlet Location
select Outlet_Location_Type, cast (sum(Total_Sales) as decimal(10,2)) as Total_Sales  from Blinkit_Data
group by Outlet_Location_Type
order by Outlet_Location_Type asc

--All Metrics by Outlet Type
select * from Blinkit_Data
Select Outlet_Type,cast (sum(Total_Sales) as decimal(10,2)) as Total_Sales,cast( AVG(Total_Sales) as decimal(10,1) ) as Avg_Sales, count(Item_Identifier) as Number_of_Items,cast (AVG(Rating) as decimal(10,2)) as Avg_Rating  from Blinkit_Data 
group by Outlet_Type
order by Total_Sales desc