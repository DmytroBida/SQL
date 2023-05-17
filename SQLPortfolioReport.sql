
--Report

CREATE OR ALTER VIEW vw_Name_report
AS
WITH CTE
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, COUNT(DISTINCT(CustomerName)) AS CustCount,
ROUND(CAST(COUNT(OrdID) AS float)/CAST(COUNT(DISTINCT(CustomerName)) AS float), 2) AS [Avg Ord per Cust],
ROUND(CAST(COUNT(DISTINCT(CustomerName)) AS float) / CAST(SELECT COUNT(DISTINCT(CustomerName))
                                                          FROM TableName
														  WHERE [STATUS] = 'B') AS float), 4) AS Persentage
FROM TableName
WHERE STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
),
CTE1
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, COUNT(DISTINCT(CustomerName)) AS New_cust
FROM TableName
WHERE [STATUS] = 'B' AND new_cust = 'new cust'
GROUP BY ROLLUP(EmployeeName)
),
CTE2
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, COUNT(DISTINCT(CustomerName)) AS [New cust PAIN]
FROM TableName
WHERE [STATUS] = 'B' AND New_cust = 'new cust' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
),
CTE3
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, COUNT(DISTINCT(CustomerName)) AS [Total cust PAIN]
FROM TableName
WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
),
CTE4
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, ROUND(CAST(COUNT(OrdID) AS float)/CAST(COUNT(DISTINCT(CustomerName)) AS float), 2) AS [Avg Ord per pain Cust]
FROM TableName
WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
),
CTE5
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, COUNT(DISTINCT(MD_name)) AS [Total MD]
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
),
CTE6
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee,
ROUND(CAST(COUNT(DISTINCT(CustomerName)) AS float)/CAST(COUNT(DISTINCT(MD_name)) AS float), 2) AS [Avg Cust per MD]
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
)
SELECT a.EmployeeName,
a.[CustCount],
a.Persentage AS [Share, total Cust],
c.Persentage AS [Net change Cust],
b.[New cust],
e.[Growth new cust %],
g.[Rescued Cust],
f.[Lost cust],
a.[Avg Ord per Cust],
d.[Total pain cust],
h.[Share, pain cust in total cust],
j.[Net change pain cust %],
k.[New pain cust],
l.[Growth new pain cust %],
m.[Rescued Pain cust],
n.[Lost pain cust],
o.[Avg Ord per pain cust],
p.[MD with 1-4 cust],
q.[MD with 5-9 cust],
r.[MD with 10-19 cust],
s.[MD with 20-39 cust],
t.[MD with 40-99 cust],
y.[MD with 100+ cust],
w.[Total MD*],
x.[Newt Change MD %],
z.[Avg cust per MD]
FROM CTE a LEFT JOIN CTE1 b ON a.EmployeeName = b.EmployeeName
		   LEFT JOIN vw_Persentage c ON a.EmployeeName = c.EmployeeName
		   LEFT JOIN CTE3 d ON a.EmployeeName = d.EmployeeName
		   LEFT JOIN vw_Persentage_newCust e ON a.EmployeeName = e.EmployeeName
		   LEFT JOIN vw_Lost_cust f a.EmployeeName = f.EmployeeName
		   LEFT JOIN vw_Rescued_cust g ON a.EmployeeName = g.EmployeeName
		   LEFT JOIN vw_Persentage_pain h ON a.EmployeeName = h.EmployeeName
		   LEFT JOIN vw_Persentage_pain_net j ON a.EmployeeName = j.EmployeeName
		   LEFT JOIN CTE2 k ON a.EmployeeName = k.EmployeeName
		   LEFT JOIN vw_Persentage_newCust_change l ON a.EmployeeName = l.EmployeeName
		   LEFT JOIN vw_Rescued_PainCust m ON a.EmployeeName = m.EmployeeName
		   LEFT JOIN vw_CTE4 o ON a.EmployeeName = O.EmployeeName
		   LEFT JOIN vw_Cust_count_4 p ON a.EmployeeName = p.EmployeeName
		   LEFT JOIN vw_Cust_count_9 q ON a.EmployeeName = q.EmployeeName
		   LEFT JOIN vw_Cust_count_19 r ON a.EmployeeName = r.EmployeeName
		   LEFT JOIN vw_Cust_count_39 s ON a.EmployeeName = s.EmployeeName
		   LEFT JOIN vw_Cust_count_99 t ON a.EmployeeName = t.EmployeeName
		   LEFT JOIN vw_Cust_count_100 y ON a.EmployeeName = y.EmployeeName
		   LEFT JOIN CTE5 w ON a.EmployeeName = w.EmployeeName
		   LEFT JOIN vw_MD_change x ON a.EmployeeName = x.EmployeeName
		   LEFT JOIN CTE6 z ON ON a.EmployeeName = z.EmployeeName

