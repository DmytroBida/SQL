USE [DataBase]
GO

CREATE OR ALTER VIEW vw_View_name_total
AS
SELECT *, CASE WHEN [STATUS] = 'B' AND AUTH > REFILL THEN 'GREEN'
               WHEN [STATUS] = 'B' AND AUTH = REFILL THEN 'YELLOW'
			   ELSE 'ORANGE' END AS Color
FROM TableName
WHERE EmployeeName = 'Employee Name'

CREATE OR ALTER VIEW vw_View_name_cust
AS
SELECT ISNULL(CustomerName, 'Grand Total') AS Customer, [STATUS], COUNT(ORDNO) AS OrdCount, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE EmployeeName = 'Employee Name'
GROUP BY ROLLUP(CustomerName), [STATUS]

CREATE OR ALTER VIEW vw_View_name_GrandTotals
AS
SELECT ISNULL([STATUS]), 'Grand Total') AS [STATUS], COUNT(ORDNO) AS OrdCount_Total, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE EmployeeName = 'Employee Name'
GROUP BY ROLLUP([STATUS])


CREATE OR ALTER VIEW vw_View_name_status
AS
SELECT [STATUS], Status_delivery, COUNT(ORDNO) AS OrdCount, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE EmployeeName = 'Employee Name'
GROUP BY [STATUS], Status_Delivery

CREATE OR ALTER VIEW vw_View_name_newCust
AS
WITH CTE
AS(
SELECT *, CASE WHEN [STATUS] = 'B' AND AUTH > REFILL THEN 'GREEN'
               WHEN [STATUS] = 'B' AND AUTH = REFILL THEN 'YELLOW'
			   ELSE 'ORANGE' END AS Color, ROW_NUMBER() OVER(PARTITION BY CustomerName ORDER BY CustomerName DESC) AS RNK
FROM TableName
WHERE EmployeeName = 'Employee Name' AND new_pt IS NOT NULL AND [STATUS] = 'B'
)
SELECT *
FROM CTE
WHERE RNK = 1

CREATE OR ALTER VIEW vw_View_name_NewPtTotals
AS
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE EmployeeName = 'Employee Name' AND new_pt IS NOT NULL AND [STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
ORDER BY GROUPING(EmployeeName), 2 DESC OFFSET 0 ROWS