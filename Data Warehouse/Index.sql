CREATE INDEX IX_orders_order_id_Unitprice ON orders_fact (order_id, Unitprice);

CREATE INDEX country_customer_dim ON customer_dim USING HASH (country);

CREATE INDEX city_customer_dim ON customer_dim USING HASH (city);

CREATE INDEX category_nameproducts_dim ON products_dim USING HASH (category_name);

CREATE INDEX product_sur_orders_fact ON orders_fact (product_sur);

CREATE INDEX cust_sur_orders_fact ON orders_fact (cust_sur);

CREATE INDEX emp_sur_orders_fact ON orders_fact (emp_sur);

CREATE INDEX shipper_sur_orders_fact ON orders_fact (shipper_sur);

CREATE INDEX supplier_sur_orders_fact ON orders_fact (supplier_sur);