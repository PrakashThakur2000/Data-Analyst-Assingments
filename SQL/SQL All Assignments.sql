
-- 1)Show customer number, customer name, state and credit limit from customers table for below conditions.
-- Sort the results by highest to lowest values of creditLimit.
-- State should not contain null values
-- credit limit should be between 50000 and 100000

select customerNumber,customerName,state,creditLimit
from customers 
where state is not null and creditLimit between 50000 and 100000
order by creditLimit desc;

-- 2) Show the unique productline values containing the word cars at the end from products table.
select productLine 
from productlines 
where productLine  like "% cars";

-- 1)	Show the orderNumber, status and comments from orders table for shipped status only. 
-- If some comments are having null values then show them as “-“.

select orderNumber, status, coalesce(comments, "-") as comments
from orders
where status ="shipped";

-- 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
-- If job title is one among the below conditions, then job title abbreviation column should show below forms.
-- 	President then “P”
-- Sales Manager / Sale Manager then “SM”
-- Sales Rep then “SR”
-- Containing VP word then “VP”

use classicmodels;

alter table employees drop column job_title_abbrevation ;
select employeeNumber,firstName,jobTitle,
case 
when jobtitle ="president" then "p"
when jobtitle like "sale manager%" or jobtitle like "sales manager%" then "SM"
when jobtitle ="sales rep" then "SR"
when jobtitle like "%vp%" then "VP"
else null
end as job_title_abbrevation
from employees
order by jobTitle ;

-- DAY 5 
-- 1)	For every year, find the minimum amount value from payments table.
select year(paymentDate), min(amount)
from payments
group by year(paymentDate)
order by year(paymentDate);

-- 2)	For every year and every quarter, find the unique customers and total orders from orders table. 
-- Make sure to show the quarter as Q1,Q2 etc.

select year(orderDate) as order_year, concat("Q",quarter(orderDate)) as order_quarter,count(distinct customerNumber) as unique_customer ,count(orderNumber) as Total_order
from orders
group by order_year,order_quarter
order by order_year,order_quarter;

-- 3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) 
-- with filter on total amount as 500000 to 1000000.
--  Sort the output by total amount in descending mode. [ Refer. Payments Table]
select  monthname(paymentDate) as month, concat(format(sum(amount)/1000,0),"k")  as formated_amount
from payments
group by month
having sum(amount) between 500000 and 1000000
order by sum(amount) DESC;


-- Day 6:
-- 1)	Create a journey table with following fields and constraints.
-- ●	Bus_ID (No null values)
-- ●	Bus_Name (No null values)
-- ●	Source_Station (No null values)
-- ●	Destination (No null values)
-- ●	Email (must not contain any duplicates)


create  table journey(
Bus_id int primary key not	null,
Bus_name varchar(50) not null,
source_station varchar(50) not null,
destination varchar(50) not null,
Email varchar(50) unique
);

-- 2)	Create vendor table with following fields and constraints.
-- ●	Vendor_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Email (must not contain any duplicates)
-- ●	Country (If no data is available then it should be shown as “N/A”)

create table vendor(
Vendor_ID int primary key,
name varchar(50) not null,
Email varchar(50) unique,
country varchar(50) default "N/A"
);



-- 3)	Create movies table with following fields and constraints.
-- ●	Movie_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Release_Year (If no data is available then it should be shown as “-”)
-- ●	Cast (No null values)
-- ●	Gender (Either Male/Female)
-- ●	No_of_shows (Must be a positive number)

create table movies(
Movie_id  int primary key  not null,
name varchar(50) not null,
Release_year int  ,
Cast varchar(20) not null,
Gender enum("male","Female"),
no_of_shows int check(no_of_shows>=0) not null
);


-- 4)	Create the following tables. Use auto increment wherever applicable

-- a. Product
-- ✔	product_id - primary key
-- ✔	product_name - cannot be null and only unique values are allowed
-- ✔	description
-- ✔	supplier_id - foreign key of supplier table

-- b. Suppliers
-- ✔	supplier_id - primary key
-- ✔	location

-- c. Stock
-- ✔	id - primary key
-- ✔	product_id - foreign key of product table
-- ✔	balance_stock


create table product1(
Product_id int primary key auto_increment,
product_name varchar(50) unique not	null,
description text,
supplier_id int ,
foreign key (supplier_id) references  supplier(supplier_id) 
);	

create table supplier(
supplier_id int primary key,
supplier_name varchar(50) ,
location varchar(50) not null
);

create table stock(
id int primary key,
product_id int ,
balance_stock int ,
foreign key (product_id) references product1(product_id) 
);


-- Day 7
-- 1)	Show employee number, Sales Person (combination of first and last names of employees), 
-- unique customers for each employee number and sort the data by highest to lowest unique customers.
-- Tables: Employees, Customers

select e.employeeNumber ,concat(e.firstName," ",e.lastName)as sales_person, count(distinct c.customerNumber) as unique_customer
from employees e left join customers c  on e.employeeNumber = c.salesRepEmployeeNumber
group by e.employeeNumber, sales_person
order by unique_customer desc;


-- 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
-- Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products

