-- restaurant database

-- 5 tables
-- write 3-5 queries
-- 1x WITH
-- 1x SUBQUERY

.open restaurant.db

/* DROP TABLE menus;

-- TABLE 1: Menus
CREATE TABLE menus (
menu_id INT UNIQUE,
menu_name TEXT,
menu_price INT
);

INSERT INTO menus VALUES 
  (1, 'Pizza', 200),
  (2, 'Hotdog', 100),
  (3, 'Burger', 150),
  (4, 'Coke', 30),
  (5, 'Water', 15);

-- Table 2: customers
DROP TABLE customers;
CREATE TABLE customers (
  customer_id INT UNIQUE,
  customer_name TEXT,
  country TEXT,
  membership_id INT
);

INSERT INTO customers VALUES 
  (1, 'Alex', 'Belgium', 2),
  (2, 'Michael', 'USA', 3),
  (3, 'Andrey', 'Ukraine', 2),
  (4, 'Golf', 'Thailand', 1),
  (5, 'Hoan', 'Korea', 1);

-- Table 3: employees
CREATE TABLE employees (
  employee_id INT UNIQUE,
  employee_name TEXT
);

INSERT INTO employees VALUES 
  (1, 'A.T.'),
  (2, 'Peace');

-- Table 4: invoices
CREATE TABLE invoices (
  invoice_id INT UNIQUE,
  customer_id INT,
  invoice_date TEXT,
  employee_id INT
); */

/* INSERT INTO invoices VALUES 
  --(1, 3, '2023-01-21', 1),
  --(2, 2, '2022-02-22', 2),
  --(3, 1, '2023-04-23', 1);
  (4, 2, '2023-01-30', 2);
  
-- Table 5: order_items
CREATE TABLE order_items (
  order_item_id INT UNIQUE,
  invoice_id INT,
  menu_id INT
); */

/* INSERT INTO order_items VALUES 
  (1, 1, 1),
  (2, 1, 2),
  (3, 1, 4),
  (4, 2, 2),
  (5, 2, 5),
  (6, 3, 3),
  (7, 3, 4);
  (8, 4, 1),
  (9, 4, 2),
  (10, 4, 3),
  (11, 4, 4),
  (12, 4, 5); 
  (13, 4, 5); */

/* -- Table 6: memberships
DROP TABLE memberships;
  
CREATE TABLE memberships (
  membership_id INT UNIQUE,
  membership_class TEXT,
  membership_discount REAL
);

INSERT INTO memberships VALUES 
  (1, 'Non Member', 0.0),
  (2, 'Red Member', 15.0),
  (3, 'Black Member', 30.0); */

.mode box
.header on
.print ""
.print "Table: Menus"
SELECT * FROM menus;
.print ""
.print "Table: Customers"
SELECT * FROM customers;
.print ""
.print "Table: Employess"
SELECT * FROM employees;
.print ""
.print "Table: Invoices"
SELECT * FROM invoices;
.print ""
.print "Table: Order Items"
SELECT * FROM order_items;
.print ""
.print "Table: Memberships"
SELECT * FROM memberships;

-- SQL 1: Show customers and their items order
.print ""
.print "--- Show customers and their items order ---"
SELECT
cm.customer_name AS name,
mn.menu_name     AS 'order',
mn.menu_price    AS price,
iv.invoice_date  AS date
FROM order_items AS oi
JOIN menus       AS mn ON mn.menu_id = oi.menu_id
JOIN invoices    AS iv ON iv.invoice_id = oi.invoice_id
JOIN customers   AS cm ON iv.customer_id = cm.customer_id
JOIN memberships AS ms ON cm.membership_id = ms.membership_id;

-- SQL 2: Sum price for each customers after discount order by most spend (Use Subqueries)
.print ""
.print "--- Sum price for each customers after discount order by most spend ---"
SELECT
  customer_name            AS name,
  SUM(menu_price)          AS price_before,
  membership_class,
  SUM(menu_price_discount) AS price_after
