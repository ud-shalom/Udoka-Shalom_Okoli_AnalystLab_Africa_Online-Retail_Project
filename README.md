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

## 📊 **Statistical Analysis & KPIs**
To evaluate the health and performance of the Online Retail business, I performed statistical analysis in Excel using descriptive statistics and business KPI calculations.

### **Key Statistical Metrics**

| Metric | Result | Business Significance |
| :--- | :--- | :--- |
| **Total Revenue** | **$9.75M** | Measures total sales generated during the analysis period. |
| **Total Orders** | **527K** | Indicates transaction volume and business activity level. |
| **Average Order Value (AOV)** | **$18.48** | Average customer spend per transaction. |
| **Median Revenue** | Calculated | Typical transaction value, reducing outlier influence. |
| **Mode (Quantity)** | Calculated | Identifies the most frequently purchased quantity. |
| **Standard Deviation** | Calculated | Measures volatility and variability in customer spending. |

### **Excel Formulas Applied**
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

### Part 2: Advanced Business Insights, Highlights, and Connect
## 🔍 **Advanced Business Insights**

### **Customer Analysis**
- A large portion of transactions are associated with "**Unknown**" customers, limiting customer segmentation opportunities.
- Identifying these customers would improve retention strategies and personalized marketing campaigns.
- Customer acquisition appears strong, but customer identification remains a key challenge.

### **Revenue Analysis**
- Revenue generation remained relatively stable throughout the observed period.
- Seasonal peaks indicate periods of increased consumer demand.
- Consistent monthly revenue demonstrates business resilience and strong market presence.

### **Product Performance**
- Revenue is driven by a mix of retail products and service-related items.
- Top-performing products contribute disproportionately to total revenue.
- Product concentration analysis suggests opportunities for inventory optimization.

### **Geographic Analysis**
- The **United Kingdom** accounts for the majority of total sales.
- Secondary markets such as **Germany** and the **Netherlands** show growth potential.
- Geographic diversification could reduce dependency on a single market.

### **Strategic Recommendations**
1. **CRM Improvement**: Prioritize systems to capture customer IDs and reduce "Unknown" records.
2. **Loyalty Programs**: Launch targeted initiatives to increase **Average Order Value (AOV)**.
3. **Market Expansion**: Increase marketing efforts in high-growth international markets.
4. **Inventory Planning**: Optimize stock levels based on top-performing product velocity.
5. **Segmentation**: Use customer behavior data to improve targeted promotional offers.

## 🏆 **Project Highlights**
- ✔ **Data Cleaning using SQL**
- ✔ **Data Validation and Quality Checks**
- ✔ **Statistical Analysis in Excel**
- ✔ **Pivot Table Development**
- ✔ **KPI Calculation and Business Metrics**
- ✔ **Interactive Dashboard Design**
- ✔ **Customer Behavior Analysis**
- ✔ **Product Performance Analysis**
- ✔ **Revenue Trend Analysis**
- ✔ **Geographic Sales Analysis**
- ✔ **Business Recommendations & Insights**


## 📈 Dashboard Preview
### Netflix Content Dashboard
![Netflix Content Dashboard](netflix%20dashboard%202.png)

# Netflix Content Analysis Project
**Project by:** U.S. Okoli  
**Part of the AnalystLab Africa Data Analytics Internship**

## 📋 Overview
This project provides an end-to-end analysis of the Netflix content catalog. The objective was to transform raw data into an interactive dashboard, providing clarity on content distribution, platform strategy, and production trends.

## 🔗 Data Connection: SQL Server to Power BI
The data pipeline was established by importing the cleaned SQL dataset directly into Power BI Desktop.

### Connection Method
- SQL Server Database connector.

### Workflow
- The cleaned SQL table was loaded into Power BI to create a high-performance data model for visualization.
## 🧹 Data Cleaning Process

