CREATE TABLE IF NOT EXISTS source.amazon_shopify_zettle (
    customer_number int
    ,refined_customer_company varchar(150)
    ,customer_name varchar(150)
    ,channel varchar(150)
    ,customer_type varchar(150)
    ,bu_account_owner varchar(150)
    ,detailed_channel varchar(150)
    ,dsd_distributor_type varchar(150)
);

LOAD DATA INFILE '~/buckedup/source/customer_master.csv'
INTO TABLE source.amazon_shopify_zettle 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;