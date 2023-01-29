SELECT *
FROM portfolio..energy

-- Some rows are with NULL in transportation column, lets replace It

UPDATE portfolio..energy
SET transportation = CASE WHEN transportation IS NULL THEN 0 ELSE transportation END

-- Create new columns with YoY metrics

SELECT [Year], [State], [Industry Sector Category], residential, commercial, industrial, transportation, other, total,
          ROUND((residential-LAG(residential, 1, Residential) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Residental_YoY_diff,
          ROUND((commercial-LAG(commercial, 1, commercial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Commercial_YoY_diff,
		  ROUND((industrial-LAG(industrial, 1, industrial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Industrial_YoY_diff,
		  ROUND((transportation-LAG(transportation, 1, transportation) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Transportation_YoY_diff,
		  ROUND((other-LAG(other, 1, other) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Other_YoY_diff,
		  ROUND((total-LAG(total, 1, total) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Total_YoY_diff
FROM portfolio..energy


-- Create new data tables with different industry sector category

SELECT DISTINCT([industry sector category])
FROM portfolio..energy

SELECT DISTINCT([state])
FROM portfolio..energy

SELECT [Year], [State], [Industry Sector Category], residential, commercial, industrial, transportation, other, total,
          ROUND((residential-LAG(residential, 1, Residential) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Residental_YoY_diff,
          ROUND((commercial-LAG(commercial, 1, commercial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Commercial_YoY_diff,
		  ROUND((industrial-LAG(industrial, 1, industrial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Industrial_YoY_diff,
		  ROUND((transportation-LAG(transportation, 1, transportation) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Transportation_YoY_diff,
		  ROUND((other-LAG(other, 1, other) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Other_YoY_diff,
		  ROUND((total-LAG(total, 1, total) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Total_YoY_diff
INTO portfolio..total_electric_industry
FROM portfolio..energy
WHERE [Industry Sector Category] = 'Total Electric Industry'

SELECT [Year], [State], [Industry Sector Category], residential, commercial, industrial, transportation, other, total,
          ROUND((residential-LAG(residential, 1, Residential) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Residental_YoY_diff,
          ROUND((commercial-LAG(commercial, 1, commercial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Commercial_YoY_diff,
		  ROUND((industrial-LAG(industrial, 1, industrial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Industrial_YoY_diff,
		  ROUND((transportation-LAG(transportation, 1, transportation) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Transportation_YoY_diff,
		  ROUND((other-LAG(other, 1, other) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Other_YoY_diff,
		  ROUND((total-LAG(total, 1, total) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Total_YoY_diff
INTO portfolio..restructured_retail
FROM portfolio..energy
WHERE [Industry Sector Category] = 'Restructured Retail Service Providers'

SELECT [Year], [State], [Industry Sector Category], residential, commercial, industrial, transportation, other, total,
          ROUND((residential-LAG(residential, 1, Residential) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Residental_YoY_diff,
          ROUND((commercial-LAG(commercial, 1, commercial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Commercial_YoY_diff,
		  ROUND((industrial-LAG(industrial, 1, industrial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Industrial_YoY_diff,
		  ROUND((transportation-LAG(transportation, 1, transportation) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Transportation_YoY_diff,
		  ROUND((other-LAG(other, 1, other) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Other_YoY_diff,
		  ROUND((total-LAG(total, 1, total) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Total_YoY_diff
INTO portfolio..delivery_service
FROM portfolio..energy
WHERE [Industry Sector Category] = 'Delivery-Only Service'

SELECT [Year], [State], [Industry Sector Category], residential, commercial, industrial, transportation, other, total,
          ROUND((residential-LAG(residential, 1, Residential) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Residental_YoY_diff,
          ROUND((commercial-LAG(commercial, 1, commercial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Commercial_YoY_diff,
		  ROUND((industrial-LAG(industrial, 1, industrial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Industrial_YoY_diff,
		  ROUND((transportation-LAG(transportation, 1, transportation) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Transportation_YoY_diff,
		  ROUND((other-LAG(other, 1, other) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Other_YoY_diff,
		  ROUND((total-LAG(total, 1, total) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Total_YoY_diff
INTO portfolio..energy_providers
FROM portfolio..energy
WHERE [Industry Sector Category] = 'Energy-Only Providers'

SELECT [Year], [State], [Industry Sector Category], residential, commercial, industrial, transportation, other, total,
          ROUND((residential-LAG(residential, 1, Residential) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Residental_YoY_diff,
          ROUND((commercial-LAG(commercial, 1, commercial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Commercial_YoY_diff,
		  ROUND((industrial-LAG(industrial, 1, industrial) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Industrial_YoY_diff,
		  ROUND((transportation-LAG(transportation, 1, transportation) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Transportation_YoY_diff,
		  ROUND((other-LAG(other, 1, other) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Other_YoY_diff,
		  ROUND((total-LAG(total, 1, total) OVER (PARTITION BY [state], [industry sector category] ORDER BY [industry sector category], [year])), 3) AS Total_YoY_diff
INTO portfolio..full_sirvice_providers
FROM portfolio..energy
WHERE [Industry Sector Category] = 'Full-Service Providers'