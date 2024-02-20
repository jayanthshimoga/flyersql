# Stored procedure

-- Store and Organize SQL
-- Faster Execution
-- Data Security

# Create Procedure
DELIMITER $$
CREATE PROCEDURE get_client()
BEGIN
    SELECT * FROM sql_invoicing.clients;
END$$
DELIMITER ;

CALL sql_invoicing.get_client();

-- Exercise
DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
    SELECT * FROM sql_invoicing.invoices WHERE invoice_total - invoices.payment_total > 0;
END$$
DELIMITER ;
CALL sql_invoicing.get_invoices_with_balance();









# Create Procedure with Parameter
USE sql_invoicing;
DROP PROCEDURE IF EXISTS get_client_by_state;

DELIMITER $$
CREATE PROCEDURE get_client_by_state(
    state CHAR(2)
)
BEGIN
    SELECT * FROM clients c WHERE c.state = state;
END $$
DELIMITER ;

CALL get_client_by_state('CA');
-- Exercise

DROP PROCEDURE IF EXISTS get_invoices_by_client;

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client(
    client_id INT
)
BEGIN
    SELECT * FROM invoices i WHERE i.client_id = client_id;
END $$
DELIMITER ;

CALL get_invoices_by_client(3);









# Create Procedure with Default Value
DROP PROCEDURE IF EXISTS get_invoices_by_client_default;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client_default(
    client_id INT
)
BEGIN
    SELECT * FROM invoices i WHERE i.client_id = IFNULL(client_id, i.client_id);
END $$
DELIMITER ;
#OR
DROP PROCEDURE IF EXISTS get_invoices_by_client_default;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client_default(
    client_id INT
)
BEGIN
    IF client_id IS NULL
    THEN
        SET client_id = 1;
    END IF;
    SELECT * FROM invoices i WHERE i.client_id = client_id;
END$$
DELIMITER ;
call get_invoices_by_client_default(NULL);
-- Exercise

DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments(
    client_id INT,
    payment_method_id TINYINT
)
BEGIN
    SELECT * FROM payments p WHERE p.client_id = IFNULL(client_id, p.client_id)
                               AND p.payment_method = IFNULL(payment_method_id, p.payment_method);
END$$
DELIMITER ;
CALL get_payments(NULL, NULL);









# Create procedure with PARAMETER VALIDATION
DELIMITER $$
CREATE PROCEDURE make_payment(
    invoice_ids INT,
    payment_amount DECIMAL(9,2),
    payment_dates DATE
)
BEGIN
    UPDATE invoices i
    SET i.payment_total = payment_amount, i.payment_date = payment_dates
    WHERE i.invoice_id = invoice_ids;
END$$
DELIMITER ;
CALL make_payment(1, -100, '2023-01-01');

# FIXING
DROP PROCEDURE IF EXISTS make_payment;
DELIMITER $$
CREATE PROCEDURE make_payment(
    invoice_ids INT,
    payment_amount DECIMAL(9,2),
    payment_dates DATE
)
BEGIN
    IF payment_amount <= 0
    THEN
        SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid Amount payment';
    END IF;

    UPDATE invoices i
    SET i.payment_total = payment_amount, i.payment_date = payment_dates
    WHERE i.invoice_id = invoice_ids;
END$$
DELIMITER ;
CALL make_payment(1, 200, '2023-01-01');










# Stored Procedure with Output Parameter
-- OUTPUT parameter stores in memory until Session of Client ends
DROP PROCEDURE IF EXISTS get_unpaid_client_detail;
DELIMITER $$
CREATE PROCEDURE get_unpaid_client_detail(
    client_id INT,
    OUT invoice_count TINYINT,
    OUT total_invoice DOUBLE(9, 2)
)
BEGIN
    SELECT count(*), SUM(i.invoice_total)
    INTO invoice_count, total_invoice
    FROM invoices i
        WHERE i.client_id = client_id AND i.payment_total = 0;
END$$
DELIMITER ;

SET @invoice_count = 0;
SET @total_invoice = 0;
CALL get_unpaid_client_detail(1, @invoice_count, @total_invoice);
SELECT @invoice_count, @total_invoice;









# Create Procedure with Local Variable
DROP PROCEDURE IF EXISTS  get_risk_factor;
DELIMITER $$
CREATE PROCEDURE get_risk_factor()
BEGIN
    DECLARE invoice_count INT DEFAULT 0;
    DECLARE total_invoice DECIMAL(9, 2);
    DECLARE risk_factor DECIMAL(9, 2);

    SELECT count(*), SUM(i.invoice_total)
    INTO invoice_count, total_invoice
    FROM invoices i;

    SET risk_factor = total_invoice / invoice_count * 5;

    SELECT risk_factor;
END$$
DELIMITER ;
CALL get_risk_factor();









# FUNCTIONS
DROP FUNCTION IF EXISTS get_risk_factor_for_client;
CREATE FUNCTION get_risk_factor_for_client(
    client_id INT
)
RETURNS INTEGER
    READS SQL DATA
BEGIN
    DECLARE invoice_count INT DEFAULT 0;
    DECLARE total_invoice DECIMAL(9, 2);
    DECLARE risk_factor DECIMAL(9, 2);

    SELECT count(*), SUM(i.invoice_total)
    INTO invoice_count, total_invoice
    FROM invoices i WHERE i.client_id = client_id;

    SET risk_factor = total_invoice / invoice_count * 5;

    RETURN risk_factor;
END;

SELECT client_id, name, get_risk_factor_for_client(client_id) as client_risk_factor FROM clients;