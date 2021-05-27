### 1 ###
### SQL Basics: Simple JOIN with COUNT(7 kyu) ###
###For this challenge you need to create a simple SELECT statement that will return all columns from the people table, and join to the toys table so that you can return the COUNT of the toys###
SELECT p.id, p.name, COUNT(t.id) AS toy_count
FROM people p
LEFT JOIN toys t ON t.people_id = p.id
GROUP BY p.id, p.name

### 2 ###
### SQL Basics: Top 10 customers by total payments amount(6 kyu) ###
###Your are working for a company that wants to reward its top 10 customers with a free gift. You have been asked to generate a simple report that returns the top 10 customers by total amount spent ordered from highest to lowest. Total number of payments has also been requested.###
SELECT p.customer_id, c.email, COUNT(p.payment_id) AS payments_count , CAST (SUM(p.amount) AS FLOAT) AS total_amount
FROM payment p
JOIN customer c ON c.customer_id = p.customer_id
GROUP BY p.customer_id, c.email
ORDER BY total_amount DESC LIMIT 10

### 3 ###
### SQL Basics: Simple FULL TEXT SEARCH(6 kyu) ###
###For this challenge you need to create a simple SELECT statement. Your task is to create a query and do a FULL TEXT SEARCH. You must search the product table on the field name for the word Awesome and return each row with the given word. Your query MUST contain to_tsvector and to_tsquery PostgreSQL functions.###
SELECT * FROM
  product
WHERE
  to_tsvector(name) @@ to_tsquery('Awesome')

### 4 ###
### Easy SQL: Absolute Value and Log to Base(7 kyu) ###
###Return a table with two columns (abs, log) where the values in abs are the absolute values of number1 and the values in log are values from number2 in logarithm to base 64.###
SELECT
  ABS(number1) AS abs,
  LOG(64, number2) AS log
FROM decimals

### 5 ###
### SQL Basics: Simple EXISTS(6 kyu) ###
###For this challenge you need to create a SELECT statement that will contain data about departments that had a sale with a price over 98.00 dollars. This SELECT statement will have to use an EXISTS to achieve the task.###
SELECT * FROM departments d
  WHERE EXISTS (SELECT * FROM sales WHERE department_id = d.id AND price > 98)

### 6 ###
### SQL Basics: Simple VIEW(5 kyu) ###
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
### SQL: Regex AlphaNumeric Split(6 kyu) ###
###Your job is to split out the letters and numbers from the address provided, and return a table in the following format.###
SELECT  project,
        REGEXP_REPLACE(address, '\d', '', 'g') AS letters,
        REGEXP_REPLACE(address, '[a-zA-Z]', '', 'g') AS numbers
FROM
        repositories

### 8 ###
### Calculating Running Total(5 kyu) ###
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
### Count IP Addresses(5 kyu) ###
###Given a database of first and last IPv4 addresses, calculate the number of addresses between them (including the first one, excluding the last one).###
CREATE FUNCTION ip2int(text) RETURNS bigint AS $$
SELECT split_part($1,'.',1)::bigint*16777216 + split_part($1,'.',2)::bigint*65536 +
 split_part($1,'.',3)::bigint*256 + split_part($1,'.',4)::bigint;
$$ LANGUAGE SQL  IMMUTABLE RETURNS NULL ON NULL INPUT;

SELECT id, (ip2int(last) - ip2int(first)) AS ips_between FROM ip_addresses;

### 10 ###
### Grasshopper - Check for factor(8 kyu) ###
###This function should test if the factor is a factor of base. Return true if it is a factor or false if it is not.###
SELECT
  id,
  CASE
    WHEN base % factor = 0
      THEN true
      ELSE FALSE
  END res
FROM kata

### 11 ###
### SQL Basics: Group By Day(5 kyu) ###
###There is an events table used to track different key activities taken on a website. For this task you need to filter the name field to only show "trained" events. Events should be grouped by the day they happened and counted. The description field is used to distinguish which items the events happened on.###
SELECT CAST(created_at AS DATE) AS day, description, COUNT(*) FROM events
  WHERE name LIKE 'trained'
  GROUP BY description, CAST(created_at AS DATE)
  ORDER BY day

### 12(NO) ###
### SQL Basics: Simple PIVOTING data(5 kyu) ###
###For this challenge you need to PIVOT data. You have two tables, products and details. Your task is to pivot the rows in products to produce a table of products which have rows of their detail. Group and Order by the name of the Product.###
CREATE EXTENSION tablefunc;
SELECT * FROM crosstab (
  'SELECT p.name, d.detail, COUNT(*) AS col FROM products p
    JOIN details d ON d.product_id = p.id
    GROUP BY p.name, d.detail
    ORDER BY p.name, CASE WHEN d.detail LIKE `good` THEN 1 WHEN d.detail LIKE `ok` THEN 2 ELSE 3 END'
) AS ct(name text, "good" text, "ok" text, "bad" text);
