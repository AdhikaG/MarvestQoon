CREATE DATABASE MarvestQoon5
USE MarvestQoon5
DROP DATABASE MarvestQoon5

--SELECT *FROM MsEmployee
--BEGIN TRAN
CREATE TABLE MsEmployee ( 
	employee_ID CHAR(6) PRIMARY KEY CHECK (employee_ID LIKE 'EMP[0-9][0-9][0-9]'),
	employee_Name VARCHAR(255),
	employee_Gender VARCHAR(255) CHECK(employee_Gender IN('Female' , 'Male')),
	employee_PhoneNo VARCHAR (12) CHECK (employee_PhoneNo 
	LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ), 
	--employee_PhoneNo VARCHAR (12) CHECK (employee_PhoneNo NOT LIKE'%[^0-9]%' ), 
	employee_Address VARCHAR(255),
	employee_Salary INT
)

CREATE TABLE MsVendor  ( 
	vendor_ID CHAR(6) PRIMARY KEY,
	vendor_Name VARCHAR(255),
	vendor_Gender VARCHAR(255) CHECK(vendor_Gender IN('Female' , 'Male')),
	vendor_PhoneNo VARCHAR (12) CHECK (vendor_PhoneNo 
	LIKE'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ), 
	--vendor_PhoneNo VARCHAR (12) CHECK (vendor_PhoneNo NOT LIKE'%[^0-9]%' ), 
	vendor_Adrress VARCHAR(255)
)


CREATE TABLE MsItem (
	item_ID	CHAR (6) PRIMARY KEY CHECK (item_ID LIKE 'ITE[0-9][0-9][0-9]'),
	item_Name VARCHAR(255),
	item_Stock INT,
	item_Price INT
)


CREATE TABLE Product (
	product_ID CHAR(6) PRIMARY KEY CHECK(product_ID LIKE('PRO[0-9][0-9][0-9]')),
	product_Name VARCHAR(255),
	product_Stock INT,
	product_Price INT
)

CREATE TABLE Recipe ( 
	product_ID CHAR(6)  FOREIGN KEY REFERENCES Product (product_ID),
	item_ID CHAR(6) FOREIGN KEY REFERENCES MsItem(item_ID),
	item_Quantity INT
	primary key (product_ID,item_ID)
)


		
CREATE TABLE TrPurchase ( 
	purchase_ID CHAR(6) PRIMARY KEY CHECK(purchase_ID LIKE 'PUR[0-9][0-9][0-9]'),
	employee_ID CHAR(6) FOREIGN KEY REFERENCES MsEmployee(employee_ID),
	vendor_ID CHAR(6) FOREIGN KEY REFERENCES MsVendor(vendor_ID),
	item_ID	CHAR(6) FOREIGN KEY REFERENCES MsItem(item_ID),
	purchase_Date DATE CHECK(DATENAME(weekday,purchase_Date ) NOT LIKE 'SUNDAY'),
	purchased_Item_Qty INT
)


CREATE TABLE TrSalesHeader ( 
	sales_ID CHAR(6) PRIMARY KEY CHECK (sales_ID LIKE 'SAL[0-9][0-9][0-9]'),
	employee_ID CHAR(6)FOREIGN KEY REFERENCES MsEmployee(employee_ID),
	vendor_ID CHAR(6)FOREIGN KEY REFERENCES MsVendor(vendor_ID),
	sales_Date DATE CHECK(DATENAME(weekday,sales_Date ) NOT LIKE 'SUNDAY'),
)


CREATE TABLE TrsalesDetail (	
	sales_ID CHAR(6)   FOREIGN KEY REFERENCES TrSalesHeader(sales_ID) ,
	product_ID CHAR(6) FOREIGN KEY REFERENCES Product(product_ID),
	product_Qty INT,
	PRIMARY KEY ( sales_ID , product_ID)
)


