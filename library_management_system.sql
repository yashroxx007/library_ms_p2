--Library Management System Project 2

--Creating Branch table
DROP TABLE IF EXISTS Branch;
CREATE TABLE IF NOT EXISTS Branch
    (
        branch_id VARCHAR(5) PRIMARY KEY,
        manager_id VARCHAR(5),
        branch_address VARCHAR(75),
        contact_no INT
    );

ALTER TABLE Branch
ALTER COLUMN contact_no TYPE VARCHAR(15);


DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees 
    (
        emp_id VARCHAR(5) PRIMARY KEY,
        emp_name VARCHAR(25),
        position VARCHAR(25),
        salary INT,
        branch_id VARCHAR(5) REFERENCES Branch(branch_id)
    );

DROP TABLE IF EXISTS Books;
 CREATE TABLE IF NOT EXISTS Books
    (
        isbn VARCHAR(30) PRIMARY KEY,
        book_title VARCHAR(100),
        category VARCHAR(25),
        rental_price FLOAT,
        status VARCHAR(3),
        author VARCHAR(25),
        publisher VARCHAR(30)
    );

DROP TABLE IF EXISTS Members;
CREATE TABLE IF NOT EXISTS Members
    (
        member_id VARCHAR(5) PRIMARY KEY,
        member_name VARCHAR(25),
        member_address VARCHAR(75),
        reg_date DATE
    );

DROP TABLE IF EXISTS Issued_status;
CREATE TABLE IF NOT EXISTS Issued_status
    (
        issued_id VARCHAR(8) PRIMARY KEY,
        issued_member_id VARCHAR(5) REFERENCES Members(member_id),
        issued_book_name VARCHAR(100),
        issued_date DATE,
        issued_book_isbn VARCHAR(30) REFERENCES Books(isbn),
        issued_emp_id VARCHAR(5) REFERENCES Employees(emp_id)
    );

DROP TABLE IF EXISTS Return_status;
CREATE TABLE IF NOT EXISTS Return_status
    (
        return_id VARCHAR(10) PRIMARY KEY,
        issued_id VARCHAR(10) REFERENCES Issued_status(issued_id),
        return_book_name VARCHAR(100),
        return_date DATE,
        return_book_isbn VARCHAR(30) REFERENCES Books(isbn)
    );


-- inserting into return table
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

UPDATE TABLE Issued_status
SET 

--Queries
--CRUD Operations

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

SELECT * FROM books

INSERT INTO Books 
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

--Task 2: Update an Existing Member's Address

SELECT * FROM members

UPDATE Members
SET member_address = '134 Avenue Road'
WHERE member_id = 'C119';

--Task 3: Delete a Record from the Issued Status Table 
--Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status;

DELETE
FROM issued_status
WHERE issued_id = 'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee 
--Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';

--Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT * FROM issued_status;

SELECT
    issued_member_id AS Member,
    COUNT(issued_book_isbn) AS no_of_books
FROM issued_status
GROUP BY 1
HAVING COUNT(issued_book_isbn) > 1


--3. CTAS (Create Table As Select)

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

CREATE TABLE book_counts
     AS
        SELECT 
            b.isbn,
            b.book_title,
            COUNT(ist.issued_id) AS no_of_issues
        FROM books as b 
        JOIN 
        issued_status as ist 
        ON ist.issued_book_isbn = b.isbn
        GROUP BY 1;

SELECT * FROM book_counts

--4. Data Analysis & Findings
--The following SQL queries were used to address specific questions:

--Task 7. Retrieve All Books in a Specific Category: Mystery\
SELECT * FROM books

SELECT *
FROM books
WHERE category = 'Mystery'

--Task 8: Find Total Rental Income by Category:

SELECT *
FROM issued_status

    SELECT
        b.category,
        SUM(b.rental_price) AS total_rent,
        COUNT(*)
    FROM books as b 
    JOIN issued_status as ist
    ON ist.issued_book_isbn = b.isbn
    GROUP BY 1
    ORDER BY 2 DESC;

--Task 9: List Employees with Their Branch Manager's Name and their branch details:

SELECT * FROM branch

SELECT
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager_name
FROM Employees as e1
JOIN branch as b
ON e1.branch_id = b.branch_id
LEFT JOIN Employees as e2
ON e2.emp_id = b.manager_id;

--Task 10: Create a Table of Books with Rental Price Above a Certain Threshold: 6USD

SELECT * FROM exp_books

CREATE TABLE exp_books AS
SELECT * 
FROM books
WHERE rental_price > 6;

--Task 11: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status
SELECT * FROM return_status

SELECT 
    DISTINCT ist.issued_book_title
FROM issued_status as ist 
LEFT JOIN
return_status AS rs   
ON
ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;


--ADVANCED SQL OPERATIONS
--TASK 1: Identify Members with Overdue Books
--Write a query to identify members who have overdue books i.e., more than 400 days

--Issued_status == Members == Books == return_status
--filter books returned
--overdue > 30days

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    CURRENT_DATE - ist.issued_date AS overdue_days
FROM issued_status as ist
JOIN Members as m
ON ist.issued_member_id = m.member_id
JOIN books as bk
ON ist.issued_book_isbn = bk.isbn
LEFT JOIN return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_date is NULL
    AND 
    CURRENT_DATE - ist.issued_date > 400
ORDER BY 1;




