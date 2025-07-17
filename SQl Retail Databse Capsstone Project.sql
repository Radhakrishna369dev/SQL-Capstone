

------- scenario ------
--You are hired as a junior Data analyst for a retail company
--that sells electronics & accessories.
--Your manager wants you to analyze sales and customer data using SQL ssms.

create database project

use project;

 -- create customer table

 drop table Customer;

 Create Table Customer (
	CustomerID INT Primary Key,
	Firstname Varchar(50),
	LastName Varchar(50),
	City Varchar(50),
	JoinDate Date
	);

Update Customer 

-- Insert data into Table

Insert into Customer values
(1,'John','Doe','Mumbai','2024-01-05'),
(2,'Alice','White','Delhi','2024-02-15'),
(3,'Bob','Smith','Bangalore','2024-03-20'),
(4,'Sara','Brwon','Mumbai','2024-01-25'),
(5,'Mike','Black','Chennai','2024-02-10');



--Create Order Table

Create Table Orders (
	OrderID INT Primary Key,
	CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
	OrderDate Date,
	Product Varchar(50),
	Quantity INT,
	Price INT
	);


-- Insert data into orders

Insert INTO Orders values 
(101,1,'2024-04-10','Laptop',1,55000),
(102,2,'2024-04-12','Mouse',2,800),
(103,1,'2024-04-15','Keyboard',1,1500),
(104,3,'2024-04-20','Laptop',1,50000),
(105,4,'2024-04-22','Headphones',1,2000),
(106,2,'2024-04-25','Laptop',1,52000),
(107,5,'2024-04-28','Mouse',1,700),
(108,3,'2024-05-02','Keyboard',1,1600);

select * from Customer
select * from Orders


-- Part A : Basic Queries
--1. Get the list of all customers from Mumbai
--2. Show all orders for Laptops.
--3. Find the total number of orders placed.
--4. Find price between 50000 and 80000.


--1.
select * from Customer where City = 'Mumbai';
--Sara & John are from Mumbai.

--2.
select * from Orders where Product = 'Laptop';
--Total of 3 laptops are sold.

--3.
select count(*)AS TotalOrders from Orders;
--Total of 8 orders placed.

--4.
select * from Orders where Price Between 50000 and 80000;
--There are 3 customers whoe shopped between 50k to 80k.


select * from Customer
select * from Orders
--Part B: Joins
--4: Get the full name of customers and their products ordered.
--5: Find customers who have not placed any orders.

--4:
select c.Firstname,+' '+ c.LastName AS FullName, o.Product
from Customer c
Join Orders o ON c.CustomerID=o.CustomerID;

--5:
select c.CustomerID,o.orderid
from Customer c
Join Orders o ON c.CustomerID = o.CustomerID
Where o.OrderID is NULL


--Part C: Aggrefations
--6: Find the total revenue earned from all orders.
--7: Find total quantity of Mouses sold.

--6:
select sum(Price)AS TotalRevenue from Orders;

select sum(quantity*Price) AS TotalRevenue from Orders;

--7:
select sum(Quantity)AS TotalMouse from Orders
Where Product = 'Mouse';


--8: Show total sales amount per customer.
--9: Show number of orders per city.

--8
Select c.Firstname, sum(o.quantity * o.Price)As sales
from Customer c Join Orders o on c.CustomerID = o.CustomerID
group by c.Firstname;

--9
select c.city, count(o.orderid) as orders
from Customer c join Orders o ON c.CustomerID = o.CustomerID
group by c.City;


select * from Customer
select * from Orders

--Part E: Subquery & CASE
--10: Find customer who spent more than 50000 in total.
--11: Write a query to display each order with label :
--
-- 'High Value' if price > 50000
-- 'Low Value' otherwise

--10:
select C.* from customer C
where c.CustomerID IN
(select CustomerID from Orders
group by CustomerID
Having sum(price) > 50000 );


--11:
select OrderID, Price,
	CASE
		When Price > 50000 Then 'High Value'
		Else 'Low Value'
	End As ValueLabel
From Orders;


--Part F:Window Functions
--12:Find the running total of revenue by order date.


SELECT OrderID, Orderdate, Price,
	sum(price) OVER (ORDER BY orderdate )AS RunningRevenue
from Orders;


--13: Assign a Row_Number to each order by CustomerID ordered by Orderdate(oldest first).

Select 
	OrderID,
	CustomerID,
	OrderDate,
	Price,
	ROW_NUMBER() Over (PARTITION BY CustomerID ORDER BY OrderDate) AS RowNum
From Orders;

--13A: Assign Row_Number to each customerID order by price

select 
	CustomerID,
	OrderID,
	Price,
	ROW_NUMBER() Over (PARTITION BY CustomerID ORDER BY Price) AS OrderPrice
From Orders;


select * from Customer
select * from Orders
--14: Use RANK to rank orders by Price (Highest to Lowest)

Select 
	OrderID,
	CustomerID,
	Price,
	Rank () Over (ORDER BY Price DESC) AS PriceRank
From Orders;

--14 A: Use RANK to rank orders by Quantity (Highest to Lowest)

Select 
	OrderID,
	CustomerID,
	Quantity,
	Price,
	Rank () Over (ORDER BY Quantity DESC) AS QuantityRank
From Orders;


--15: Use Dense_Rank to
--Rank orders by Price (Highest-Lowest) - Explain diff with Rank.


UPDATE Orders
Set Price = 52000
Where Price = 50000;

Select 
	OrderID,
	CustomerID,
	Price,
DENSE_RANK() OVER (ORDER BY Price DESC) AS price_rank
FROM Orders;


--16: Find customers who have placed more than 1 order using HAVING.

SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1;