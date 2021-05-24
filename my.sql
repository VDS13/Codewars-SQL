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
###Given a Divisor and a Bound , Find the largest integer N , Such That ,###
###Conditions :###
###N is divisible by divisor###
###N is less than or equal to bound###
###N is greater than 0.###