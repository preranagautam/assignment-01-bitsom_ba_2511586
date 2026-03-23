-- -------------------------------------------------------------
-- DIMENSION 1: dim_date
-- Separates all date-derived attributes from the fact table.
-- Enables time-based slicing (by month, quarter, year)
-- without recomputing date parts on every query.
-- -------------------------------------------------------------

CREATE TABLE dim_date (
    date_id      DATE        NOT NULL,
    day          TINYINT     NOT NULL,
    month        TINYINT     NOT NULL,
    month_name   VARCHAR(10) NOT NULL,
    quarter      TINYINT     NOT NULL,
    year         SMALLINT    NOT NULL,
    day_of_week  VARCHAR(10) NOT NULL,
    is_weekend   BOOLEAN     NOT NULL,
    PRIMARY KEY (date_id)
);

INSERT INTO dim_date (date_id, day, month, month_name, quarter, year, day_of_week, is_weekend) VALUES
    ('2023-01-15',  15, 1,  'January',   1, 2023, 'Sunday',    TRUE),
    ('2023-02-05',   5, 2,  'February',  1, 2023, 'Sunday',    TRUE),
    ('2023-02-20',  20, 2,  'February',  1, 2023, 'Monday',    FALSE),
    ('2023-03-31',  31, 3,  'March',     1, 2023, 'Friday',    FALSE),
    ('2023-04-06',   6, 4,  'April',     2, 2023, 'Thursday',  FALSE),
    ('2023-04-28',  28, 4,  'April',     2, 2023, 'Friday',    FALSE),
    ('2023-05-02',   2, 5,  'May',       2, 2023, 'Tuesday',   FALSE),
    ('2023-05-21',  21, 5,  'May',       2, 2023, 'Sunday',    TRUE),
    ('2023-08-12',  12, 8,  'August',    3, 2023, 'Saturday',  TRUE),
    ('2023-08-15',  15, 8,  'August',    3, 2023, 'Tuesday',   FALSE),
    ('2023-08-29',  29, 8,  'August',    3, 2023, 'Tuesday',   FALSE),
    ('2023-09-08',   8, 9,  'September', 3, 2023, 'Friday',    FALSE),
    ('2023-10-20',  20, 10, 'October',   4, 2023, 'Friday',    FALSE),
    ('2023-10-26',  26, 10, 'October',   4, 2023, 'Thursday',  FALSE),
    ('2023-11-18',  18, 11, 'November',  4, 2023, 'Saturday',  TRUE),
    ('2023-12-12',  12, 12, 'December',  4, 2023, 'Tuesday',   FALSE);


-- -------------------------------------------------------------
-- DIMENSION 2: dim_store
-- Separates store attributes from the fact table.
-- A store's city or name can change without touching fact_sales.
-- -------------------------------------------------------------
CREATE TABLE dim_store (
    store_id    INT          NOT NULL AUTO_INCREMENT,
    store_name  VARCHAR(100) NOT NULL,
    store_city  VARCHAR(100) NOT NULL,
    PRIMARY KEY (store_id)
);

INSERT INTO dim_store (store_id, store_name, store_city) VALUES
    (1, 'Chennai Anna',    'Chennai'),
    (2, 'Delhi South',     'Delhi'),
    (3, 'Bangalore MG',    'Bangalore'),
    (4, 'Pune FC Road',    'Pune'),
    (5, 'Mumbai Central',  'Mumbai');


-- -------------------------------------------------------------
-- DIMENSION 3: dim_product
-- Separates product attributes from the fact table.
-- Standardised category values: Electronics, Grocery, Clothing.
-- Products can be added to the catalog before any sale occurs
-- (fixes insert anomaly present in a flat table design).
-- -------------------------------------------------------------
CREATE TABLE dim_product (
    product_id   INT          NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (product_id)
);

