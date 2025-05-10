# 📄 Library Management System using SQL

## 🌟 Project Overview

**Title**: Library Management System
**Level**: Intermediate
**Database Name**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It showcases skills in:

* Designing and creating relational databases
* Performing CRUD operations
* Writing complex queries for data analysis
* Using CTAS (Create Table As Select)

---

## 🔬 Objectives

* Set up a normalized relational database for library operations
* Populate the database with realistic data
* Perform Create, Read, Update, and Delete operations
* Create derived tables using CTAS
* Write advanced SQL queries to retrieve and analyze data

---

## 📁 Project Structure

### 1. Database Setup

* **Database**: `library_db`
* **Entities**: Branches, Employees, Members, Books, Issued Status, Return Status


### 2. Table Creation Scripts

```sql
-- Branch Table
DROP TABLE IF EXISTS Branch;
CREATE TABLE IF NOT EXISTS Branch (
    branch_id VARCHAR(5) PRIMARY KEY,
    manager_id VARCHAR(5),
    branch_address VARCHAR(75),
    contact_no VARCHAR(15)
);

-- Employees Table
DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees (
    emp_id VARCHAR(5) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(25),
    salary INT,
    branch_id VARCHAR(5) REFERENCES Branch(branch_id)
);

-- Books Table
DROP TABLE IF EXISTS Books;
CREATE TABLE IF NOT EXISTS Books (
    isbn VARCHAR(30) PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(25),
    rental_price FLOAT,
    status VARCHAR(3),
    author VARCHAR(25),
    publisher VARCHAR(30)
);

-- Members Table
DROP TABLE IF EXISTS Members;
CREATE TABLE IF NOT EXISTS Members (
    member_id VARCHAR(5) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(75),
    reg_date DATE
);

-- Issued Status Table
DROP TABLE IF EXISTS Issued_status;
CREATE TABLE IF NOT EXISTS Issued_status (
    issued_id VARCHAR(8) PRIMARY KEY,
    issued_member_id VARCHAR(5) REFERENCES Members(member_id),
    issued_book_name VARCHAR(100),
    issued_date DATE,
    issued_book_isbn VARCHAR(30) REFERENCES Books(isbn),
    issued_emp_id VARCHAR(5) REFERENCES Employees(emp_id)
);

-- Return Status Table
DROP TABLE IF EXISTS Return_status;
CREATE TABLE IF NOT EXISTS Return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10) REFERENCES Issued_status(issued_id),
    return_book_name VARCHAR(100),
    return_date DATE,
    return_book_isbn VARCHAR(30) REFERENCES Books(isbn)
);
```

### 3. Sample Data Insertion (Return Table)

```sql
INSERT INTO return_status(return_id, issued_id, return_date)
VALUES
('RS104', 'IS106', '2024-05-01'),
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');
```

---

## ⚙️ CRUD Operations

```sql
-- Create a New Book Record
INSERT INTO Books
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Update Member Address
UPDATE Members
SET member_address = '134 Avenue Road'
WHERE member_id = 'C119';

-- Delete a Record
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Retrieve Books Issued by an Employee
SELECT * FROM issued_status WHERE issued_emp_id = 'E101';

-- List Members with More Than One Book Issued
SELECT issued_member_id AS Member, COUNT(*) AS no_of_books
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1;
```

---

## ✅ CTAS (Create Table As Select)

```sql
-- Create Summary Table: Book Issue Counts
CREATE TABLE book_counts AS
SELECT
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS no_of_issues
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

---

## 📊 Data Analysis & Insights

```sql
-- Books in Category 'Mystery'
SELECT * FROM books WHERE category = 'Mystery';

-- Total Rental Income by Category
SELECT b.category, SUM(b.rental_price) AS total_rent, COUNT(*)
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY b.category
ORDER BY total_rent DESC;

-- Employees with Branch Manager Name
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name AS manager_name
FROM Employees AS e1
JOIN branch AS b ON e1.branch_id = b.branch_id
LEFT JOIN Employees AS e2 ON e2.emp_id = b.manager_id;

-- Books with Rental Price > $6
CREATE TABLE exp_books AS
SELECT * FROM books WHERE rental_price > 6;

-- Books Not Yet Returned
SELECT DISTINCT ist.issued_book_name
FROM issued_status AS ist
LEFT JOIN return_status AS rs ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
```

---

## 🔎 Advanced SQL Query

```sql
-- Identify Members with Overdue Books > 400 Days
SELECT
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status AS ist
JOIN Members AS m ON ist.issued_member_id = m.member_id
JOIN books AS bk ON ist.issued_book_isbn = bk.isbn
LEFT JOIN return_status AS rs ON ist.issued_id = rs.issued_id
WHERE rs.return_date IS NULL
  AND CURRENT_DATE - ist.issued_date > 400
ORDER BY ist.issued_member_id;
```

---

## 📅 Conclusion

This Library Management System SQL project illustrates proficiency in:

* Data modeling and database creation
* Writing SQL for operations and analysis
* Using CTAS for reporting
* Extracting actionable insights from data

It's an excellent intermediate project for aspiring Data Analysts and Data Engineers to showcase SQL competency.

---

---

## 📰 Author

**Yashwanth S R**
*Aspiring Data Engineer | Passionate SQL Practitioner*
