--See all the Data imported:-
SELECT * FROM blinkit_data


--Data Cleaning:-
UPDATE blinkit_data
SET Item_Fat_Content =
    CASE 
         WHEN Item_Fat_Content IN ('LF', 'low fat')  THEN  'Low Fat'
         WHEN Item_Fat_Content = 'reg' THEN 'Regular'
         ELSE Item_Fat_Content
     END


--Total Sales:-
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM blinkit_data


--Average Sales:-
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0))AS Avg_Sales
FROM blinkit_data


--No. of Items:-
SELECT COUNT(*) AS No_of_Items  FROM blinkit_data


--Average Ratings:-
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings FROM blinkit_data


--Total Sales by Fat Content:-
SELECT Item_Fat_Content, 
        CONCAT(CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)),' K') AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS Avg_Sales,
		COUNT(*) AS No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC


--Total Sales by Item Type:-
SELECT Item_Type, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) AS No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales_Thousands DESC


--Fat Content by Total Sales:-
SELECT Outlet_Location_Type,
       ISNULL ([Low Fat], 0) AS Low_Fat,
	   ISNULL ([Regular], 0) AS Regular
FROM
(    SELECT Outlet_Location_Type, Item_Fat_Content,
            CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands
	  FROM blinkit_data
	  GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS Source_Table
PIVOT
(
      SUM(Total_Sales_Thousands)
	  FOR Item_Fat_Content IN ( [Low Fat], [Regular])
) AS Pivot_Table
ORDER BY Outlet_Location_Type;


--Total Sales by Outlet Establishment:-
SELECT Outlet_Establishment_Year, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) AS No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year


--Percentage of Sales by Outlet Size:-
SELECT Outlet_Size,
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	   CAST(SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER() AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales Desc


--Sales by Outlet Location:-
SELECT Outlet_Location_Type, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) AS No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales_Thousands DESC


--All Metric By Outlet Type:-
SELECT Outlet_Type, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
		COUNT(*) AS No_of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Ratings
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales_Thousands DESC

 