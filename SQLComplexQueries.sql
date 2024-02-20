# Complex Queries
USE sql_store;


# SUB-QUERY
SELECT * FROM products
         WHERE unit_price > (
         SELECT unit_price FROM products
                           WHERE product_id = 3
                                         );
-- Exercise
-- Find employees who earn more than Average
SELECT * FROM sql_hr.employees
         WHERE salary > ( SELECT AVG(salary) FROM sql_hr.employees )
         ORDER BY salary;




# IN Operator with SUB-QUERY
-- Products that never been ordered
SELECT * FROM products
         WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);
-- Find a clients without invoices
SELECT * FROM sql_invoicing.clients
         WHERE client_id NOT IN (SELECT DISTINCT client_id FROM sql_invoicing.invoices);





# SUb-QUERY VS JOINS
SELECT * FROM sql_invoicing.clients
         WHERE client_id NOT IN (SELECT DISTINCT client_id FROM sql_invoicing.invoices);
-- IN JOINS
SELECT * FROM sql_invoicing.clients
    LEFT JOIN sql_invoicing.invoices ON clients.client_id = invoices.client_id
                                  WHERE invoice_id IS NULL;
-- Exercise
SELECT customer_id, first_name, last_name FROM customers
        WHERE customer_id IN ( SELECT customer_id FROM orders
                                                  WHERE order_id IN ( SELECT DISTINCT order_id FROM order_items
                                                                                               WHERE product_id = 3));
-- Exercise in JOINS
SELECT DISTINCT c.customer_id, c.first_name, c.last_name FROM customers c
    LEFT JOIN orders o USING ( customer_id )
    LEFT JOIN order_items oi USING ( order_id )
    WHERE oi.product_id = 3;





# ALL Keyword
SELECT * FROM sql_invoicing.invoices
         WHERE invoice_total > ( SELECT MAX(invoice_total) FROM sql_invoicing.invoices
                                                           WHERE client_id = 3 );
-- OR
SELECT * FROM sql_invoicing.invoices
         WHERE invoice_total > ALL ( SELECT invoice_total FROM sql_invoicing.invoices
                                                           WHERE client_id = 3 );





# ANY Keyword  ==  IN operator
SELECT * FROM sql_invoicing.clients WHERE client_id IN
 (SELECT client_id FROM sql_invoicing.invoices
                           GROUP BY client_id HAVING COUNT(*) >= 2);
-- OR
SELECT * FROM sql_invoicing.clients WHERE client_id = ANY
 (SELECT client_id FROM sql_invoicing.invoices
                           GROUP BY client_id HAVING COUNT(*) >= 2);






# CORRELATED SubQueries  ************
-- GET Average salary not across office but for particular offices
SELECT * FROM sql_hr.employees e WHERE salary > (
    SELECT AVG(salary) FROM sql_hr.employees
                       WHERE office_id = e.office_id
);
-- Exercise
SELECT * FROM sql_invoicing.invoices i WHERE invoice_total > (
    SELECT AVG(invoice_total) FROM sql_invoicing.invoices
                              WHERE client_id = i.client_id
    )
ORDER BY i.invoice_id;
SELECT * FROM sql_invoicing.invoices i WHERE invoice_total > (
    SELECT AVG(invoice_total) FROM sql_invoicing.invoices
    )ORDER BY i.invoice_id;





# EXISTS Keyword - PERFORMANCE
SELECT  client_id FROM sql_invoicing.clients
                  WHERE client_id IN (SELECT DISTINCT client_id FROM sql_invoicing.invoices);
-- OR
SELECT DISTINCT client_id FROM sql_invoicing.clients
    JOIN sql_invoicing.invoices i USING (client_id);
-- OR
SELECT * FROM sql_invoicing.clients WHERE EXISTS
    (SELECT client_id FROM sql_invoicing.invoices i
        WHERE i.client_id = clients.client_id );
-- Exercise
-- Find a product that never been ordered
SELECT * FROM products p WHERE NOT EXISTS
    (SELECT product_id FROM order_items
                       WHERE product_id = p.product_id);





# SUB-QUERIES in SELECT Clause
SELECT invoice_id, invoice_total AS invoice_total,
       (SELECT AVG(invoice_total) FROM sql_invoicing.invoices) AS invoice_average,
       invoice_total - (SELECT invoice_average) AS differences
        FROM sql_invoicing.invoices;
-- Exercise
SELECT client_id,
       name,
       (SELECT SUM(invoice_total) FROM sql_invoicing.invoices
                                  WHERE invoices.client_id = clients.client_id) AS total_sales,
       (SELECT AVG(invoice_total) FROM sql_invoicing.invoices) AS average,
       (SELECT total_sales - average) AS difference
       FROM sql_invoicing.clients;





# SUB-QUERIES in FROM Clause
SELECT * FROM
(SELECT client_id,
       name,
       (SELECT SUM(invoice_total) FROM sql_invoicing.invoices
                                  WHERE invoices.client_id = clients.client_id) AS total_sales,
       (SELECT AVG(invoice_total) FROM sql_invoicing.invoices) AS average,
       (SELECT total_sales - average) AS difference
       FROM sql_invoicing.clients) AS sales_summary
    WHERE total_sales IS NOT NULL;
