# E-Commerce Sales Performance Dashboard

An end-to-end Power BI dashboard analyzing e-commerce sales performance, product revenue,
customer purchasing trends, and top-performing categories.

## Tools Used
Power BI Desktop, Power BI Service, SQL, Microsoft Excel, Power Query, DAX

## What It Does
- Tracks key KPIs: Total Revenue, Total Orders, Average Order Value, Customer Acquisition Rate
- Visualizes month-over-month revenue trends and category-wise performance
- Interactive drillthrough from category summary into individual product-level detail
- Conditional formatting highlights top and underperforming products
- Slicers for Year, Category, and Region enable self-service filtering
- Geographic map view of revenue by state
- Bookmark-based navigation between Revenue View and Orders View

## Data Model
Star schema with a central Fact_Sales table connected to Dim_Product, Dim_Customer, and Dim_Date.

## Files in this repo
- `Ecommerce_Sales_Dashboard.pbix` — the Power BI file
- `Ecommerce_SQL_Queries.sql` — SQL used to extract and join sales, product, and customer data
- Screenshots of the dashboard pages

## Screenshots
<img width="1920" height="1080" alt="Screenshot (83)" src="https://github.com/user-attachments/assets/25f2f3c9-0d0f-47c7-abd1-d072dea9b3a4" />
<img width="1920" height="1080" alt="Screenshot (85)" src="https://github.com/user-attachments/assets/5c6de906-1910-4d09-9cd7-0a001c3e9041" />

