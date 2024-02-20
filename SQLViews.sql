# VIEWS


# Creating views
CREATE VIEW client_sales AS
SELECT c.client_id,
       c.name,
       SUM(invoice_total) AS total_sales
    FROM clients c
    JOIN invoices i USING (client_id)
    GROUP BY c.client_id, c.name;
-- Exercise
CREATE VIEW clients_balance AS
SELECT c.client_id,
       c.name,
       SUM(i.invoice_total - i.payment_total) as balance
    FROM clients c
    JOIN invoices i USING (client_id)
    GROUP BY c.client_id, c.name
    ORDER BY client_id;




# Altering or Dropping Views
CREATE OR REPLACE VIEW clients_balance AS
SELECT c.client_id,
       c.name,
       SUM(i.invoice_total - i.payment_total) as balance
    FROM clients c
    JOIN invoices i USING (client_id)
    GROUP BY c.client_id, c.name
    ORDER BY client_id;




# Update Views
-- ONLY if you don't have
-- DISTINCT
-- Aggregate functions like (MIN, MAX, AVG, SUM, COUNT)
-- GROUP BY / HAVING
-- UNION





# WITH CHECK OPTION
-- prevents automatic delete of rows while updating
CREATE OR REPLACE VIEW client_info AS
SELECT c.client_id,
       c.name,
       i.invoice_total - i.payment_total AS balance
    FROM clients c
    JOIN invoices i USING (client_id)
    ORDER BY client_id
WITH CHECK OPTION ;


# RANK
-- RANK() OVER (
--    PARTITION BY <expression>[{,<expression>...}]
--    ORDER BY <expression> [ASC|DESC], [{,<expression>...}]
-- )

# CREATE TABLE IF NOT EXISTS sales(
#     sales_employee VARCHAR(50) NOT NULL,
#     fiscal_year INT NOT NULL,
#     sale DECIMAL(14,2) NOT NULL,
#     PRIMARY KEY(sales_employee,fiscal_year)
# );
#
# INSERT INTO sales(sales_employee,fiscal_year,sale)
# VALUES('Bob',2016,100),
#       ('Bob',2017,150),
#       ('Bob',2018,200),
#       ('Alice',2016,150),
#       ('Alice',2017,100),
#       ('Alice',2018,200),
#        ('John',2016,200),
#       ('John',2017,150),
#       ('John',2018,250);
#
# SELECT * FROM sales;

SELECT
    sales_employee,
    fiscal_year,
    sale,
    RANK() OVER (PARTITION BY
                     fiscal_year
                 ORDER BY
                     sale DESC
                ) sales_rank
FROM
    sales;


# LAG and LEAD

# Create table If Not Exists Logs (id int, num int)
# Truncate table Logs
# insert into Logs (id, num) values ('1', '1')
# insert into Logs (id, num) values ('2', '1')
# insert into Logs (id, num) values ('3', '1')
# insert into Logs (id, num) values ('4', '2')
# insert into Logs (id, num) values ('5', '2')
# insert into Logs (id, num) values ('6', '2')
# insert into Logs (id, num) values ('7', '2')

with cte as
(select id, num,
    lag(num,1) over (order by id) as lagnum,
    lead(num,1) over(order by id) as leadnum
    from Logs
)
select distinct num as ConsecutiveNums from cte
    where num=lagnum and num=leadnum and leadnum=lagnum