select customerNumber, customerName, productCode,productName,quantityOrdered,quantityInStock, (quantityInStock-quantityOrdered) as Left_quantity
from products inner join orderdetails using(productCode)
inner join orders using (orderNumber)
inner join customers using (customerNumber)
order by customerNumber;

-- 3)	Create below tables and fields. (You can add the data as per your wish)
-- ●	Laptop: (Laptop_Name)
-- ●	Colours: (Colour_Name)
-- Perform cross join between the two tables and find number of rows.
create table Laptop(
Laptop_name varchar(50) ,
lappy_id int primary key,
Ref_id int unique
);
insert into Laptop
values
("Dell",1,111),
("HP",2,112),
("Lenovo",3,113);

create table colours(
Colour_name varchar(50) ,
Ref_id int unique
);

insert into colours
values
("Black",111),
("Blue",112),
("Red",113);

select Laptop_name,Colour_name
from colours cross join laptop using (Ref_id);


-- 4)	Create table project with below fields.
-- ●	EmployeeID
-- ●	FullName
-- ●	Gender
-- ●	ManagerID
-- Add below data into it.
-- INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
-- INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
-- INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
-- INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
-- INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
-- INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
-- INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
-- Find out the names of employees and their related managers


create table Project(
Employee_id int primary key	,
Full_name varchar(50),
Gender varchar(20),
Manager_id int 
);

insert into project
values
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);


select T1.Full_name as Manager_name ,T2.Full_name as employee_name from 
project as T1
join
project as T2
on T1.Employee_id = T2.Manager_id
order by Manager_name;

-- Day 8

-- Create table facility. Add the below fields into it.
-- ●	Facility_ID
-- ●	Name
-- ●	State
-- ●	Country
-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.

create table Facility(
Facility_id int ,
Name varchar(50),
State varchar(50),
country varchar(50)
);

alter table Facility
modify column Facility_id int primary key auto_increment,
add column City varchar(50) not null after Name;


-- Day 9

-- Create table university with below fields.
-- ●	ID
-- ●	Name
-- Add the below data into it as it is.
-- INSERT INTO University
-- VALUES 
-- (1, "       Pune          University     "), 
--  (2, "  Mumbai          University     "),
-- (3, "     Delhi   University     "),
-- (4, "Madras University"),
-- (5, "Nagpur University");

-- Remove the spaces from everywhere and update the column like Pune University etc.


create table University(
ID int primary key ,
Name varchar(50)
);

insert into University(ID, Name)
values
(1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");

set sql_safe_updates=0;
UPDATE University
SET Name = TRIM(BOTH  FROM REPLACE(Name,'    '," "))
WHERE ID IN (1, 2, 3,4,5);

select * from university;


-- Day 10
-- Create the view products status. Show year wise total products sold. 
-- Also find the percentage of total value for each year. The output should look as shown in below figure.

CREATE VIEW products_status AS
SELECT
   YEAR(orderDate) AS Year,
   CONCAT(COUNT(productCode), ' - ', 
           ROUND((COUNT(productCode) / SUM(COUNT(productCode)) OVER ()) * 10000,2), '%') AS VALU
FROM
    orderdetails
JOIN orders ON orderdetails.orderNumber = orders.orderNumber
GROUP BY
    YEAR(orderDate), productCode
ORDER BY
    Year;
    
    -- EX
    
 CREATE VIEW products_status AS
SELECT
    YEAR(orderDate) AS Year,
    CONCAT(
        COUNT(productcode), 
        ' (', 
        ROUND((COUNT(productcode) / SUM(COUNT(productcode)) OVER (PARTITION BY YEAR(productcode))) * 100, 2),
        '%)'
    ) AS Value
FROM
    orderdetails
JOIN orders ON orderdetails.orderNumber = orders.orderNumber
GROUP BY
    YEAR(orderDate)
ORDER BY
    Year;


    
select * from products_status;




-- Day 11
-- 1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum,
--  Gold or Silver as per below criteria.
-- Table: Customers
-- ●	Platinum: creditLimit > 100000
-- ●	Gold: creditLimit is between 25000 to 100000
-- ●	Silver: creditLimit < 25000

DELIMITER //

CREATE PROCEDURE GetCustomerLevel (
    IN CustomerNumber INT
)
BEGIN
    DECLARE CreditLimit DECIMAL(18, 2);

    -- Retrieve the credit limit for the given customer number
    SELECT creditLimit INTO CreditLimit
    FROM Customers
    WHERE customerNumber = CustomerNumber;

    -- Determine the customer level based on credit limit
    IF CreditLimit > 100000 THEN
        SELECT 'Platinum' AS CustomerLevel;
    ELSEIF CreditLimit BETWEEN 25000 AND 100000 THEN
        SELECT 'Gold' AS CustomerLevel;
    ELSE
        SELECT 'Silver' AS CustomerLevel;
    END IF;
END //

DELIMITER ;


-- 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs 
-- and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments


delimiter //
create procedure Get_country_payments( in inpute_year int , in inpute_country varchar(20))
begin 

select year(paymentDate) as year , country,concat(format(sum(amount)/1000,0),"k") as Total_amount
from payments join customers 
on payments.customerNumber=customers.customerNumber
where year(paymentDate) = inpute_year   and country= inpute_country
group by year , country;

end //
delimiter ;

CALL Get_country_payments(2003, 'france');




-- Day 12
-- 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
-- Format the YoY values in no decimals and show in % sign.
-- Table: Orders 


SELECT
    YEAR(orderDate) AS year,
    MONTHNAME(orderDate) AS month_name,
    COUNT(orderNumber) AS Total_order,
    CONCAT(
        FORMAT(
            ((COUNT(orderNumber) - LAG(COUNT(orderNumber)) OVER (ORDER BY YEAR(orderDate), monthname(orderDate))) / LAG(COUNT(orderNumber)) OVER (ORDER BY YEAR(orderDate), MONTHNAME(orderDate))) * 100,
            0
        ), 
        '%'
    ) AS YoY_percentage_change
FROM Orders
GROUP BY year,month_name
ORDER BY  year;



-- 2)	Create the table emp_udf with below fields.
-- ●	Emp_ID
-- ●	Name
-- ●	DOB
-- Add the data as shown in below query.
-- INSERT INTO Emp_UDF(Name, DOB)
-- VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), 
-- ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
-- Create a user defined function calculate_age which returns the age in years and months
-- (e.g. 30 years 5 months) by accepting DOB column as a parameter.

