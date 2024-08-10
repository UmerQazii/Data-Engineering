
-- NOTE:BEFORE RUN THE COMMANDS BELOW U NEED TO MAKE CREATE COMMAND 1st FOR database, Schemas and tables...
/*
Question No 01
Employees Earning More Than Their Managers

Table: Employee
Column Name	Type
id	int
name	varchar
salary	int
managerId	int

id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
Write a solution to find the employees who earn more than their managers.
*/

SELECT e1.name AS Employee
FROM Employee e1
JOIN Employee e2
ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;

------------------------------

/*
Question No 02
Duplicate Emails
Table: Person
Column Name	Type
id	int
email	varchar

id is the primary key (column with unique values) for this table. Each row of this table contains an email. The emails will not contain uppercase letters.
Write a solution to report all the duplicate emails. Note that it's guaranteed that the email field is not NULL.
Return the result table in any order.
*/

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;

/*
Question No 03
Delete Duplicate Emails
Table: Person
Column Name	Type
id	int
email	varchar

id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
*/
WITH CTE AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM Person
)
DELETE FROM Person
WHERE id IN (
    SELECT id
    FROM CTE
    WHERE rn > 1
);

/*
Question No 04
Replace Employee ID With The Unique Identifier
Table: Employees
Column Name	Type
id	int
name	varchar
Each row of this table contains the id and the name of an employee in a company.

Table: EmployeeUNI
Column Name	Type
id	int
uniqueid	int

(id, unique_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the company.
Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
Return the result table in any order.

*/

WITH CTE AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM Person
)
DELETE FROM Person
WHERE id IN (
    SELECT id
    FROM CTE
    WHERE rn > 1
);

/*
Question No 05
Minimum Salary in Each Department
Write a query to find the employee with the minimum salary in each department from a table Employees with columns EmployeeID, Name, DepartmentID, and Salary.
*/

SELECT e.EmployeeID, e.Name, e.DepartmentID, e.Salary
FROM Employees e
JOIN (
    SELECT DepartmentID, MIN(Salary) AS MinSalary
    FROM Employees
    GROUP BY DepartmentID
) AS deptMin
ON e.DepartmentID = deptMin.DepartmentID AND e.Salary = deptMin.MinSalary;

/*
Question No 06
Customer with the Highest Total Order
Given a table Orders with columns OrderID, CustomerID, OrderDate, and a table OrderItems with columns OrderID, ItemID, Quantity, write a query to find the customer with the highest total order quantity.
*/
SELECT o.CustomerID
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.CustomerID
ORDER BY SUM(oi.Quantity) DESC
LIMIT 1;

/*
Question No 07
Customers who placed their first order within the last 30 days
Given a table Customers with columns CustomerID, Name, JoinDate, and a table Orders with columns OrderID, CustomerID, OrderDate, write a query to find customers who placed their first order within the last 30 days.
*/

SELECT c.CustomerID, c.Name
FROM Customers c
JOIN (
    SELECT CustomerID, MIN(OrderDate) AS FirstOrderDate
    FROM Orders
    GROUP BY CustomerID
) AS firstOrders ON c.CustomerID = firstOrders.CustomerID
WHERE firstOrders.FirstOrderDate >= CURDATE() - INTERVAL 30 DAY;

/*
Question No 08
Second Highest Salary
Table: Employee
Column Name	Type
id	int
salary	int

id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
Write a solution to find the second highest salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).
*/
-- NOTE run this command on python editor like:jupyter notebook
import pandas as pd

# Assuming df is your DataFrame with the Employee data
df = pd.DataFrame({
    'id': [1, 2, 3, 4],
    'salary': [100, 200, 300, 300]
})

# Finding the unique salaries, sorting them, and picking the second highest
unique_salaries = df['salary'].drop_duplicates().sort_values(ascending=False)
second_highest = unique_salaries.iloc[1] if len(unique_salaries) > 1 else None

print(second_highest)

/*
Question No 09
Department Highest Salary
Table: Employee
Column Name	Type
id	int
salary	Int
name	Varchar
departmentId	int

id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference columns) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

Table: Department
Column Name	Type
id	int
name	varchar

id is the primary key (column with unique values) for this table. It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.

*/

SELECT e.name AS EmployeeName, d.name AS DepartmentName, e.salary AS Salary
FROM Employee e
JOIN Department d ON e.departmentId = d.id
WHERE e.salary = (
    SELECT MAX(salary)
    FROM Employee
    WHERE departmentId = e.departmentId
);

/*
Question No 10
Customers Who Bought All Products
Table: Customer
Column Name	Type
Customer_id	int
Product_key	Int

This table may contain duplicates rows. 
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.

Table: Product
Column Name	Type
Product_key	Int

product_key is the primary key (column with unique values) for this table.

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
Return the result table in any order.
*/
SELECT c.Customer_id
FROM Customer c
GROUP BY c.Customer_id
HAVING COUNT(DISTINCT c.Product_key) = (SELECT COUNT(*) FROM Product);
