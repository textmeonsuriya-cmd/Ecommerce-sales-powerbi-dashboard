/* =========================================================
   PROJECT 1: E-COMMERCE SALES PERFORMANCE DASHBOARD
   SQL used to extract & join tables before loading into Power BI
   Tested against the schema in Ecommerce_Sales_Data.xlsx
   (import each sheet as a MySQL table with matching names first)
   ========================================================= */

-- 1. Table creation (matches the Excel sheet structure)
CREATE TABLE Dim_Product (
    ProductID     VARCHAR(10) PRIMARY KEY,
    ProductName   VARCHAR(100),
    Category      VARCHAR(50),
    SubCategory   VARCHAR(50),
    UnitCost      DECIMAL(10,2),
    UnitPrice     DECIMAL(10,2)
);

CREATE TABLE Dim_Customer (
    CustomerID    VARCHAR(10) PRIMARY KEY,
    CustomerName  VARCHAR(100),
    Gender        VARCHAR(10),
    AgeGroup      VARCHAR(10),
    City          VARCHAR(50),
    State         VARCHAR(50),
    Region        VARCHAR(20),
    SignupDate    DATE
);

CREATE TABLE Fact_Sales (
    OrderID         VARCHAR(15) PRIMARY KEY,
    OrderDate       DATE,
    CustomerID      VARCHAR(10),
    ProductID       VARCHAR(10),
    Quantity        INT,
    UnitPrice       DECIMAL(10,2),
    DiscountPct     DECIMAL(4,2),
    DiscountAmount  DECIMAL(10,2),
    TotalAmount     DECIMAL(10,2),
    Region          VARCHAR(20),
    PaymentMethod   VARCHAR(30),
    OrderStatus     VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Dim_Customer(CustomerID),
    FOREIGN KEY (ProductID)  REFERENCES Dim_Product(ProductID)
);

-- (Use LOAD DATA INFILE / MySQL Workbench "Table Data Import Wizard"
--  to load each sheet exported as CSV into these tables.)


-- 2. Consolidated dataset: sales joined with product + customer
--    (this is the extract you load into Power BI via Power Query)
SELECT
    f.OrderID, f.OrderDate, f.Quantity, f.UnitPrice, f.DiscountAmount, f.TotalAmount,
    f.PaymentMethod, f.OrderStatus,
    p.ProductName, p.Category, p.SubCategory, p.UnitCost,
    c.CustomerName, c.Gender, c.AgeGroup, c.City, c.State, c.Region
FROM Fact_Sales f
JOIN Dim_Product p  ON f.ProductID  = p.ProductID
JOIN Dim_Customer c ON f.CustomerID = c.CustomerID;


-- 3. Category-wise revenue and order volume (feeds bar chart visual)
SELECT
    p.Category,
    SUM(f.TotalAmount)              AS TotalRevenue,
    COUNT(DISTINCT f.OrderID)       AS TotalOrders,
    ROUND(AVG(f.TotalAmount), 2)    AS AvgOrderValue
FROM Fact_Sales f
JOIN Dim_Product p ON f.ProductID = p.ProductID
WHERE f.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY TotalRevenue DESC;


-- 4. Top 10 customers by revenue (subquery example)
SELECT CustomerName, TotalRevenue FROM (
    SELECT c.CustomerName, SUM(f.TotalAmount) AS TotalRevenue
    FROM Fact_Sales f
    JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
    WHERE f.OrderStatus = 'Delivered'
    GROUP BY c.CustomerName
) AS CustomerRevenue
ORDER BY TotalRevenue DESC
LIMIT 10;


-- 5. Month-over-month revenue trend (feeds trend line visual)
SELECT
    DATE_FORMAT(f.OrderDate, '%Y-%m') AS OrderMonth,
    SUM(f.TotalAmount) AS MonthlyRevenue
FROM Fact_Sales f
WHERE f.OrderStatus = 'Delivered'
GROUP BY DATE_FORMAT(f.OrderDate, '%Y-%m')
ORDER BY OrderMonth;


-- 6. Region-wise performance (feeds geographic map visual)
SELECT
    c.Region,
    SUM(f.TotalAmount) AS Revenue,
    COUNT(DISTINCT f.OrderID) AS Orders,
    COUNT(DISTINCT f.CustomerID) AS UniqueCustomers
FROM Fact_Sales f
JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
WHERE f.OrderStatus = 'Delivered'
GROUP BY c.Region
ORDER BY Revenue DESC;
