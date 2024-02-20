USE sql_store;

# JOINS
SELECT * FROM orders o JOIN customers c ON o.customer_id = c.customer_id; -- JOIN is same as INNER JOIN
SELECT order_id, o.customer_id, first_name, last_name FROM orders o JOIN customers c ON o.customer_id = c.customer_id
                                                        ORDER BY o.order_id;

SELECT order_id, p.name, quantity, oi.unit_price FROM order_items oi JOIN products p
    ON oi.product_id = p.product_id ORDER BY order_id;





# SELF JOIN and JOIN Across Multiple Databases
SELECT * FROM order_items o JOIN sql_inventory.products p ON o.product_id = p.product_id;
-- Find the employee's manager
SELECT e.employee_id, e.first_name, m.first_name as manager_name FROM sql_hr.employees e
    JOIN sql_hr.employees m ON e.reports_to = m.employee_id
    ORDER BY e.first_name;




# INNER JOIN with Multiple Tables
SELECT o.order_id, o.order_date ,c.first_name, c.last_name, os.name FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_statuses os ON o.status = os.order_status_id
    ORDER BY o.order_id;
-- Exercise
SELECT p.payment_id, c.name, i.number, p.date, p.amount, pm.name  FROM sql_invoicing.payments p
    JOIN sql_invoicing.clients c ON p.client_id = c.client_id
    JOIN sql_invoicing.invoices i ON p.invoice_id = i.invoice_id
    JOIN sql_invoicing.payment_methods pm ON p.payment_method = pm.payment_method_id
    ORDER BY p.payment_id;




# Compound JOIN
-- when a table have composite key
SELECT * FROM order_items oi
    JOIN order_item_notes oin
        ON oi.order_id = oin.order_Id
    AND oi.product_id = oin.product_id;



# Implicit Join Syntax
SELECT * FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id;
-- Equivalent to
SELECT * FROM orders o, customers c
         WHERE o.customer_id = c.customer_id;





# Outer JOIN
SELECT  c.customer_id, c.first_name, o.order_id FROM customers c
    LEFT JOIN orders o on c.customer_id = o.customer_id
ORDER BY c.customer_id;
-- outer keyword is optional
-- LEFT OUTER JOIN - condition is not validated, Bring everything from left table
-- RIGHT OUTER JOIN - condition is not validated, Bring everything from right table
SELECT p.product_id, p.name, oi.quantity FROM products p
    LEFT JOIN order_items oi on p.product_id = oi.product_id;



# OUTER JOIN with Multiple Table
SELECT c.customer_id, c.first_name, o.order_id, sh.name FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN shippers sh ON o.shipper_id = sh.shipper_id
    WHERE o.order_id IS NOT NULL
    ORDER BY c.customer_id, o.order_id;
-- As a best practice avoid right joins and always use left joins
SELECT o.order_date, o.order_id, c.first_name, s.name, os.name FROM orders o
    JOIN customers c on o.customer_id = c.customer_id
    LEFT JOIN shippers s on o.shipper_id = s.shipper_id
    LEFT JOIN order_statuses os on o.status = os.order_status_id
    ORDER BY os.name;




# SELF OUTER JOIN
-- We worked on SELF INNER JOIN for Employee and Manager tables
SELECT e.employee_id, e.first_name, m.first_name as manager_name FROM sql_hr.employees e
    JOIN sql_hr.employees m ON e.reports_to = m.employee_id
    ORDER BY e.employee_id;
-- Here manager data is missing. Hence, we use outer self join
SELECT e.employee_id, e.first_name, m.first_name as manager_name FROM sql_hr.employees e
    LEFT JOIN sql_hr.employees m ON e.reports_to = m.employee_id
    ORDER BY e.employee_id;




# USING KEYWORD
-- using keyword can be used when the column names are same across the tables
SELECT o.order_id, c.first_name, s.name FROM orders o
    JOIN customers c on o.customer_id = c.customer_id
    LEFT JOIN shippers s on o.shipper_id = s.shipper_id
    ORDER BY o.order_id;
-- OR
SELECT o.order_id, c.first_name, s.name FROM orders o
    JOIN customers c USING (customer_id)
    LEFT JOIN shippers s USING (shipper_id)
    ORDER BY o.order_id;
-- Example 2 Compound JOIN
SELECT oi.order_id, oi.product_id, oin.note FROM order_items oi
    JOIN order_item_notes oin
        ON oi.order_id = oin.order_Id
    AND oi.product_id = oin.product_id;
-- OR
SELECT oi.order_id, oi.product_id, oin.note FROM order_items oi
    JOIN order_item_notes oin
        USING (order_id, product_id);
-- Exercise
SELECT p.date, c.name ,p.amount, pm.name FROM sql_invoicing.payments p
    LEFT JOIN sql_invoicing.clients c USING (client_id)
    LEFT JOIN sql_invoicing.payment_methods pm
        ON p.payment_method = pm.payment_method_id;





# NATURAL JOIN - Depreciated
-- Allowing Database Engine to do the join based on same column. So, its dangerous.
SELECT o.order_id, c.first_name FROM orders o
    NATURAL JOIN customers c;




# CROSS JOIN
SELECT c.first_name, p.name
    FROM customers c CROSS JOIN products p;
-- Exercise with Implicit and Explicit
SELECT p.name, sh.name FROM products p CROSS JOIN shippers sh;
SELECT p.name, sh.name FROM products p, shippers sh;




# UNION
-- can be used to combine a row, but make sure same number of column in a queries
SELECT order_id, order_date, 'Active' AS status FROM orders WHERE order_date >= '2019-01-01'
UNION
SELECT order_id, order_date, 'Inactive' AS status FROM orders WHERE order_date < '2019-01-01';
-- OR
SELECT order_id, order_date, CASE WHEN order_date >= '2019-01-01' THEN 'Active' ELSE 'Inactive' END AS status
    FROM orders;
-- OR 
SELECT order_id, order_date, IF(order_date >= '2019-01-01', 'Active', 'Inactive') AS status
    FROM orders;