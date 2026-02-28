create database Adventureworks_;

use Adventureworks_;
-- List all customers who have placed an order. Include their FirstName, LastName, and the SalesOrderNumber
SELECT * FROM Person_Person;
SELECT * FROM Sales_Customer;
SELECT * FROM Sales_SalesOrderHeader;

SELECT
 PP.FirstName, PP.LastName,
 SSOH.SalesOrderNumber as `Order Number` FROM
Sales_Customer AS SC
JOIN Person_Person as PP
ON SC.PersonID = PP.BusinessEntityID
JOIN Sales_SalesOrderHeader AS SSOH
ON SC.CustomerID = SSOH.CustomerID
;

-- The number of orders placed by the customers 
SELECT
 PP.FirstName, PP.LastName,
 count(SalesOrderNumber) as `Total Orders` 
 FROM Sales_Customer AS SC
JOIN Person_Person as PP
ON SC.PersonID = PP.BusinessEntityID
JOIN Sales_SalesOrderHeader AS SSOH
ON SC.CustomerID = SSOH.CustomerID
GROUP BY PP.FirstName, PP.LastName
ORDER BY `Total Orders` DESC;


-- Display all products (Name) and their current total quantity in stock across all locations. Including products that currently have zero stock. 
SELECT * FROM Production_ProductInventory;
SELECT * FROM Production_Product;


SELECT 
PP.Name, 
Sum(IFNULL(PPI.Quantity,0)) AS TotalQuantity
FROM Production_Product AS PP 
LEFT JOIN Production_ProductInventory AS PPI
ON PPI.ProductID = PP.ProductID
GROUP BY PP.Name
ORDER BY TotalQuantity;

-- List every employee’s name along with the name of their manager.

SELECT * FROM HumanResources_Employee;
SELECT * FROM Person_Person;

SELECT 
    PP1.FirstName AS Employee, 
    PP1.LastName AS EmpLastName,
    PP2.FirstName AS Manager, 
    PP2.LastName AS MgrLastName
FROM HumanResources_Employee AS HRE1
-- Join to Person to get the Employee's name
JOIN Person_Person AS PP1 
    ON HRE1.BusinessEntityID = PP1.BusinessEntityID
-- Self-join to find the Manager
JOIN HumanResources_Employee AS HRE2 
    ON HRE1.OrganizationLevel = HRE2.OrganizationLevel + 1
    AND HRE1.OrganizationNode LIKE CONCAT(HRE2.OrganizationNode, '%')
-- Join to Person again to get the Manager's name
JOIN Person_Person AS PP2 
    ON HRE2.BusinessEntityID = PP2.BusinessEntityID
ORDER BY HRE1.OrganizationLevel;

-- Show the names of vendors and the shipping methods they use for their purchase orders
SELECT * FROM Purchasing_Vendor;
SELECT * FROM Purchasing_PurchaseOrderHeader;
SELECT * FROM Purchasing_ShipMethod;

SELECT DISTINCT 
    PV.Name AS VendorName, 
    PSM.Name AS ShippingMethod
FROM Purchasing_Vendor AS PV
JOIN Purchasing_PurchaseOrderHeader AS POH ON PV.BusinessEntityID = POH.VendorID
JOIN Purchasing_ShipMethod AS PSM ON POH.ShipMethodID = PSM.ShipMethodID;

-- Find the total sales amount (TotalDue) for each Territory Name.
SELECT * FROM Sales_SalesTerritory;
SELECT * FROM Sales_SalesOrderHeader;

SELECT 
SST.Name AS Territory,
Sum(SOH.TotalDue) AS TotalSales
FROM Sales_SalesOrderHeader AS SOH
JOIN Sales_SalesTerritory AS SST
ON SOH.TerritoryID = SST.TerritoryID
GROUP BY Territory;


-- Find all products that have been sold at a unit price higher than the average unit price of all items ever sold
SELECT * FROM Sales_SalesOrderDetail;
SELECT * FROM Production_Product;

SELECT 
PP.Name AS Product,
SSOD.UnitPrice
FROM Sales_SalesOrderDetail AS SSOD
JOIN Production_Product AS PP
ON SSOD.ProductID = PP.ProductID
WHERE SSOD.UnitPrice > (SELECT 
Avg(UnitPrice)
FROM
Sales_SalesOrderDetail);


-- Identify the names of customers who have placed more than 10 orders
SELECT
 PP.FirstName, PP.LastName,
 count(SalesOrderNumber) as `Total Orders` 
 FROM Sales_Customer AS SC
JOIN Person_Person as PP
ON SC.PersonID = PP.BusinessEntityID
JOIN Sales_SalesOrderHeader AS SSOH
ON SC.CustomerID = SSOH.CustomerID
GROUP BY PP.FirstName, PP.LastName
HAVING `Total Orders` > 10
ORDER BY `Total Orders` DESC;

-- Using Sub-queries to do the same 
SELECT
PP.FirstName, PP.LastName,
count(SalesOrderNumber) as `Total Orders` 
FROM Person_Person as PP
JOIN Sales_Customer AS SC
ON PP.BusinessEntityID = SC.PersonID
JOIN Sales_SalesOrderHeader AS SSOH
ON SC.CustomerID = SSOH.CustomerID 
WHERE SC.CustomerID IN (
					SELECT CustomerID
					FROM
					Sales_SalesOrderHeader
					GROUP BY CustomerID
					HAVING count(SalesOrderNumber) > 10)
GROUP BY PP.FirstName, PP.LastName
;
 
-- List the names of products that have never been ordered
SELECT PP.Name
FROM Production_Product AS PP
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales_SalesOrderDetail AS SSOD 
    WHERE SSOD.ProductID = PP.ProductID
);

-- Show the Name and ListPrice of products that were ordered on the most recent date recorded in the database
SELECT * FROM Sales_SalesOrderDetail;
SELECT * FROM Sales_SalesOrderHeader;

SELECT DISTINCT PP.Name, SSOH.OrderDate
FROM Production_Product AS PP
JOIN Sales_SalesOrderDetail AS SSOD 
ON PP.ProductID = SSOD.ProductID
JOIN Sales_SalesOrderHeader AS SSOH 
ON SSOD.SalesOrderID = SSOH.SalesOrderID
WHERE SSOH.OrderDate = (SELECT MAX(OrderDate) FROM Sales_SalesOrderHeader);

-- Find the names of employees who earn more than the average rate for their specific department
SELECT PP.FirstName, PP.LastName,
E1.BusinessEntityID, E1.Rate
FROM HumanResources_EmployeePayHistory AS E1
JOIN Person_Person AS PP
ON E1.BusinessEntityID = PP.BusinessEntityID
WHERE E1.Rate > (
    SELECT AVG(E2.Rate)
    FROM HumanResources_EmployeePayHistory AS E2
    JOIN HumanResources_EmployeeDepartmentHistory AS EDH2 
      ON E2.BusinessEntityID = EDH2.BusinessEntityID
    WHERE EDH2.DepartmentID = (
        SELECT DepartmentID 
        FROM HumanResources_EmployeeDepartmentHistory AS EDH1 
        WHERE EDH1.BusinessEntityID = E1.BusinessEntityID
        LIMIT 1
    )
);