---View for persentage change between current month and previous month

CREATE OR ALTER VIEW vw_Persentage
AS
WITH CTE
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [Cust count]
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
),
CTE1
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [Cust count2]
FROM TableName2
WHERE [STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
)
SELECT a.EmployeeName, ROUND((a.[Cust Count]*100/b.[Cust count2])-100)/100, 4) AS Persentage
FROM CTE a LEFT JOIN CTE1 b ON a.EmployeeName = b.EmployeeName

----View for persentage pain cust

CREATE OR ALTER VIEW vw_Persentage_pain_cust
AS 
WITH CTE
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [Cust PAIN count]
FROM TableName
WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
),
CTE1
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [Cust count]
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY ROLLUP(EmployeeName)
)
SELECT a.EmployeeName, ROUND((a.[Cust PAIN Count]*100/b.[Cust count])/100), 4) AS Persentage
FROM CTE a LEFT JOIN CTE1 b ON a.EmployeeName = b.EmployeeName


---View fro persentage change new cust between current and previous month

CREATE OR ALTER VIEW vw_Persentage_newCust
AS
WITH CTE
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [new cust]
FROM TableName
WHERE [STATUS] = 'B' AND new_cust = 'New cust'
GROUP BY ROLLUP(EmployeeName)
),
CTE1
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [new cust]
FROM TableName2
WHERE [STATUS] = 'B' AND new_cust = 'New cust'
GROUP BY ROLLUP(EmployeeName)
)
SELECT a.EmployeeName, ROUND((a.[new cust]/b.[new cust])-1), 4) AS P[Growth new cust %]
FROM CTE a LEFT JOIN CTE1 b ON a.EmployeeName = b.EmployeeName

--View for new cust pain change

CREATE OR ALTER VIEW vw_Persentage_newCust
AS
WITH CTE
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [new cust]
FROM TableName
WHERE [STATUS] = 'B' AND new_cust = 'New cust' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
),
CTE1
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [new cust]
FROM TableName2
WHERE [STATUS] = 'B' AND new_cust = 'New cust' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
)
SELECT a.EmployeeName, ROUND((a.[new cust]/b.[new cust])-1), 4) AS P[Growth new PAIN cust %]
FROM CTE a LEFT JOIN CTE1 b ON a.EmployeeName = b.EmployeeName

--Lost customers count view

CREATE OR ALTER VIEW vw_Lost_cus
AS
WITH CTE
AS(
SELECT DISTINCT(CustomerName), ISNULL(EmployeeName, 'Grand Total') AS Employee
FROM TableName2
WHERE [STATUS] = 'B' AND CustomerName NOT IN (SELECT DISTINCT(CustomerName)
                                              FROM TableName
											  WHERE [STATUS] = 'B')
)
SELECT Employee, COUNT(CustomerName) AS [lost cust]
FROM CTE
GROUP BY Employee

---Rescued customers count

CREATE OR ALTER VIEW wv_Rescued_Cust
AS
WITH CTE 
AS(
SELECT DISTINCT(CustomerName), ISNULL(EmployeeName, 'Grand Total') AS Employee
FROM TableName
WHERE [STATUS] = 'B' AND CustomerName NOT IN (SELECT DISTINCT(CustomerName)
                                              FROM TableName2
											  WHERE DATEF BETWEEN '2023-03-01' AND '2023-03-31') AND CustomerName IN (SELECT DISTINCT(CustomerName)
											                                                                          FROM TableName2
																													  WHERE DATEF BETWEEN '2022-05-01' AND '2023-02-28')
)
SELECT Employee, COUNT(CustomerName) AS [Rescued Cust]
FROM CTE
GROUP BY Employee


