CREATE TABLE tbl_offices (
    office_id      CHAR(4)      NOT NULL,
    office_address VARCHAR(200) NOT NULL,
    PRIMARY KEY (office_id)
);

INSERT INTO tbl_offices (office_id, office_address) VALUES
    ('OF01', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
    ('OF02', 'Delhi Office, Connaught Place, New Delhi - 110001'),
    ('OF03', 'South Zone, MG Road, Bangalore - 560001'),
    ('OF04', 'Bangalore HQ, Rajajinagar , Karnataka - 560055'),
    ('OF05', 'Gurugram Office, Sushant Lok, Haryana - 120018');


CREATE TABLE tbl_sales_reps (
    sales_rep_id    CHAR(4)      NOT NULL,
    sales_rep_name  VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(150) NOT NULL UNIQUE,
    office_id       CHAR(4)      NOT NULL,
    PRIMARY KEY (sales_rep_id),
    FOREIGN KEY (office_id) REFERENCES tbl_offices (office_id)
);

INSERT INTO tbl_sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_id) VALUES
    ('SR01', 'Deepak Joshi', 'deepak@corp.com', 'OF01'),
    ('SR02', 'Anita Desai',  'anita@corp.com',  'OF02'),
    ('SR03', 'Ravi Kumar',   'ravi@corp.com',   'OF03'),
    ('SR04', 'Yashas Kumar', 'yashas@corp.com', 'OF04'),
    ('SR05','Vartika Singh', 'vartika@corp.com','OF05');


CREATE TABLE tbl_customers (
    customer_id    CHAR(4)      NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL UNIQUE,
    customer_city  VARCHAR(100) NOT NULL,
    PRIMARY KEY (customer_id)
);

INSERT INTO tbl_customers (customer_id, customer_name, customer_email, customer_city) VALUES
    ('C001', 'Rohan Mehta',  'rohan@gmail.com',  'Mumbai'),
    ('C002', 'Priya Sharma', 'priya@gmail.com',  'Delhi'),
    ('C003', 'Amit Verma',   'amit@gmail.com',   'Bangalore'),
    ('C004', 'Sneha Iyer',   'sneha@gmail.com',  'Chennai'),
    ('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
    ('C006', 'Neha Gupta',   'neha@gmail.com',   'Delhi'),
    ('C007', 'Arjun Nair',   'arjun@gmail.com',  'Bangalore'),
    ('C008', 'Kavya Rao',    'kavya@gmail.com',  'Hyderabad');


CREATE TABLE tbl_categories (
    category_id   SMALLINT  NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (category_id)
);

INSERT INTO tbl_categories (category_name) VALUES
    ('Electronics'),
    ('Furniture'),
    ('Stationery'),
    ('Printer'),
    ('Accessories');


CREATE TABLE tbl_products (
    product_id   CHAR(4)        NOT NULL,
    product_name VARCHAR(150)   NOT NULL,
    category_id  SMALLINT       NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    PRIMARY KEY (product_id),
    FOREIGN KEY (category_id) REFERENCES tbl_categories (category_id)
);

INSERT INTO tbl_products (product_id, product_name, category_id, unit_price) VALUES
    ('P001', 'Laptop',        1,  55000.00),
    ('P002', 'Mouse',         1,    800.00),
    ('P003', 'Desk Chair',    2,   8500.00),
    ('P004', 'Notebook',      3,    120.00),
    ('P005', 'Headphones',    1,   3200.00),
    ('P006', 'Standing Desk', 2,  22000.00),
    ('P007', 'Pen Set',       3,    250.00),
    ('P008', 'Webcam',        1,   2100.00);


CREATE TABLE tbl_orders (
    order_id     CHAR(7)  NOT NULL,
    customer_id  CHAR(4)  NOT NULL,
    product_id   CHAR(4)  NOT NULL,
    sales_rep_id CHAR(4)  NOT NULL,
    quantity     SMALLINT NOT NULL CHECK (quantity > 0),
    order_date   DATE     NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id)  REFERENCES tbl_customers  (customer_id),
    FOREIGN KEY (product_id)   REFERENCES tbl_products   (product_id),
    FOREIGN KEY (sales_rep_id) REFERENCES tbl_sales_reps (sales_rep_id)
);

INSERT INTO tbl_orders (order_id, customer_id, product_id, sales_rep_id, quantity, order_date) VALUES
    ('ORD1027', 'C002', 'P004', 'SR02', 4, '2023-11-02'),
    ('ORD1114', 'C001', 'P007', 'SR01', 2, '2023-08-06'),
    ('ORD1153', 'C006', 'P007', 'SR01', 3, '2023-02-14'),
    ('ORD1002', 'C002', 'P005', 'SR02', 1, '2023-01-17'),
    ('ORD1118', 'C006', 'P007', 'SR02', 5, '2023-11-10'),
    ('ORD1132', 'C003', 'P007', 'SR02', 5, '2023-03-07'),
    ('ORD1037', 'C002', 'P007', 'SR03', 2, '2023-03-06'),
    ('ORD1075', 'C005', 'P003', 'SR03', 3, '2023-04-18'),
    ('ORD1083', 'C006', 'P007', 'SR01', 2, '2023-07-03'),
    ('ORD1091', 'C001', 'P006', 'SR01', 3, '2023-07-24');