INSERT INTO dim_product (product_id, product_name, category, unit_price) VALUES
    (1,  'Atta 10kg',   'Grocery',     52464.00),
    (2,  'Biscuits',    'Grocery',     27469.99),
    (3,  'Headphones',  'Electronics', 39854.96),
    (4,  'Jacket',      'Clothing',    30187.24),
    (5,  'Jeans',       'Clothing',     2317.47),
    (6,  'Laptop',      'Electronics', 42343.15),
    (7,  'Milk 1L',     'Grocery',     43374.39),
    (8,  'Oil 1L',      'Grocery',     43670.64),
    (9,  'Phone',       'Electronics', 48703.39),
    (10, 'Pulses 1kg',  'Grocery',     29023.67),
    (11, 'Rice 5kg',    'Grocery',     23076.99),
    (12, 'Saree',       'Clothing',    35451.81),
    (13, 'Smartwatch',  'Electronics', 58851.01),
    (14, 'Speaker',     'Electronics', 49262.78),
    (15, 'T-Shirt',     'Clothing',     8290.56),
    (16, 'Tablet',      'Electronics', 23226.12);


-- -------------------------------------------------------------
-- DIMENSION 4: dim_customer
-- Decouples customer identity from transactions.
-- Customers can be onboarded before their first purchase.
-- -------------------------------------------------------------
CREATE TABLE dim_customer (
    customer_id   VARCHAR(10) NOT NULL,
    PRIMARY KEY (customer_id)
);

INSERT INTO dim_customer (customer_id) VALUES
    ('CUST004'), ('CUST007'), ('CUST008'), ('CUST015'),
    ('CUST019'), ('CUST020'), ('CUST021'), ('CUST025'),
    ('CUST027'), ('CUST030'), ('CUST031'), ('CUST041'),
    ('CUST042'), ('CUST044'), ('CUST045');


-- -------------------------------------------------------------
-- FACT TABLE: fact_sales
-- Each row is one retail transaction.
-- Stores only numeric measures + FK references to all dims.
-- total_amount is stored (not computed) for query performance —
-- avoids repeating unit_price * units_sold on every analytic query.
-- -------------------------------------------------------------
CREATE TABLE fact_sales (
    transaction_id  VARCHAR(10)    NOT NULL,
    date_id         DATE           NOT NULL,
    store_id        INT            NOT NULL,
    product_id      INT            NOT NULL,
    customer_id     VARCHAR(10)    NOT NULL,
    units_sold      SMALLINT       NOT NULL CHECK (units_sold > 0),
    unit_price      DECIMAL(10, 2) NOT NULL,
    total_amount    DECIMAL(12, 2) NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (date_id)     REFERENCES dim_date     (date_id),
    FOREIGN KEY (store_id)    REFERENCES dim_store    (store_id),
    FOREIGN KEY (product_id)  REFERENCES dim_product  (product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer (customer_id)
);

INSERT INTO fact_sales (transaction_id, date_id, store_id, product_id, customer_id, units_sold, unit_price, total_amount) VALUES
    ('TXN5000', '2023-08-29', 1, 14, 'CUST045',  3, 49262.78,  147788.34),
    ('TXN5001', '2023-12-12', 1, 16, 'CUST021', 11, 23226.12,  255487.32),
    ('TXN5002', '2023-05-02', 1,  9, 'CUST019', 20, 48703.39,  974067.80),
    ('TXN5003', '2023-02-20', 2, 16, 'CUST007', 14, 23226.12,  325165.68),
    ('TXN5004', '2023-01-15', 1, 13, 'CUST004', 10, 58851.01,  588510.10),
    ('TXN5005', '2023-09-08', 3,  1, 'CUST027', 12, 52464.00,  629568.00),
    ('TXN5006', '2023-03-31', 4, 13, 'CUST025',  6, 58851.01,  353106.06),
    ('TXN5007', '2023-10-26', 4,  5, 'CUST041', 16,  2317.47,   37079.52),
    ('TXN5008', '2023-08-12', 3,  2, 'CUST030',  9, 27469.99,  247229.91),
    ('TXN5009', '2023-08-15', 3, 13, 'CUST020',  3, 58851.01,  176553.03),
    ('TXN5010', '2023-04-06', 1,  4, 'CUST031', 15, 30187.24,  452808.60),
    ('TXN5011', '2023-10-20', 5,  5, 'CUST045', 13,  2317.47,   30127.11),
    ('TXN5012', '2023-05-21', 3,  6, 'CUST044', 13, 42343.15,  550460.95),
    ('TXN5013', '2023-04-28', 5,  7, 'CUST015', 10, 43374.39,  433743.90),
    ('TXN5014', '2023-11-18', 2,  4, 'CUST042',  5, 30187.24,  150936.20);