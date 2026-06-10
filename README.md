## 📈 Dashboard Preview
![Online Retail Dashboard](online%20retail%20dashboard%201.png)

# Online Retail E-commerce Sales Analysis
**Project by: U.S. OKOLI**

## 📦 Project Overview
This project provides an end-to-end analysis of an online retail e-commerce dataset. The objective was to transform raw sales into actionable insights, covering revenue performance, customer purchasing behavior, and statistical trends.

## ⚙️ Data Pipeline & Connection
The workflow began with database management and transitioned into advanced spreadsheet analysis and visualization:
- **SQL Server**: Used for initial data cleaning, handling nulls, and filtering duplicate records.
- **Excel Integration**: The cleaned dataset was exported from SQL and imported into Excel.
- **Power Query Validation**: Power Query was utilized to perform a final cross-check on data types and ensure consistent labeling of missing values as "Unknown."

## 🧹 Data Cleaning Process (SQL)
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
DELETE FROM dbo.online_retail WHERE Quantity < 0

📊 Statistical Analysis & KPIs
To evaluate the health and performance of the Online Retail business, I performed statistical analysis in Excel using descriptive statistics and business KPI calculations.

Key Statistical Metrics
Metric	Result	Business Significance
Total Revenue	$9.75M	Measures total sales generated during the analysis period.
Total Orders	527K	Indicates transaction volume and business activity level.
Average Order Value (AOV)	$18.48	Average customer spend per transaction.
Median Revenue	Calculated	Typical transaction value, reducing outlier influence.
Mode (Quantity)	Calculated	Identifies the most frequently purchased quantity.
Standard Deviation	Calculated	Measures volatility and variability in customer spending.
Excel Formulas Applied
Excel
=SUM(Revenue)
=COUNT(OrderID)
=AVERAGE(Revenue)
=MEDIAN(Revenue)
=MODE.SNGL(Quantity)
=MAX(Revenue)
=MIN(Revenue)
=STDEV.P(Revenue)
=VAR.P(Revenue)
=SUM(Revenue)/COUNT(OrderID)
🔍 Advanced Business Insights
Customer Analysis
A large portion of transactions are associated with "Unknown" customers, limiting customer segmentation opportunities.

Identifying these customers would improve retention strategies and personalized marketing campaigns.

Customer acquisition appears strong, but customer identification remains a key challenge.

Revenue Analysis
Revenue generation remained relatively stable throughout the observed period.

Seasonal peaks indicate periods of increased consumer demand.

Consistent monthly revenue demonstrates business resilience and strong market presence.

Product Performance
Revenue is driven by a mix of retail products and service-related items.

Top-performing products contribute disproportionately to total revenue.

Product concentration analysis suggests opportunities for inventory optimization.

Geographic Analysis
The United Kingdom accounts for the majority of total sales.

Secondary markets such as Germany and the Netherlands show growth potential.

Geographic diversification could reduce dependency on a single market.

Strategic Recommendations
CRM Improvement: Prioritize systems to capture customer IDs and reduce "Unknown" records.

Loyalty Programs: Launch targeted initiatives to increase Average Order Value (AOV).

Market Expansion: Increase marketing efforts in high-growth international markets.

Inventory Planning: Optimize stock levels based on top-performing product velocity.

Segmentation: Use customer behavior data to improve targeted promotional offers.

🏆 Project Highlights
✔ Data Cleaning using SQL

✔ Data Validation and Quality Checks

✔ Statistical Analysis in Excel

✔ Pivot Table Development

✔ KPI Calculation and Business Metrics

✔ Interactive Dashboard Design

✔ Customer Behavior Analysis

✔ Product Performance Analysis

✔ Revenue Trend Analysis

✔ Geographic Sales Analysis

✔ Business Recommendations & Insights

🚀 Connect With Me
Project by: U.S. OKOLI
Part of the AnalystLab Africa Data Analytics Internship

#DataAnalytics #DataAnalysis #ExcelDashboard #Excel #SQL #BusinessIntelligence #DataVisualization #Analytics #RetailAnalytics #DashboardDesign #GitHubPortfolio #DataCleaning #PivotTables #KPIAnalysis #Statistics #BusinessAnalysis #AnalystLabAfrica
