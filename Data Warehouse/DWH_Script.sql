CREATE TABLE date_dim (
  date_key SERIAL  PRIMARY KEY,
  full_date DATE,
  year INT,
  quarter INT,
  quarter_name VARCHAR(20),
  month INT,
  month_name VARCHAR(20),
  week INT,
  day INT,
  day_name VARCHAR(9)
);

DO $$
DECLARE 
    StartDate DATE := '1996-01-01';
    EndDate DATE := '2006-12-31';
    DateKey INT;
BEGIN
    WHILE StartDate <= EndDate LOOP
        DateKey := CAST(EXTRACT(YEAR FROM StartDate) * 10000 + EXTRACT(MONTH FROM StartDate) * 100 + EXTRACT(DAY FROM StartDate) AS INT);

        INSERT INTO date_dim (date_key, full_date, year, quarter, quarter_name, month, month_name, week, day, day_name)
        VALUES (
            DateKey,
            StartDate,
            EXTRACT(YEAR FROM StartDate),
            EXTRACT(QUARTER FROM StartDate),
            'Q' || EXTRACT(QUARTER FROM StartDate),
            EXTRACT(MONTH FROM StartDate),
            TO_CHAR(StartDate, 'Month'),
            EXTRACT(WEEK FROM StartDate),
            EXTRACT(DAY FROM StartDate),
            TO_CHAR(StartDate, 'Day')
        );

        StartDate := StartDate + INTERVAL '1 day';
    END LOOP;
END $$;

CREATE TABLE customer_dim (
  cust_sur SERIAL PRIMARY KEY,
  Customer_id VARCHAR(10),
  Company_name VARCHAR(40),
  Contactname VARCHAR(30),
  Contact_title VARCHAR(30),
  Address VARCHAR(60),
  City VARCHAR(15),
  Region VARCHAR(15),
  Country VARCHAR(15)
);

CREATE TABLE employees_dim (
  Emp_Sur SERIAL PRIMARY KEY, 
  Emp_id INT,
  First_name VARCHAR(15),
  Last_name VARCHAR(15),
  Title VARCHAR(30),
  Birth_date DATE,
  Hire_Date DATE,
  City VARCHAR(30),
  Region VARCHAR(30),
  Country VARCHAR(30),
  Mgr_id INT
);

CREATE TABLE Suppliers_dim (
  Supplier_sur SERIAL  PRIMARY KEY,
  Supplier_id INT,
  company_name VARCHAR(100),
  city VARCHAR(100),
  region VARCHAR(100),
  country VARCHAR(100)
);

CREATE TABLE Products_dim (
  Prod_sur SERIAL  PRIMARY KEY,
  Prod_id INT,
  Prod_name VARCHAR(100),
  Supplier_id INT,
  Category_name VARCHAR(100),
  quantity_per_unit VARCHAR(30),
  Unitprice Float,
  Units_on_stock INT,
  reorder_level INT,
  Discountinued Boolean ,
  CONSTRAINT FK_Product_supplier_id
   FOREIGN KEY (Supplier_id)
   REFERENCES Suppliers_dim(Supplier_sur)
);


CREATE TABLE CH_PRICE_dim (
   price_sur  SERIAL  PRIMARY KEY,
   Prod_sur INT,
   unit_price FLOAT,
   price_date int,
   CONSTRAINT FK_ch_price_Product_id
     FOREIGN KEY (Prod_sur)
     REFERENCES Products_dim(Prod_sur),
   CONSTRAINT FK_CH_PRICE_price_date
    FOREIGN KEY (price_date)
    REFERENCES date_dim(date_key)
);
CREATE TABLE shipper_dim (
  
  Shipper_sur SERIAL  PRIMARY KEY ,
  Shipper_id INT,
  Shipper_name VARCHAR(40)
);

CREATE TABLE orders_fact (
  Order_id INT,
  Product_sur INT,
  cust_sur INT,
  Emp_sur INT,
  shipper_sur INT ,
  Supplier_sur INT,
  Unitprice float ,
  quantity INT,
  Discount float,
  Order_date INT,
  required_date INT,
  Shipped_date INT,
  freight float,
 
  CONSTRAINT PK_orders_fact PRIMARY KEY (Order_Id, Product_sur),
  CONSTRAINT FK_orders_cust_sur
    FOREIGN KEY (cust_sur)
    REFERENCES customer_dim(cust_sur),
  CONSTRAINT FK_orders_Product_id
    FOREIGN KEY (Product_sur)
    REFERENCES Products_dim(Prod_sur),
  CONSTRAINT FK_orders_Emp_sur
    FOREIGN KEY (Emp_sur)
    REFERENCES employees_dim(Emp_Sur),
  CONSTRAINT FK_orders_shipper_sur
    FOREIGN KEY (shipper_sur)
    REFERENCES shipper_dim(Shipper_sur),
  CONSTRAINT FK_orders_Shipped_date
    FOREIGN KEY (Shipped_date)
    REFERENCES date_dim(date_key),
  CONSTRAINT FK_Product_supplier_id
   FOREIGN KEY (Supplier_sur)
    REFERENCES Suppliers_dim(Supplier_sur),
  CONSTRAINT FK_orders_Order_date
    FOREIGN KEY (Order_date)
    REFERENCES date_dim(date_key),
  CONSTRAINT FK_orders_required_date
    FOREIGN KEY (required_date)
    REFERENCES date_dim(date_key)
);


CREATE MATERIALIZED VIEW sales_products_join_index AS
SELECT P.Category_name, (SUM(O.quantity) * SUM(O.Unitprice)) AS total_sales
FROM orders_fact O
JOIN Products_dim P ON O.Product_sur = P.Prod_sur
GROUP BY P.Category_name;

CREATE INDEX idx_sales_products_category ON sales_products_join_index (Category_name);


CREATE INDEX IX_orders_Product_id_Unitprice ON orders_fact (Product_sur, Unitprice);

/*
-------------------------------------------------------
The indexes :
--------------

--1 
CREATE INDEX c_counrty_bitmap ON Customer USING BRIN (Country);   ###
----------------------------------
CREATE INDEX e_counrty_bitmap ON "Employee" USING BRIN ("Country");  ###
---------------------------------- 
CREATE INDEX o_shipCounrty_bitmap ON "Order_details" USING BRIN ("ShipCountry");   ####
-----------------------------------
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX e_country_gin ON "Employee" USING gin("Country" gin_trgm_ops);
------------------------------------
CREATE INDEX c_country_gin ON "customer" USING gin("country" gin_trgm_ops);
----------------------------------
CREATE INDEX o_shipCounrty_gin ON "Order_details" USING gin("ShipCountry" gin_trgm_ops);
-----------------------------------
CREATE INDEX product_join_index ON "Order_details" USING HASH
(
   "Prod_sur"
)
;

------------------------------------------------
CREATE INDEX supplier_join_index ON "Order_details" USING HASH
(
   "sup_sur"
)
;

--------------------------------------
CREATE INDEX customer_join_index ON "Order_details" USING HASH
(
   "cust_sur"
)
;
-------------------------------------
CREATE INDEX emolpyee_join_index ON "Order_details" USING HASH
(
   "Emp_sur"
)
;
-------------------------------------
CREATE INDEX OrderDate_join_index ON "Order_details" USING HASH
(
   "Order_date"
)
;

----------------------------------
CREATE INDEX requiredDate_join_index ON "Order_details" USING HASH
(
   "required_date"
)
;

----------------------------------
CREATE INDEX shippedDate_join_index ON "Order_details" USING HASH
(
   "Shipped_date"
)
;*/