### Phase 1: SQL Server (Structural Cleaning)
The following operations were performed in SQL to ensure data integrity:
-- 1. Handling Missing Values
UPDATE dbo.netflix_titles 
SET director = 'Unknown' WHERE director IS NULL;

UPDATE dbo.netflix_titles 
SET cast = 'Unknown' WHERE cast IS NULL;

-- 2. Duplicate Check
WITH DuplicateCheck AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY show_id ORDER BY show_id) as row_num
    FROM dbo.netflix_titles
)
SELECT * FROM DuplicateCheck WHERE row_num > 1;

-- 3. Optimization
EXEC sp_rename 'dbo.netflix_titles.type', 'content_type', 'COLUMN';

### Phase 2: Power BI (Final Cross-Check & Validation)
After importing the cleaned SQL dataset into Power BI, I utilized Power Query to cross-check the data and perform final refinements:

- **Data Type Enforcement**: Verified that `release_year` was set to integer and `date_added` was set to the correct Date format to ensure time-series accuracy.
- **Consistency Check**: Performed a final validation to ensure all nulls in categorical columns were replaced with "Unknown," ensuring full dataset uniformity.

## 🧮 DAX Measures
The following measures were created in Power BI to drive the dashboard KPIs:

| Measure | Formula |
| :--- | :--- |
| **Total Titles** | Total Titles = COUNTROWS('netflix_titles') |
| **Movie Count** | Total Movies = CALCULATE(COUNTROWS('netflix_titles'), 'netflix_titles'[content_type] = "Movie") |
| **TV Show Count** | Total TV Shows = CALCULATE(COUNTROWS('netflix_titles'), 'netflix_titles'[content_type] = "TV Show") |
| **Unique Countries** | Total Countries = DISTINCTCOUNT('netflix_titles'[country]) |

## 💡 Dashboard Insights: Netflix Content Overview

The **Netflix Content Overview Dashboard** provides a comprehensive, data-driven narrative of the platform's library. Below is a detailed breakdown of the key findings:

- **Content Strategy & Distribution**: 
    - The library is heavily dominated by **Movies**, which account for approximately **67%** of total content, compared to **33%** for **TV Shows**.
    - This distribution reflects a strategic priority on high-turnover, short-form entertainment designed to drive consistent subscriber engagement.

- **Temporal Production Trends**: 
    - The data highlights a significant "Gold Rush" period for production, which **peaked in 2018** with **1,147 titles** released in that year alone.
    - Compared to **2015** (the lowest output in the observed dataset), production levels in 2018 grew by a massive **104.82%**, demonstrating Netflix’s aggressive scaling of its content acquisition strategy.

- **Market Leadership & Global Footprint**: 
    - The **United States** stands as the clear market leader in content production, significantly outpacing all other nations in volume.
    - With **749 unique countries** represented in the dataset, the dashboard confirms Netflix’s successful global distribution model, even while production remains concentrated in primary markets.

- **Audience Preferences (Genres & Ratings)**: 
    - **Dramas** and **Documentaries** emerge as the most popular genres, suggesting that the core audience shows a strong preference for high-quality storytelling and factual, educational programming.
    - The concentration of content in **TV-MA** and **TV-14** ratings suggests that the platform primarily targets a mature and young-adult demographic.

- **Strategic Recommendations**: 
    - While the U.S. dominance is clear, the volume of content varies wildly—ranging from 110 to 2,818 titles across the top 10 countries.
    - There is a clear **strategic opportunity** to further diversify production in secondary markets to better align with local cultural preferences and deepen market penetration outside of North America.
---

### 🚀 **Connect With Me**
**Project by: U.S. OKOLI**
*Part of the AnalystLab Africa Data Analytics Internship*

#DataAnalytics #DataAnalysis #ExcelDashboard #Excel #SQL #BusinessIntelligence #DataVisualization #Analytics #RetailAnalytics #DashboardDesign #GitHubPortfolio #DataCleaning #PivotTables #KPIAnalysis #Statistics #BusinessAnalysis #AnalystLabAfrica
