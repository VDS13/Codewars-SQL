### 1 ###
###For this challenge you need to create a simple SELECT statement that will return all columns from the people table, and join to the toys table so that you can return the COUNT of the toys###
SELECT p.id, p.name, COUNT(t.id) AS toy_count
FROM people p
LEFT JOIN toys t ON t.people_id = p.id
GROUP BY p.id, p.name

### 2 ###
###Your are working for a company that wants to reward its top 10 customers with a free gift. You have been asked to generate a simple report that returns the top 10 customers by total amount spent ordered from highest to lowest. Total number of payments has also been requested.###
SELECT p.customer_id, c.email, COUNT(p.payment_id) AS payments_count , CAST (SUM(p.amount) AS FLOAT) AS total_amount
FROM payment p
JOIN customer c ON c.customer_id = p.customer_id
GROUP BY p.customer_id, c.email
ORDER BY total_amount DESC LIMIT 10

### 3 ###
###For this challenge you need to create a simple SELECT statement. Your task is to create a query and do a FULL TEXT SEARCH. You must search the product table on the field name for the word Awesome and return each row with the given word. Your query MUST contain to_tsvector and to_tsquery PostgreSQL functions.###
SELECT * FROM
  product
WHERE
  to_tsvector(name) @@ to_tsquery('Awesome')

### 4 ###
###Return a table with two columns (abs, log) where the values in abs are the absolute values of number1 and the values in log are values from number2 in logarithm to base 64.###
SELECT
  ABS(number1) AS abs,
  LOG(64, number2) AS log
FROM decimals

### 5 ###
###For this challenge you need to create a SELECT statement that will contain data about departments that had a sale with a price over 98.00 dollars. This SELECT statement will have to use an EXISTS to achieve the task.###
SELECT * FROM departments d
  WHERE EXISTS (SELECT * FROM sales WHERE department_id = d.id AND price > 98)

### 6 ###
###For this challenge you need to create a VIEW. This VIEW is used by a sales store to give out vouches to members who have spent over $1000 in departments that have brought in more than $10000 total ordered by the members id. The VIEW must be called members_approved_for_voucher then you must create a SELECT query using the view.###
CREATE VIEW members_approved_for_voucher AS
  SELECT m.id, m.name, m.email, SUM(p.price) AS total_spending FROM members m
    JOIN sales s ON s.member_id = m.id
    JOIN products p ON p.id = s.product_id
    WHERE s.department_id IN (SELECT s1.department_id FROM sales s1 
                              LEFT JOIN  products p1 ON p1.id = s1.product_id 
                              GROUP BY s1.department_id 
                              HAVING SUM(p1.price) > 10000)
    GROUP BY m.id, m.name, m.email
    HAVING SUM(p.price) > 1000
    ORDER BY m.id;
 SELECT * FROM members_approved_for_voucher;

### 7 ###
###Your job is to split out the letters and numbers from the address provided, and return a table in the following format.###
SELECT  project,
        REGEXP_REPLACE(address, '\d', '', 'g') AS letters,
        REGEXP_REPLACE(address, '[a-zA-Z]', '', 'g') AS numbers
FROM
        repositories

### 8 ###
###Given a posts table that contains a created_at timestamp column write a query that returns date (without time component), a number of posts for a given date and a running (cumulative) total number of posts up until a given date. The resulting set should be ordered chronologically by date..###
SELECT  tmp.date_s AS date,
        tmp.count,
        (SELECT COUNT(p1.id) FROM posts p1 WHERE DATE_PART('day', p1.created_at - tmp.date_s) <= 0) AS total
FROM
(SELECT CAST(p.created_at AS DATE) AS date_s,
        COUNT(p.id) AS count
FROM posts p
GROUP BY CAST(p.created_at AS DATE)
ORDER BY CAST(p.created_at AS DATE)) tmp

### 9 ###
