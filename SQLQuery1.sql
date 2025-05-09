-- Write a SQL query to locate those salespeople who do not live in the same city where their customers live and have received a commission of more than 12%
   from the company. Return Customer Name, customer city, Salesman, salesman city, commission.

SELECT DISTINCT
    custPerson.FirstName + ' ' + custPerson.LastName AS CustomerName,
    custAddr.City AS CustomerCity,
    salesPerson.FirstName + ' ' + salesPerson.LastName AS SalesmanName,
    salesAddr.City AS SalesmanCity,
    salesRep.CommissionPct  AS Commission
FROM Sales.SalesOrderHeader salesOrder
JOIN Sales.Customer cust ON salesOrder.CustomerID = cust.CustomerID
JOIN Sales.SalesPerson salesRep ON salesOrder.SalesPersonID = salesRep.BusinessEntityID
JOIN Person.Person salesPerson ON salesRep.BusinessEntityID = salesPerson.BusinessEntityID
JOIN Person.Person custPerson ON cust.PersonID = custPerson.BusinessEntityID
JOIN Person.BusinessEntityAddress custBEA ON cust.StoreID = custBEA.BusinessEntityID
JOIN Person.Address custAddr ON custBEA.AddressID = custAddr.AddressID
JOIN Person.BusinessEntityAddress salesBEA ON salesRep.BusinessEntityID = salesBEA.BusinessEntityID
JOIN Person.Address salesAddr ON salesBEA.AddressID = salesAddr.AddressID

WHERE custAddr.City <> salesAddr.City
  AND salesRep.CommissionPct > 0.0012;

--ASSIGNMENT-2

SELECT 
    sp.BusinessEntityID AS SalespersonID,
    spPerson.FirstName + ' ' + spPerson.LastName AS Salesperson,
    c.CustomerID,
    custPerson.FirstName + ' ' + custPerson.LastName AS CustomerName,
    addr.City,
    c.StoreID,
    soh.SalesOrderNumber,
    soh.OrderDate,
    soh.TotalDue
FROM 
    Sales.SalesPerson sp
LEFT JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
LEFT JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Person.Person custPerson ON c.PersonID = custPerson.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress custBEA ON c.PersonID = custBEA.BusinessEntityID
LEFT JOIN Person.Address addr ON custBEA.AddressID = addr.AddressID
LEFT JOIN Person.Person spPerson ON sp.BusinessEntityID = spPerson.BusinessEntityID
ORDER BY sp.BusinessEntityID;

--ASSIGNMENT-3
SELECT 
    e.JobTitle,
    p.FirstName + ' ' + ISNULL(p.MiddleName + ' ', '') + p.LastName AS EmployeeName,
    eph.Rate AS CurrentSalary,
    (SELECT MAX(eph2.Rate) FROM HumanResources.EmployeePayHistory eph2) - eph.Rate AS SalaryDifference
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentID = 16
    AND edh.EndDate IS NULL  
    AND eph.RateChangeDate = (
        SELECT MAX(eph3.RateChangeDate) 
        FROM HumanResources.EmployeePayHistory eph3 
        WHERE eph3.BusinessEntityID = e.BusinessEntityID
    )
ORDER BY 
    SalaryDifference DESC;


--ASSIGNMENT--4
SELECT 
    st.Name AS TerritoryName,
    sp.SalesYTD,
    sp.BusinessEntityID,
    sp.SalesLastYear AS PrevRepSales
FROM 
    Sales.SalesPerson sp
    LEFT JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
ORDER BY 
    st.Name ASC;


--ASSIGNMENT-5
SELECT 
    soh.SalesOrderID AS ord_no,
    soh.TotalDue AS purch_amt,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS cust_name,
    a.City
FROM 
    Sales.SalesOrderHeader soh
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
    LEFT JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
    LEFT JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE 
    soh.TotalDue BETWEEN 500 AND 2000;


--ASSIGNMENT-6
SELECT 
    ISNULL(pp.FirstName + ' ' + pp.LastName, s.Name) AS CustomerName,
    a.City,
    soh.SalesOrderID AS OrderNumber,
    soh.OrderDate,
    soh.TotalDue AS OrderAmount
FROM 
    Sales.Customer c
    LEFT JOIN Person.Person pp ON c.PersonID = pp.BusinessEntityID
    LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
    LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    LEFT JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
    LEFT JOIN Person.Address a ON bea.AddressID = a.AddressID
ORDER BY 
    soh.OrderDate ASC;


--ASSIGNMENT-7
SELECT 
    e.JobTitle,
    p.LastName,
    p.MiddleName,
    p.FirstName
FROM 
    HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE 
    e.JobTitle LIKE 'Sales%';
