# DML Statements - Data Manipulation Language
USE sql_store;


# INSERT Single row
INSERT INTO customers (customer_id, last_name, first_name, birth_date, phone, address, city, state, points)
    VALUES (DEFAULT, 'Nawge', 'Noopur',  '1990-03-16', NULL, 'Borivali West', 'Mumbai', 'MH', DEFAULT);
-- OR
INSERT INTO customers (last_name, first_name, birth_date, address, city, state)
    VALUES ('SN', 'Jayanth',  '1991-09-24', 'Gopala Gowda Ext', 'Shimoga', 'KA');




# INSERT Multiple rows
INSERT INTO shippers (name)
    VALUES ('VRL'),
           ('Amazon'),
           ('FedEx');
-- Exercise
INSERT INTO products (name, quantity_in_stock, unit_price)
    VALUES ('Apple Xs Max', '48', '1.3'),
           ('Apple Watch SE', '56', '0.5');




# INSERT HIERARCHICAL DATA
INSERT INTO orders (customer_id, order_date, status)
    VALUES (1, '1990-01-01', 1);
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (LAST_INSERT_ID(), 1, 1, 4.30);





# Cloning Table
-- Simple Cloning
-- Shallow Cloning
-- Deep Cloning

-- Simple cloning : Doesn't copy the schema only data
CREATE TABLE order_simple_clone SELECT * FROM orders;
-- Shallow Cloning : Doesn't copy data only schema
CREATE TABLE order_shallow_clone LIKE orders;
-- Deep Cloning : Copy both schema and data
CREATE TABLE order_deep_clone LIKE orders;
INSERT INTO order_deep_clone SELECT * FROM orders;
-- Exercise
CREATE TABLE sql_invoicing.invoices_archive AS
    SELECT i.invoice_id, i.number, c.name, i.invoice_total, i.payment_total, i.invoice_date, i.due_date, i.payment_date
        FROM sql_invoicing.invoices i JOIN sql_invoicing.clients c USING (client_id) WHERE i.payment_date IS NOT NULL;





# Updating Single Row and Multiple Rows
UPDATE sql_invoicing.invoices SET payment_total = 1, payment_date = '2019-03-01' WHERE invoice_id = 1;
-- we can also update with expression and other column
UPDATE sql_invoicing.invoices SET payment_total = invoice_total * 0.5, payment_date = due_date
    WHERE invoice_id = 3;
-- Multiple Row
UPDATE sql_invoicing.invoices SET payment_total = invoice_total * 0.5, payment_date = due_date
    WHERE invoice_id IN (7, 8);
-- Exercise
UPDATE customers SET points = points + 50 WHERE birth_date < '1990-01-01';





# SUB-QUERIES
UPDATE sql_invoicing.invoices SET payment_total = invoice_total * 0.5, payment_date = due_date
    WHERE client_id = ( SELECT client_id FROM sql_invoicing.clients WHERE name = 'Myworks' );
-- Exercise
UPDATE orders SET comments = 'GOLD Customer'
              WHERE customer_id IN (SELECT customer_id FROM customers WHERE points > 3000);




# DELETE
DELETE FROM sql_invoicing.invoices WHERE invoice_id = 19;
-- We can also use subqueries while deleting

