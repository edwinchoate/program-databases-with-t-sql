-- Challenge Two Start
USE WideWorldImporters;
GO

-- Create an audit table for customer accounts
CREATE TABLE Sales.CustomerAccountAudit (
    AuditID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    ReviewDate datetime2
);
GO

-- View existing data
SELECT * FROM Sales.Customers;
SELECT * FROM Sales.Orders;
GO

-- Write a stored procedure to:
-- 1) view information from Sales.Customers
-- 2) view information from Sales.Orders
-- 3) write a row to Sales.CustomerAccountAudit to log activity

CREATE OR ALTER PROC Sales.uspViewSalesInfoByCustomerID (@CustomerID INT)
AS
	SELECT * FROM Sales.Orders
	WHERE Orders.CustomerID = @CustomerID;

	SELECT * FROM Sales.Customers
	WHERE Customers.CustomerID = @CustomerID;

	INSERT INTO Sales.CustomerAccountAudit (CustomerID, ReviewDate)
	VALUES (@CustomerID, GETDATE());
;
GO

EXEC Sales.uspViewSalesInfoByCustomerID '7';
GO

SELECT * FROM Sales.CustomerAccountAudit;
GO