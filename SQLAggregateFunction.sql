# Aggregate Functions
USE sql_invoicing;
-- Take series of value and aggregate them to produce some meaningful values
-- MIN()
-- MAX()
-- AVG()
-- SUM()
-- COUNT()

SELECT
    MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    SUM(invoice_total * 1.1) AS sum,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(payment_date) AS number_of_payments,
    COUNT(*) AS total_records,
    COUNT(DISTINCT client_id) AS total_clients
    FROM invoices
WHERE invoice_date > '2019-07-01';
-- Exercise
SELECT 'First half of 2019' AS date_range,
       SUM(invoice_total) AS total_sales,
       SUM(payment_total) AS total_payments,
       SUM(invoice_total) - SUM(payment_total) AS what_we_except
       FROM invoices WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 'Second half of 2019' AS date_range,
       SUM(invoice_total) AS total_sales,
       SUM(payment_total) AS total_payments,
       SUM(invoice_total - payment_total) AS what_we_except
       FROM invoices WHERE invoice_date BETWEEN '2019-07-01' AND '2020-12-31'
UNION
SELECT 'Total' AS date_range,
       SUM(invoice_total) AS total_sales,
       SUM(payment_total) AS total_payments,
       SUM(invoice_total - payment_total) AS what_we_except
       FROM invoices;





# GROUP BY
SELECT
    c.name,
    SUM(i.invoice_total) as total_sales
    FROM invoices i JOIN clients c USING( client_id )
WHERE i.invoice_date >= '2019-07-01'
GROUP BY c.name
ORDER BY total_sales;
-- Multiple groups
SELECT
    c.state,
    c.city,
    SUM(i.invoice_total) as total_sales
    FROM invoices i JOIN clients c USING( client_id )
WHERE i.invoice_date >= '2019-07-01'
GROUP BY c.state, c.city
ORDER BY total_sales;
-- Exercise
SELECT
    date,
    pm.name AS payment_method,
    SUM(amount) AS total_payments
    FROM payments p JOIN payment_methods pm
        ON p.payment_method = pm.payment_method_id
GROUP BY date, pm.name
ORDER BY date, name desc;






# HAVING
-- Filter data after grouping
-- Also column need to be in SELECT clause, unlike WHERE, HAVING cannot filter columns not mentioned in SELECT clause
SELECT
    client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
    FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;
-- Exercise
SELECT c.first_name, SUM(oi.unit_price * oi.quantity) AS total_price
    FROM sql_store.customers c
         JOIN sql_store.orders o USING (customer_id)
         JOIN sql_store.order_items oi USING (order_id)
    WHERE state = 'VA'
GROUP BY c.first_name
HAVING total_price > 100;





# ROLLUP
-- For summarize
SELECT
    pm.name,
    SUM(p.amount) AS total
    FROM payments p JOIN payment_methods pm
        ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP ;

