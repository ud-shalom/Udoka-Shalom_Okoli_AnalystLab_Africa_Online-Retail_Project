# Online Retail E-commerce Sales Analysis
**Project by: U.S. OKOLI**

## 📋 Project Overview
This project provides an end-to-end analysis of an online retail e-commerce dataset. The objective was to transform raw sales data into actionable insights, covering revenue performance, customer purchasing behavior, and statistical trends.

## 🔗 Data Pipeline & Connection
The workflow began with database management and transitioned into advanced spreadsheet analysis and visualization:
* **SQL Server:** Used for initial data cleaning, handling nulls, and filtering duplicate records.
* **Excel Integration:** The cleaned dataset was exported from SQL and imported into Excel.
* **Power Query Validation:** Power Query was utilized to perform a final cross-check on data types and ensure consistent labeling of missing values as "Unknown."

* ## 🧹 Data Cleaning Process (SQL)
The following SQL operations were executed to ensure data integrity:

```sql
-- 1. Handling Missing Customer IDs (Imputation)
UPDATE dbo.online_retail 
SET CustomerID = 'Unknown' WHERE CustomerID IS NULL;

-- 2. Removing Duplicates
WITH DuplicateCTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY InvoiceNo, StockCode ORDER BY InvoiceNo) as row_num
    FROM dbo.online_retail
)
DELETE FROM DuplicateCTE WHERE row_num > 1;

-- 3. Cleaning Negative Quantities (Returns/Cancellations)
DELETE FROM dbo.online_retail WHERE Quantity < 0;

### Block 3: Statistical Analysis and KPIs
```markdown
## 📊 Statistical Analysis & KPIs
To understand purchasing behavior, the following statistical measures were calculated in Excel:

| Metric | Purpose |
| :--- | :--- |
| **Mean (Average)** | To identify the average order value per transaction. |
| **Median** | To understand the typical transaction value, minimizing the impact of outliers. |
| **Mode** | To find the most frequently purchased product quantity. |
| **Max / Min** | To determine the highest and lowest individual sales transactions. |
| **Standard Deviation** | To measure the volatility or variance in customer spending. |

## 📈 Pivot Tables & Dashboard Creation
* **Pivot Table Setup:** Created structured tables to aggregate `Total Revenue` by `Country` and `Product Category`.
* **Dashboard Visualization:** Built an interactive dashboard featuring monthly revenue trends, top-performing products, and geographic analysis.

## 💡 Dashboard Insights
The **Online Retail Sales Dashboard** provides a detailed perspective on e-commerce performance:

* **Revenue Drivers:** The analysis identifies specific countries that generate the highest volume of transactions.
* **Product Velocity:** Using the Mode calculation, we identified the most frequently purchased quantity.
* **Spending Behavior:** The Standard Deviation analysis reveals significant variance in customer spending.
* **Operational Efficiency:** The removal of negative quantities provided a clearer view of actual net sales.
* **Strategic Recommendation:** We recommend implementing a loyalty program for the high-frequency customers identified.

## 📈 Dashboard Preview
![Retail Dashboard](retail_dashboard.png)

---
*Project documentation for AnalystLab Africa submission.*
