USE MarvestQoon5
--1 

--SELECT *FROM MsVendor
SELECT
 [VendorName] = vendor_Name,
 [VendorGender] = vendor_Gender,
 [VendorPhoneNumber] = vendor_PhoneNo,
 [EmployeeName] = employee_Name,
 CAST(COUNT(sales_ID) AS VARCHAR) + ' Transaction' AS 'Total Sales'
FROM MsVendor mv
JOIN  TrSalesHeader tsh
ON mv.vendor_ID = tsh.vendor_ID
JOIN MsEmployee me
ON me.employee_ID = tsh.employee_ID

WHERE
vendor_Name LIKE '%r%' OR vendor_Name LIKE '%R%' 

GROUP BY vendor_Name,employee_Name,vendor_Gender,vendor_PhoneNo

--2

SELECT
	[ProductName] = product_Name,
	CONVERT(DATETIME,sales_Date,7) AS [Sold Date],
	SUM(product_Qty) AS 'Total Product Sold'
FROM 
	TrSalesHeader  tsh
	JOIN TrsalesDetail tsd
	ON tsh.sales_ID = tsd.sales_ID
	JOIN Product p
	ON p.product_ID = tsd.product_ID
WHERE
	product_Name  like '%milk%'
	AND 
	DATEDIFF(MONTH,sales_Date,GETDATE()) >6
GROUP BY
	CAST(sales_Date AS DATE), product_Name

-- 3

SELECT
	[ProductName] = product_Name,
	DATENAME (MONTH,sales_Date) as 'Month Sold',
	CAST ( MIN(product_Qty) AS VARCHAR) + ' product(s)' AS 'Minimum Sold',
	CAST ( MAX(product_Qty) AS VARCHAR) + ' product(s)' AS 'Maximum Sold'
FROM
	TrSalesHeader tsh
	JOIN TrsalesDetail tsd
	ON tsh.sales_ID = tsd.sales_ID
	JOIN Product p
	ON p.product_ID = tsd.product_ID
WHERE
	DATEDIFF(MONTH,sales_Date,getDate()) <9
GROUP BY
	DATENAME (MONTH,sales_Date),product_Name 

--4
SELECT
	vendor_Name,vendor_Gender,
	LEFT (vendor_Gender,1) AS 'VendorGender',
	CAST (AVG(product_qty) AS VARCHAR) + ' product(s)' AS 'Avarage of Product Quantity',
	CAST (SUM(product_Qty)AS VARCHAR) + ' products(s)' AS 'Total Product Sold'
FROM 
	MsVendor mv
	JOIN TrSalesHeader tsh
	ON mv.vendor_ID = tsh.vendor_ID
	JOIN TrsalesDetail tsd
	ON tsh.sales_ID= tsd.sales_ID
WHERE 
	DATEDIFF(MONTH,sales_Date,GETDATE()) <= 9
GROUP BY 
	vendor_Name, vendor_Gender

--5
SELECT
	LEFT(product_Name,ISNULL(NULLIF(CHARINDEX(' ',product_Name),0), LEN(product_Name))) AS 'Name',
	'Rp.'+ CAST(product_Price AS VARCHAR) AS 'Product Price' 
FROM
	Product p
WHERE
	product_Price >(
	SELECT	 
		AVG(product_Price)
	FROM 
		Product
	)

--6

SELECT
	[Employee Name] = employee_Name,
	[Employeed Phone Number]=STUFF(employee_PhoneNo,1,1,'+62'),
	[Vendor Name] = vendor_Name,
	CONVERT(DATETIME,sales_Date,7) AS 'SalesDate'
	FROM MsEmployee me
	JOIN TrSalesHeader tsh
	ON me.employee_ID = tsh.employee_ID
	JOIN MsVendor mv
	ON mv.vendor_ID=tsh.vendor_ID
WHERE
	employee_Salary = (
	SELECT MIN(employee_Salary)
	FROM MsEmployee
	)
	AND DATEDIFF(MONTH,sales_Date,GETDATE()) <=12

--7

SELECT 
	[Vendor Name] = vendor_Name,
	LEFT(vendor_Gender,1) AS 'Gender',
	STUFF(vendor_PhoneNo, 1, 1, '+62') AS 'Phone Number'
FROM 
	MsVendor                                                       
WHERE 
	vendor_ID IN (
	SELECT 
		vendor_ID
	FROM 
		TrSalesHeader 
	WHERE 
		DATEDIFF(MONTH, sales_Date, GETDATE()) >= 12
	GROUP BY 
		vendor_ID
	HAVING COUNT(sales_ID) = 
	(
		SELECT 
			MAX(vn.trans)
		FROM (
			SELECT 
				COUNT(sales_ID) AS trans,
				vendor_ID
			FROM 
				TrSalesHeader
			WHERE 
				DATEDIFF(MONTH, sales_Date, GETDATE()) >= 12
			GROUP BY 
				vendor_ID
			)vn
		) 
	)

--SELECT * FROM MsVendor

--8

SELECT
	RIGHT(product_Name, ISNULL(NULLIF(CHARINDEX(' ',REVERSE(product_Name)), 0), LEN(product_Name))) AS 'Product Name',
	'Rp.' + CAST(Pricing.SellingPrice AS VARCHAR) AS 'Selling Price',
	'Rp.' + CAST(Pricing.ProductionPrice AS VARCHAR) AS 'Production Price',
	DifferentItemNeeded AS 'Different Item Needed'
FROM (
	SELECT
		Product_Name,
		Product_Price AS SellingPrice,
		SUM(item_Quantity * item_Price) AS ProductionPrice,
		COUNT(item_Name) AS DifferentItemNeeded
	FROM 
		Product p JOIN Recipe r
		ON 
		p.product_ID = r.product_ID
		JOIN MsItem mi
		ON 
		r.item_ID = mi.item_ID
	GROUP BY 
		product_Name ,product_Price
) Pricing
WHERE 
	Pricing.SellingPrice > Pricing.ProductionPrice

--9

CREATE VIEW [Sales Report] AS

SELECT
	[Employee Name] = employee_Name,
	STUFF(employee_PhoneNo,1,1,'62') AS 'Phone Number',
	COUNT(tsh.sales_ID) AS 'Total Sales',
	SUM(product_Qty) AS 'Total Product Sold'
FROM
	MsEmployee me
	JOIN TrSalesHeader tsh
	ON me.employee_ID = tsh.employee_ID
	JOIN TrsalesDetail tsd
	ON tsh.sales_ID = tsd.sales_ID
WHERE 
	DATEPART(YEAR, sales_Date) = 2017
GROUP BY 
	employee_Name, employee_PhoneNo


--SELECT *FROM [Sales Report]

--10

CREATE VIEW [Expense Report] AS
SELECT 
	Year,
	'Rp.' + CAST(TotalExpense AS VARCHAR) AS 'Total Expenses'

FROM (
	SELECT
		SUM(purchased_Item_Qty * item_Price) AS 'TotalExpense',
		YEAR(purchase_Date) AS 'YEAR'
	FROM 
		TrPurchase ttp
		JOIN MsItem mi
		ON ttp.item_ID = mi.item_ID
	GROUP BY 
		YEAR(purchase_Date)
) PurchaseTable

WHERE TotalExpense > (
	SELECT AVG(TotalExpense)
	FROM (
		SELECT
			SUM(purchased_Item_Qty * item_Price) AS 'TotalExpense'
		FROM 
			TrPurchase ttp
			JOIN MsItem mi
			ON ttp.item_ID = mi.item_ID
		GROUP BY 
			YEAR(purchase_Date)
	) temp
)


--SELECT * FROM [Expense Report]


