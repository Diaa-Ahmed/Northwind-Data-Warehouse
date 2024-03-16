# README

# Northwind-DataWarehouse

- A data warehouse is designed and implemented on the
**“Northwind”** database.
- The Northwind database contains the sales data for a fictitious
company called “Northwind Traders” which imports and exports specialty
foods from around the world.

# Project Steps
    
- **Data Profiling**
    - Conducted in-depth data profiling of the “Northwind” database to
    identify data quality issues and anomalies.
    - Documented and addressed missing values, data types, unique values,
    and data patterns within the dataset.
    

    ![oltp](RESCOURCES/Northwind_ERD.jpeg)

        Noting that The dataset contains the following:

    - **Suppliers:** Suppliers and vendors of Northwind
    - **Customers:** Customers who buy products from Northwind
    - **Employees:** Employee details of Northwind traders
    - **Products:** Product information
    - **Shippers:** The details of the shippers who ship the products from the traders to the end-customers
    - **Orders** and **Order_Details:** Sales Order transactions taking place between the customers & the company
  
  # **Data Warehouse Design & Data Modeling**
    - Employed denormalization techniques to enhance query performance
    and reduce the need for complex joins.
    - Designed and implemented a dimensional modelling for efficient
    data warehousing.
        
        ![oldp](RESCOURCES/Data-Model.png)
    - In this model we have 7 dimensions and 1 fact tables which keep
    track of the orders sales in our business.
    - Dimensions are (Customer_dim, shipper_dim, ch_price_dim, date_dim,
    employees_dim, products_dim, suppliers_dim)
    
    ```sql
            - Customer_dim: Contains data about the customers name, location and country.
                - cust_sur SERIAL PRIMARY KEY
                - Customer_id VARCHAR
                - Company_name VARCHAR
                - Contactname VARCHAR
                - Contact_title VARCHAR
                - Address VARCHAR
                - City VARCHAR
                - Region VARCHAR
                - Country VARCHAR
            
            ---------------------------------------------------------------
            
            - Shipper_dim: contains information about the shippers companies.
                - Shipper_sur SERIAL (PRIMARY KEY)
                - Shipper_id INT
                - Shipper_name VARCHAR
            
            ---------------------------------------------------------------
            
            - ch_price_dim: dimension which keeps track of the products price
    	        changes.
                - price_sur SERIAL (PRIMARY KEY)
                - Prod_sur INT (Foreign key-> Products_dim)
                - unit_price FLOAT
                - price_date int (Foreign key-> date_dim)
            
            ---------------------------------------------------------------
            
            - date_dim: dimension stores all the dates and its information with a
    	        unique surrogent key for each date.
                - date_key SERIAL (PRIMARY KEY)
                - full_date DATE
                - year INT
                - quarter INT
                - quarter_name VARCHAR
                - month INT
                - month_name VARCHAR
                - week INT
                - day INT
                - day_name VARCHAR
            
            ---------------------------------------------------------------
            
            - employees_dim: dimension stores information about employees names,
    		      job role, date of birth, hire date, location and manager.
                - Emp_Sur SERIAL PRIMARY KEY
                - Emp_id INT
                - First_name VARCHAR
                - Last_name VARCHAR
                - Title VARCHAR
                - Birth_date DATE
                - Hire_Date DATE
                - City VARCHA
                - Region VARCHAR
                - Country VARCHAR
                - Mgr_id INT
            
            ---------------------------------------------------------------
            
            - products_dim: dimension stores information about each product, its
    	        price and category.
                - Prod_sur SERIAL (PRIMARY KEY)
                - Prod_id INT
                - Prod_name VARCHAR
                - Supplier_id INT (Foreign key -> suppliers_dim)
                - Category_name VARCHAR
                - quantity_per_unit VARCHAR
                - Unitprice Float
                - Units_on_stock INT
                - reorder_level INT
                - Discountinued Boolean
            
            ---------------------------------------------------------------
            
            - suppliers_dim: dimension stores information about each supplier,
    	        hist city, region, country and company name.
                - Supplier_sur SERIAL (PRIMARY KEY)
                - Supplier_id INT
                - company_name VARCHAR
                - city VARCHAR
                - region VARCHAR
                - country VARCHAR
            
            ---------------------------------------------------------------
            
        - Fact is (orders_fact). Orders_fact: fact table contains foreign keys
    	    from all the previous dimensions and also contains information about
    	    each product in the orders like unit price, discount, quantity and
    	    freight cost.
            - Order_id INT
            - Product_sur INT (Foreign key -> products_dim)
            - cust_sur INT (Foreign key -> customer_dim)
            - Emp_sur INT (Foreign key -> employees_dim)
            - shipper_sur INT (Foreign key -> Shipper_dim)
            - Supplier_sur INT (Foreign key -> suppliers_dim)
            - Unitprice float
            - quantity INT
            - Discount float
            - Order_date INT (Foreign key -> date_dim)
            - required_date INT (Foreign key -> date_dim)
            - Shipped_date INT (Foreign key -> date_dim)
            - freight float
    ```
        
