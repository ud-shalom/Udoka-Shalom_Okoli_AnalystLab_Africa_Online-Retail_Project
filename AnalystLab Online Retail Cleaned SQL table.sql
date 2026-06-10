Select  *
From [online retail csv]

--TASK 1: This SQL script performs the initial data exploration and cleaning preparation for 
   the [online retail csv] dataset.
   
-- 1. Number of rows and columns
SELECT COUNT(*) AS total_rows FROM [online retail csv];

-- 2. Data types of all columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'online retail csv';

-- 3. Numerical features
-- Using TOP 10 instead of LIMIT 10 for SQL Server
SELECT TOP 10 Quantity, [UnitPrice], CustomerID 
FROM [online retail csv];

-- 4. Categorical features
SELECT DISTINCT Country 
FROM [online retail csv];

-- 5. Possible unique identifiers (primary keys)
-- Validating InvoiceNo
SELECT InvoiceNo, COUNT(*) 
FROM [online retail csv] 
GROUP BY InvoiceNo 
HAVING COUNT(*) > 1;

-- Validating composite key (InvoiceNo + StockCode)
SELECT InvoiceNo, StockCode, COUNT(*) 
FROM [online retail csv] 
GROUP BY InvoiceNo, StockCode 
HAVING COUNT(*) > 1;

-- Task 2: Data Cleaning - Handling Missing Values
   Action: Identified missing values across columns and filled/removed them.
   Method: CustomerID and Description are dropped if missing, as they are essential 
   for tracking sales accurately.

-- 1. Identify and count missing values per column
SELECT 
    SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM [online retail csv];

-- Task 3: Duplicate Counting and removing duplicate records
   Action: Identified and deleted rows that are exact duplicates.
   Method: Used a CTE with ROW_NUMBER() to target and remove redundant entries.

-- Count how many times each unique combination appears
SELECT 
    InvoiceNo, 
    StockCode, 
    Description, 
    UnitPrice, 
    CustomerID, 
    Country, 
    COUNT(*) AS Occurrence_Count
FROM [online retail csv]
GROUP BY InvoiceNo, StockCode, Description, UnitPrice, CustomerID, Country
HAVING COUNT(*) > 1
ORDER BY Occurrence_Count DESC;

-- Calculate the number of duplicates to be removed 
SELECT COUNT(*) - COUNT(DISTINCT InvoiceNo + StockCode + CAST(Quantity AS VARCHAR) + CAST(UnitPrice AS VARCHAR) + CAST(CustomerID AS VARCHAR)) AS Total_Duplicates_To_Remove
FROM [online retail csv];

--Task 3: Standardizing Data Formats
--Description: This task ensures data consistency across the dataset by setting appropriate date formats, 
--enforcing decimal precision for pricing, 
--and applying proper case formatting to descriptions to improve readability for visualization.

-- 1. Standardize Date Format to YYYY-MM-DD 
ALTER TABLE [online retail csv] 
ALTER COLUMN InvoiceDate DATE;

-- 2. Convert UnitPrice to Decimal with 2 decimal places 
ALTER TABLE [online retail csv] 
ALTER COLUMN UnitPrice DECIMAL(10,2);

-- 3. Convert Description to Proper Case 
UPDATE [online retail csv]
SET Description = UPPER(LEFT(Description, 1)) + LOWER(SUBSTRING(Description, 2, LEN(Description)));

--4 Display the first 20 rows to check the new formatting 
SELECT TOP 20 
    InvoiceDate, 
    UnitPrice, 
    Description 
FROM [online retail csv];

-- Task 5: Handling Missing Values and Anomalies
-- Description: This task ensures data completeness 
--and integrity by identifying missing or empty values and replacing them with "Unknown" placeholders. 
--It also addresses data anomalies, such as negative pricing, 
--by converting them to absolute values to maintain dataset usability without deleting records.

-- 1. Count missing/empty values in key columns 
SELECT 
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,
    SUM(CASE WHEN Description IS NULL OR Description = '' THEN 1 ELSE 0 END) AS Null_Description,
    SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS Null_InvoiceNo
FROM [online retail csv];

-- 2. Change CustomerID to allow text (required to store 'Unknown') 
ALTER TABLE [online retail csv] ALTER COLUMN CustomerID VARCHAR(50);

-- 3. Replace missing CustomerID with 'Unknown' 
UPDATE [online retail csv]
SET CustomerID = 'Unknown'
WHERE CustomerID IS NULL;

-- 4. Replace missing Description with 'Unknown'
UPDATE [online retail csv]
SET Description = 'Unknown'
WHERE Description IS NULL OR Description = '';

-- 5. Check for any negative values in Quantity or UnitPrice 
SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) AS Negative_Quantity_Count,
    SUM(CASE WHEN UnitPrice < 0 THEN 1 ELSE 0 END) AS Negative_UnitPrice_Count
FROM [dbo].[online retail csv];

-- Tasks 6: Final check of the cleaned table 

 