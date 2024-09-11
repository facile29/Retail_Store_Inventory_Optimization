create database inventory;
use inventory;

select* from inventory;
select * from product;
select * from sales;
select * from store;
select* from supplier;

ALTER TABLE inventory
ADD COLUMN temp_date DATE;
UPDATE inventory
SET temp_date = STR_TO_DATE(last_restock_date, '%m-%d-%Y');
ALTER TABLE inventory DROP COLUMN last_restock_date;
ALTER TABLE inventory CHANGE COLUMN temp_date last_restock_date date;

ALTER TABLE sales
ADD COLUMN sale_date DATE;
UPDATE sales
SET sale_date = STR_TO_DATE(date, '%m-%d-%Y');
ALTER TABLE sales DROP COLUMN date;


set sql_safe_updates= 0;

ALTER TABLE Sales
ADD CONSTRAINT pk_sales PRIMARY KEY (sale_id);
ALTER TABLE Product
ADD CONSTRAINT pk_product PRIMARY KEY (product_id);
ALTER TABLE Inventory
ADD CONSTRAINT pk_inventory PRIMARY KEY (inventory_id);
ALTER TABLE Supplier
ADD CONSTRAINT pk_supplier PRIMARY KEY (supplier_id);
ALTER TABLE Store
ADD CONSTRAINT pk_store PRIMARY KEY (store_id);


ALTER TABLE Sales
ADD CONSTRAINT fk_product_sales
FOREIGN KEY (product_id) REFERENCES Product(product_id),
ADD CONSTRAINT fk_store_sales
FOREIGN KEY (store_id) REFERENCES Store(store_id);

ALTER TABLE Product
ADD CONSTRAINT fk_supplier_product
FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id);

ALTER TABLE Inventory
ADD CONSTRAINT fk_product_inventory
FOREIGN KEY (product_id) REFERENCES Product(product_id),
ADD CONSTRAINT fk_store_inventory
FOREIGN KEY (store_id) REFERENCES Store(store_id);