- # **Index**
    
    -IX_orders_order_id_Unitprice on
    orders_fact: This index is created on the orders_fact table with columns
    order_id and Unitprice. It’s used to optimize queries that involve
    filtering, sorting, or joining based on order_id and Unitprice.
    
    - ***country_customer_dim*** on customer_dim: This
    index is created on the customer_dim table using a hash index structure
    on the country column. It ’s used to speed up queries that filter or
    group by country in the customer_dim table.
    - ****city_customer_dim**** on customer_dim: Similar to the previous
    index, this one is created on the customer_dim table using a hash index
    structure on the city column. It ’s used to optimize queries involving
    filtering or grouping by city in the customer_dim table.
    - ***category_nameproducts_dim*** on products_dim:
    This index is created on the products_dim table using a hash index
    structure on the category_name column. It’s used to speed up queries
    involving filtering or grouping by category_name in the products_dim
    table.
    - ***cust_sur_orders_fact*** on orders_fact:
    Similar to the previous index, this one is created on the orders_fact
    table with the cust_sur column. It could ’s to optimize queries that
    involve joiningbased on cust_sur.
    - ***emp_sur_orders_fact*** on orders_fact: This
    index is created on the orders_fact table with the emp_sur column. It ’s
    used to optimize queries that join based on emp_sur.
    - ***shipper_sur_orders_fact*** on orders_fact:
    This index is created on the orders_fact table with the shipper_sur
    column. It ’s used to optimize queries that join based on
    shipper_sur.
    - ***supplier_sur_orders_fact*** on orders_fact:
    This index is created on the orders_fact table with the supplier_sur
    column. It ’s used to optimize queries that join based on
    supplier_sur.
- # **ETL Data Pipelines**
    - Developed ETL data pipelines using SQL Server Integration
    Services **(SSIS)** to automate the extraction,
    transformation, and loading of data from the source database (OLTP) to
    the data warehouse (OLAP).
        
        ![Control Flow](RESCOURCES/CONTROL-FLOW.jpeg)
        
    - **Control Flow:** A package in SSIS consists of a
    control flow and, optionally, one or more data flows. The control flow
    orchestrates the execution of tasks and containers within the
    package.
    - **Data Flow**: The Data Flow task encapsulates the
    data flow engine in SSIS. When you add a Data Flow task to the package
    control flow, it enables the package to: Extract data from sources.
    Transform, clean, and modify data. Load data into destinations (e.g.,
    databases, files, or other systems).

    - Here is some samples for data flows for our dimensions loading
    from two different sources at following steps **Data
    Sources**: Begin by adding the necessary data sources to your
    SSIS package. These sources could be files, relational databases, or
    even Analysis Services databases. Set up connection managers to
    establish connections to these sources.
    **Transformations**: Transformations modify, summarize, and
    clean data within the data flow. using transformations functions:
    Lookup: To enrich data by matching it with lookup tables. Derived
    Column: For creating calculated columns based on existing ones.
    Conditional Split: To route data based on conditions. Sort: Arrange data
    in a specific order. Integration: Use the Union All transformation to
    merge data from both sources into a single flow. Map the output of the
    Union All transformation to your destination (e.g., a SQL Server table).
<br><br>
        
        ![Employee](RESCOURCES/EMPLOYEE.png)
        

    - The important part was loading the data into the **Fact
    Table** and that was done by collecting all the IDs from tables
    in the source database using a Merge Join transformation.
    - Then, use a Lookup transformation to get the surrogate key for
    each dimension and apply any necessary transformations required.
        
        ![Fact Table](RESCOURCES/FACT-TABLE.png)
        

# **The Analytical Queries**

**Q1 : Who are the top and bottom performing sales employees in each
country based on their total sales?**

    Business Need

This data can help in identifying high performers who may deserve
recognition or additional incentives, as well as employees who may need
further support or training , and identifying top and bottom performers
provides benchmarks for setting realistic sales targets and goals for
employees in each country.

And from another aspect that can be a strong base for analyzing sales
performance by country allows businesses to allocate resources such as
marketing budgets, sales support, and inventory strategically.
High-performing countries may warrant increased investment to further
capitalize on opportunities, while underperforming regions may require
additional support or adjustments to improve results.

**Q2 : Who is the supplier whose products represent the highest and
lowest sales, and what are their respective sales figures?**

    Business Need

Analyzing supplier sales performance is essential for optimizing
sourcing strategies, managing costs, mitigating risks, and fostering
mutually beneficial relationships with suppliers , through Knowing which
suppliers generate the highest and lowest sales enables businesses to
make informed strategic sourcing decisions. They can prioritize
relationships with top-performing suppliers, potentially negotiating
better terms, volume discounts, or other favorable arrangements.
Conversely, businesses can reevaluate or renegotiate contracts with
underperforming suppliers or explore alternative sourcing options to
mitigate risks and ensure continuity of supply.

**Q3 : How can we categorize our customers based on their purchasing
behavior ?**

    Business Need

The categories derived from this query, such as “At Risk”, “Customers
Needing Attention”, “Promising”, “Potential Loyalists”, and “Loyal
Customers”, reflect different stages of the customer lifecycle and
provide a framework for understanding and addressing the needs of each
customer group effectively.

The categorized groups can help prioritize resources, identify
opportunities for upselling or cross-selling, and implement targeted
marketing or service strategies.

**Q4 : How does the monthly sales performance change over time, and
what is the growth rate of sales from one month to the next?**

    Business Need

Monthly sales data allows businesses to identify seasonal variations
in demand for their products or services. Recognizing these patterns
enables companies to adjust their marketing strategies, inventory
levels, and staffing accordingly to capitalize on peak periods and
mitigate lulls in sales.

**Q5 : How do the total sales for each month distribute across three
10-day periods within that month?**

    Business Need

Knowing when sales tend to peak or dip throughout the month enables
businesses to manage their inventory levels more efficiently.

Analyzing sales distribution can inform marketing strategies and
promotional campaigns. Businesses can tailor their marketing efforts to
target specific periods within the month when sales are typically higher
or lower. For instance, they may focus on running promotions or
launching new product releases during periods of lower sales to
stimulate demand.

**Q6 : What are the top-selling products based on their category?**

    Business Need

By analyzing sales data by category, businesses can gain insights
into which product categories are the most popular and generate the
highest revenue. This information allows them to understand customer
preferences and purchasing behavior within different product
categories.