create table emp_udf (
Emp_id  int primary key auto_increment,
Name varchar(30),
DOB  varchar(30)
);

insert into emp_udf(Name,DOB)
values
("Piyush", "1990-03-30"),
("Aman", "1992-08-15"), 
("Meena", "1998-07-28"), 
("Ketan", "2000-11-21"), 
("Sanjay", "1995-05-21");

select * from emp_udf;


DELIMITER //
CREATE FUNCTION calculate_age(DOB DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE years_passed INT;
    DECLARE months_passed INT;

    SELECT
        YEAR(CURDATE()) - YEAR(DOB) - (RIGHT(CURDATE(), 5) < RIGHT(DOB, 5)) AS years_passed,
        PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(DOB, '%Y%m')) AS months_passed
    INTO
        years_passed, months_passed;

    RETURN CONCAT(years_passed, ' years ', months_passed, ' months');
END //
DELIMITER ;


SELECT calculate_age('1990-03-30');	






DELIMITER //
CREATE FUNCTION calculate_age1(DOB DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE years_passed INT;
    DECLARE months_passed INT;

    SELECT
        YEAR(CURDATE()) - YEAR(DOB) - (RIGHT(CURDATE(), 5) < RIGHT(DOB, 5)) AS years_passed,
        PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(DOB, '%Y%m')) AS months_passed
    INTO
        years_passed, months_passed;

    RETURN CONCAT(years_passed, ' years ', months_passed, ' months');
END //
DELIMITER ;



SELECT Emp_ID, Name, DOB, calculate_age1(DOB) AS Age FROM Emp_UDF;


-- 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
-- Table: Customers, Orders

      
SELECT customernumber, customername
FROM Customers
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders
    WHERE Customers.customernumber = Orders.customernumber
);



-- 2)	Write a full outer join between customers and orders using union and get the customer number, customer name, 
-- count of orders for every customer.
-- Table: Customers, Orders

select  customerNumber,customerName ,count(orderNumber) as Total_order
from customers left join orders using (customerNumber)
group by customerNumber,customerName
union 
select  customerNumber,customerName ,count(orderNumber) as Total_order
from orders left join customers using (customerNumber)
group by customerNumber,customerName;



-- 3)	Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails


WITH RankedOrderDetails AS (
  SELECT
    orderNumber,
    quantityOrdered,
    DENSE_RANK() OVER (PARTITION BY orderNumber ORDER BY quantityOrdered DESC) AS Rankx
  FROM
    orderdetails
)
SELECT
  orderNumber,
  quantityOrdered
FROM
  RankedOrderDetails
WHERE
  Rankx = 2;

	
-- 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
-- Table: Orderdetails   

SELECT
   MAX(COUNT(productCode)) OVER () AS MaxCountOfProducts,
  MIN(COUNT(productCode)) OVER () AS MinCountOfProducts
FROM
  Orderdetails
GROUP BY
  orderNumber;
  
  -- 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
  -- Show the output as product line and its count.
  

SELECT
  productLine,count(productLine),
  AVG(buyPrice) AS Avg_prize
FROM
  products
GROUP BY
  productLine
HAVING
  AVG(buyPrice) >= Avg_prize;



SELECT
  productLine,
  COUNT(productLine) AS ProductLineCount
FROM
  products
WHERE
  buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY
  productLine;
  
  
  -- Day 14
-- Create the table Emp_EH. Below are its fields.
-- ●	EmpID (Primary Key)
-- ●	EmpName
-- ●	EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
-- Show the message as “Error occurred” in case of anything wrong.

  create table Emp_EH(
  EmpID int primary key,
  EmpName varchar(30),
  EmaileAddress varchar(50)
  );
  
  
  






 
    
  
    
    
    
    
    
    
    
    
    
    
    