----View for NET change persentage PAIN

CREATE OR ALTER VIEW vw_Persentage_pain_net
AS
WITH CTE
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [cust count]
FROM TableName
WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
),
CTE1
AS(
SELECT ISNULL(EmployeeName, 'Grand Total') AS Employee, CAST(COUNT(DISTINCT(CustomerName)) AS float) AS [cust count]
FROM TableName2
WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%'
GROUP BY ROLLUP(EmployeeName)
)
SELECT a.EmployeeName, ROUND((a.[cust count]*100/b.[cust count]*100)/100, 4) AS P[NET change PAIN cust %]
FROM CTE a LEFT JOIN CTE1 b ON a.EmployeeName = b.EmployeeName

--View for Lost PAIN cust

CREATE OR ALTER VIEW vw_Lost_PainCut
AS
WITH CTE
AS(
SELECT DISTINCT(CustomerName), ISNULL(EmployeeName, 'Grand Total') AS Employee
FROM TableName2
WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%' AND CustomerName NOT IN (SELECT DISTINCT(CustomerName)
                                              FROM TableName
											  WHERE [STATUS] = 'B' AND PRODUCTNAME LIKE '%.P#%')
)
SELECT Employee, COUNT(CustomerName) AS [lost PAIN cust]
FROM CTE
GROUP BY Employee

---View for MD with customers

CREATE OR ALTER VIEW vw_cust_count4
AS
WITH CTE
AS(
SELECT DISTINCT(MD_name), EmployeeName, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY MD_name, Employee
)
SELECT Employee, COUNT(MD_name) AS [MD with 1-4 Cust]
FROM CTE
WHERE CustCouns BETWEEN 1 AND 4
GROUP BY EmployeeName

CREATE OR ALTER VIEW vw_cust_count9
AS
WITH CTE
AS(
SELECT DISTINCT(MD_name), EmployeeName, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY MD_name, Employee
)
SELECT Employee, COUNT(MD_name) AS [MD with 1-4 Cust]
FROM CTE
WHERE CustCouns BETWEEN 5 AND 9
GROUP BY EmployeeName

CREATE OR ALTER VIEW vw_cust_count19
AS
WITH CTE
AS(
SELECT DISTINCT(MD_name), EmployeeName, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY MD_name, Employee
)
SELECT Employee, COUNT(MD_name) AS [MD with 1-4 Cust]
FROM CTE
WHERE CustCouns BETWEEN 10 AND 19
GROUP BY EmployeeName


CREATE OR ALTER VIEW vw_cust_count39
AS
WITH CTE
AS(
SELECT DISTINCT(MD_name), EmployeeName, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY MD_name, Employee
)
SELECT Employee, COUNT(MD_name) AS [MD with 1-4 Cust]
FROM CTE
WHERE CustCouns BETWEEN 20 AND 39
GROUP BY EmployeeName

CREATE OR ALTER VIEW vw_cust_count99
AS
WITH CTE
AS(
SELECT DISTINCT(MD_name), EmployeeName, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY MD_name, Employee
)
SELECT Employee, COUNT(MD_name) AS [MD with 1-4 Cust]
FROM CTE
WHERE CustCouns BETWEEN 40 AND 99
GROUP BY EmployeeName

CREATE OR ALTER VIEW vw_cust_count100
AS
WITH CTE
AS(
SELECT DISTINCT(MD_name), EmployeeName, COUNT(DISTINCT(CustomerName)) AS CustCount
FROM TableName
WHERE [STATUS] = 'B'
GROUP BY MD_name, Employee
)
SELECT Employee, COUNT(MD_name) AS [MD with 1-4 Cust]
FROM CTE
WHERE CustCouns >=100
GROUP BY EmployeeName

--View for MD change between current and previous month

CREATE OR ALTER VIEW vw_MD_change
AS
SELECT a.EmployeeName, ROUND(((a.MD_name*100/b.MD_name))-100/100, 4) AS [Net change MD %]
FROM Table3 a LEFT JOIN Table4 b ON a.EmployeeName = b.EmployeeName