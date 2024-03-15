# Northwind-DataWarehouse
- A data warehouse is designed and implemented on the **"Northwind"** database.<br /> 
- The Northwind database contains the sales data for a fictitious company called “Northwind Traders” which imports and exports specialty foods from around the world.

## Project Steps
- **Business Requirement** <br /> Nourhan
- **Data Profiling** <br />
   - Conducted in-depth data profiling of the "Northwind" database to identify data quality issues and anomalies.<br /> 
   - Documented and addressed missing values, data types, unique values, and data patterns within the dataset. <br />

   ![oltp](RESCOURCES/Northwind_ERD.jpeg)



- **Data Warehouse Design &Data Modeling**  <br />
   - Employed denormalization techniques to enhance query performance and reduce the need for complex joins.
   - Designed and implemented a dimensional modelling for efficient data warehousing.
 
     ![d1 (1)](RESCOURCES/Data-model.png)
- **Index**  <br />
   -IX_orders_order_id_Unitprice on orders_fact: This index is created on the orders_fact table with columns order_id and Unitprice. It's used to optimize queries that involve filtering, sorting, or joining based on order_id and Unitprice.


   -***country_customer_dim*** on customer_dim: This index is created on the customer_dim table using a hash index structure on the country column. It 's used to speed up queries that filter or group by country in the customer_dim table.

   -****city_customer_dim**** on customer_dim: Similar to the previous index, this one is created on the customer_dim table using a hash index structure on the city column. It 's used to optimize queries involving filtering or grouping by city in the customer_dim table.

   -***category_nameproducts_dim*** on products_dim: This index is created on the products_dim table using a hash index structure on the category_name column. It's used to speed up queries involving filtering or grouping by category_name in the products_dim table.

   -***cust_sur_orders_fact*** on orders_fact: Similar to the previous index, this one is created on the orders_fact table with the cust_sur column. It could 's to optimize queries that involve  joiningbased on cust_sur.

   -***emp_sur_orders_fact*** on orders_fact: This index is created on the orders_fact table with the emp_sur column. It 's used to optimize queries that  join based on emp_sur.

   -***shipper_sur_orders_fact*** on orders_fact: This index is created on the orders_fact table with the shipper_sur column. It 's used to optimize queries that  join based on shipper_sur.

   -***supplier_sur_orders_fact*** on orders_fact: This index is created on the orders_fact table with the supplier_sur column. It 's used to optimize queries that join based on supplier_sur.


- **ETL Data Pipelines** <br />
   - Developed ETL data pipelines using SQL Server Integration Services **(SSIS)** to automate the extraction, transformation, and loading of data from the source database (OLTP) to the data warehouse (OLAP).
   
        ![d1 (1)](RESCOURCES/CONTROL-FLOW.jpeg)


   - **Control Flow:**
               A package in SSIS consists of a control flow and, optionally, one or more data flows.
               The control flow orchestrates the execution of tasks and containers within the package.
   - **Data Flow**:
               The Data Flow task encapsulates the data flow engine in SSIS.
               When you add a Data Flow task to the package control flow, it enables the package to:
               Extract data from sources.
               Transform, clean, and modify data.
               Load data into destinations (e.g., databases, files, or other systems). 
   - Here is some samples for data flows for our dimensions loading from two different sources at following steps 
   **Data Sources**:
               Begin by adding the necessary data sources to your SSIS package. These sources could be files, relational databases, or even Analysis Services databases.
               Set up connection managers to establish connections to these sources.
   **Transformations**:
               Transformations modify, summarize, and clean data within the data flow.
               using transformations functions:
               Lookup: To enrich data by matching it with lookup tables.
               Derived Column: For creating calculated columns based on existing ones.
               Conditional Split: To route data based on conditions.
               Sort: Arrange data in a specific order.
               Integration:
               Use the Union All transformation to merge data from both sources into a single flow.
               Map the output of the Union All transformation to your destination (e.g., a SQL Server table).
        ![d1 (1)](RESCOURCES/EMPLOYEE.png)



   - The important part was loading the data into the **Fact Table** and that was done by collecting all the IDs from tables in the source database using a Merge Join transformation.
   - Then, use a Lookup transformation to get the surrogate key for each dimension and apply any necessary transformations required.
     
     ![d1 (1)](RESCOURCES/FACT-TABLE.png)


