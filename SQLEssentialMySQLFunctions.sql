# Essential MySQL Functions


# Numeric Functions
SELECT ROUND(5.7345, 3);
SELECT TRUNCATE(5.7345, 2);
SELECT CEILING(5.2);
SELECT ROUND(5.2);
SELECT FLOOR(5.4);
SELECT ABS(5.2);
SELECT ABS(-5.2);

SELECT RAND();



# String Functions
SELECT LENGTH('sky');
SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT LTRIM(' SKY');
SELECT RTRIM('SKY   ');
SELECT TRIM('SKY   ');

SELECT LEFT('Kindergarten', 4);
SELECT RIGHT('Kindergarten', 6);
SELECT SUBSTRING('Kindergarten', 3, 5);
SELECT SUBSTRING('Kindergarten', 3);
SELECT LOCATE('N', 'Kindergarten');
SELECT LOCATE('Q', 'Kindergarten');
SELECT REPLACE('Kindergarten', 'garten', 'garden');
SELECT CONCAT('first', 'last');




# DATE functions
SELECT NOW(), CURDATE(), CURTIME();
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());
SELECT DAYNAME(NOW()), MONTHNAME(NOW());
SELECT EXTRACT(YEAR FROM NOW());
-- Exercise
SELECT * FROM orders WHERE YEAR(order_date) = YEAR(CURDATE())-4;


# DATE Formats and Calculation
SELECT DATE_FORMAT(NOW(), '%Y-%M-%d');
SELECT TIME_FORMAT(NOW(), '%h:%i %p');

SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 1 MONTH);
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);
SELECT DATE_SUB(NOW(), INTERVAL 1 DAY);
SELECT DATE_SUB(NOW(), INTERVAL 1 MONTH);
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);

SELECT DATEDIFF('2019-02-01', '2019-01-01');
SELECT TIME_TO_SEC('9:00') - TIME_TO_SEC('9:30');






# IFNULL and COALESCE
SELECT order_id,
       IFNULL(shipper_id, 'Not Assigned'),
       COALESCE(shipper_id, comments, 'Not Assigned')
    FROM orders ORDER BY order_id;
-- Exercise
SELECT CONCAT(first_name, ' ', last_name) AS customer,
       IFNULL(phone, 'UNKNOWN') AS phone
    FROM customers;





# IF and CASE
SELECT order_id, order_date,
       IF(YEAR(order_date)=YEAR(NOW())-4, 'Active', 'Archive') AS category
    FROM orders;
-- Exercise
SELECT product_id,
       name,
       COUNT(oi.order_id) as orders,
       IF(COUNT(oi.order_id)>1, 'Many times', 'Once') as frequency
    FROM products JOIN order_items oi USING (product_id)
    GROUP BY product_id;

SELECT order_id,
       order_date,
       CASE
            WHEN YEAR(order_date) = YEAR(NOW())-4 THEN 'Active'
            WHEN YEAR(order_date) = YEAR(NOW())-5 THEN 'Last Year'
            WHEN YEAR(order_date) < YEAR(NOW())-5 THEN 'Archived'
            ELSE 'Future'
       END as category
    FROM orders;
-- Exercise
SELECT CONCAT(first_name,' ', last_name) AS customer,
       points,
       CASE
           WHEN points > 3000 THEN 'Gold'
           WHEN points >= 2000 THEN 'Silver'
           ELSE 'Bronze'
       END as category
    FROM customers ORDER BY points DESC;