FROM (
  SELECT
  cm.customer_name,
  mn.menu_name,
  mn.menu_price,
  ms.membership_class,
  mn.menu_price*(1-(ms.membership_discount/100)) AS 'menu_price_discount'
  FROM order_items AS oi
  JOIN menus       AS mn ON mn.menu_id = oi.menu_id
  JOIN invoices    AS iv ON iv.invoice_id = oi.invoice_id
  JOIN customers   AS cm ON iv.customer_id = cm.customer_id
  JOIN memberships AS ms ON cm.membership_id = ms.membership_id
  )
GROUP BY customer_name
ORDER BY price_after DESC;

-- SQL 3: Show customer name and their details from lastest coming (Use WITH)
.print ""
.print "--- Show customer name and their details from lastest coming ---"
WITH summary AS (SELECT
  *
  FROM order_items AS oi
  JOIN menus       AS mn ON mn.menu_id = oi.menu_id
  JOIN invoices    AS iv ON iv.invoice_id = oi.invoice_id
  JOIN customers   AS cm ON iv.customer_id = cm.customer_id
  JOIN employees   AS ey ON iv.employee_id = ey.employee_id
  JOIN memberships AS ms ON cm.membership_id = ms.membership_id
  ORDER BY iv.invoice_date DESC
  )

SELECT
  customer_name                                 AS name,
  membership_class,
  SUM(menu_price*(1-(membership_discount/100))) AS total_price,
  CASE WHEN (employee_name = 'A.T.') THEN 'Welcome by A.T.'
  ELSE 'Welcome by Peace'
  END                                           AS Details,
  STRFTIME("%Y%m",invoice_date)                 AS date_ym
FROM summary
-- WHERE date_ym > '202202'
GROUP BY name || date_ym
-- HAVING date_ym > '202202'
ORDER BY date_ym DESC;

-- SQL 4: Show customer name and how many times they came
.print ""
.print "--- Show customer name and how many times they came ---"
SELECT
customer_name    AS name,
membership_class AS class,
CASE WHEN (COUNT(invoice_id)>0) THEN COUNT(invoice_id)
     ELSE 0
     END         AS 'visit'
FROM customers AS cm, memberships AS ms
LEFT JOIN invoices iv ON cm.customer_id = iv.customer_id
WHERE cm.membership_id = ms.membership_id
GROUP BY name
ORDER BY visit DESC, cm.membership_id DESC;

-- SQL 5: Sum sales for each product and price after discount by membership (Show min, max)
.print ""
.print "--- Sum sales for each product and price after discount by membership (Include MIN, MAX) ---"
WITH sumsales AS (
  SELECT
  *
  FROM
    order_items oi,
    invoices iv,
    menus mn,
    customers cm,
    memberships ms
  WHERE oi.invoice_id = iv.invoice_id
  AND oi.menu_id = mn.menu_id
  AND iv.customer_id = cm.customer_id
  AND cm.membership_id = ms.membership_id
)
  , sumsales_each AS (
  SELECT
    menu_name,
    membership_class,
    SUM(menu_price) og_price,
    SUM(menu_price*(1-(membership_discount/100))) discount_price 
  FROM sumsales
  GROUP BY menu_name, membership_class
)
  
SELECT
  menu_name,
  membership_class,
  discount_price,
  CASE WHEN discount_price = (SELECT MIN(discount_price) FROM sumsales_each WHERE membership_class LIKE 'B%') THEN 'Min Income Menu From Black Member'
       WHEN discount_price = (SELECT MAX(discount_price) FROM sumsales_each WHERE membership_class LIKE 'B%') THEN 'Max Income Menu From Black Member'
       WHEN discount_price = (SELECT MIN(discount_price) FROM sumsales_each WHERE membership_class LIKE 'R%') THEN 'Min Income Menu From Red Member'
       WHEN discount_price = (SELECT MAX(discount_price) FROM sumsales_each WHERE membership_class LIKE 'R%') THEN 'Max Income Menu From Red Member'
       ELSE '---'
       END 'Conclusion'
FROM sumsales_each
ORDER BY discount_price DESC;

/* WHERE discount_price = (SELECT MAX(discount_price) FROM sumsales_each) or
      discount_price = (SELECT MIN(discount_price) FROM sumsales_each) */
  ;

/* for check
  SELECT
  customer_name name,
  invoice_id,
  menu_name order_product,
  menu_price price,
  membership_class,
  membership_discount discount_percent,
  menu_price*(1-(membership_discount/100.0)) new_price
FROM sumsales; */
