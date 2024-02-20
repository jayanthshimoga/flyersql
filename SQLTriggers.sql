# Triggers and Event


# Create Trigger
DROP TRIGGER IF EXISTS payments_after_insert;
DELIMITER $$
CREATE TRIGGER payments_after_insert
    AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
    UPDATE invoices i
        SET i.payment_total = i.payment_total + NEW.amount
        WHERE i.invoice_id = NEW.invoice_id;
END$$
DELIMITER ;

INSERT INTO payments VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1);

-- Exercise

DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_delete;
CREATE TRIGGER payments_after_delete
    AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
    UPDATE invoices i
        SET i.payment_total = i.payment_total - OLD.amount
        WHERE i.invoice_id = OLD.invoice_id;
END$$
DELIMITER ;

DELETE FROM payments WHERE payment_id = 9;









SHOW TRIGGERS