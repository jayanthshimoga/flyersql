USE sql_store;

# SELECT - is DML command
SELECT * FROM sql_store.customers WHERE customer_id > 4 ORDER BY first_name;
SELECT count(customer_id) from customers;
SELECT 1, 2;
SELECT last_name,
       first_name,
       (points + 10) * 100 as "customer points" from customers; #MODULAS
SELECT DISTINCT state FROM customers;

#FIND DUPLICATES
SELECT state, COUNT(state) FROM customers GROUP BY state HAVING COUNT(state) > 1;
SELECT * FROM (SELECT *, COUNT(*) OVER (PARTITION BY state) AS cnt FROM customers) AS S where S.cnt > 1;

SELECT name,unit_price, (unit_price * 1.1) as new_price FROM products;





# WHERE CLAUSE with Comparison Operator
SELECT * FROM customers WHERE state = 'VA';
SELECT * FROM customers WHERE state <> 'VA';
SELECT * FROM customers WHERE birth_date > '1990-01-01';

SELECT * FROM orders WHERE order_date > '2019-01-01';
SELECT * FROM customers WHERE NOT (birth_date > '1990-01-01' or points > 1000 and state = 'VA');

SELECT * FROM order_items WHERE order_id = 6 AND unit_price * quantity > 30;





# logical Operator with IN, NOT IN, BETWEEN, LIKE
SELECT * FROM customers WHERE state = 'GA' OR state = 'VA' OR state = 'FL';
#OR
SELECT * FROM customers WHERE state IN ('GA', 'VA', 'FL');
SELECT * FROM products WHERE quantity_in_stock IN (49, 38, 72);

SELECT * FROM customers WHERE points >=1000 AND points <= 3000;
#OR
SELECT * FROM customers WHERE points BETWEEN 1000 AND 3000;
SELECT * FROM customers WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';
SELECT * FROM customers WHERE first_name BETWEEN 'Ilene' AND 'Romola';

SELECT * FROM customers WHERE last_name LIKE 'b%';
SELECT * FROM customers WHERE last_name LIKE '%et%';
SELECT * FROM customers WHERE last_name LIKE '_____y';
-- % is for any number of characters
-- _ is for single characters
SELECT * FROM customers WHERE address LIKE '%TRAIL%' OR address LIKE '%AVENUE%';
-- OR
SELECT * FROM customers WHERE address REGEXP 'TRAIL|AVENUE';
SELECT * FROM customers WHERE phone LIKE '%9';





# REGEX Pattern
SELECT * FROM customers WHERE last_name REGEXP 'field';
SELECT * FROM customers WHERE last_name REGEXP '^b'; #starts with
SELECT * FROM customers WHERE last_name REGEXP 'y$'; #ends with
SELECT * FROM customers WHERE last_name REGEXP 'o|g|f'; #multiple values
SELECT * FROM customers WHERE address REGEXP 'TRAIL|AVENUE';
SELECT * FROM customers WHERE last_name REGEXP '[a-h]e';
-- ^ beginning
-- $ end
-- | logical or
-- [abcd]
-- [a-f]
SELECT * FROM customers WHERE first_name REGEXP 'ELKA|AMBUR';
SELECT * FROM customers WHERE last_name REGEXP 'EY$|ON$';
SELECT * FROM customers WHERE last_name REGEXP '^MY|SE';
SELECT * FROM customers WHERE last_name REGEXP 'B[RU]';


# IS NULL and ORDER BY
SELECT * FROM customers WHERE phone IS NULL;
SELECT * FROM customers WHERE phone IS NOT NULL;
SELECT * FROM orders WHERE shipped_date IS NULL;

SELECT * FROM customers ORDER BY first_name;
SELECT * FROM customers ORDER BY first_name DESC;
SELECT * FROM customers ORDER BY state, first_name;
SELECT * FROM customers ORDER BY state DESC, first_name DESC;
SELECT first_name, last_name FROM customers ORDER BY birth_date;
SELECT first_name, last_name, 10 * 80 as points FROM customers ORDER BY points, first_name;
SELECT first_name, last_name, 10 * 80 as points FROM customers ORDER BY 1, 2; #AVOID
-- In MYSQL you can have columns in ORDER By clause even if you have not in SELECT clause

SELECT * FROM order_items WHERE order_id = 2 ORDER BY quantity;
SELECT *, quantity * unit_price as total_price FROM order_items WHERE order_id = 2
                                                                ORDER BY total_price DESC;




# OFFSET and LIMIT
SELECT * FROM customers LIMIT 3;
SELECT * FROM customers LIMIT 6, 3; # Here, 6 is the offset
-- page 1: 1-3
-- page 2: 4-6
-- page 3: 7-9
SELECT * FROM customers ORDER BY points DESC LIMIT 3;