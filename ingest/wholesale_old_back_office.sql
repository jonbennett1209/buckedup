CREATE TABLE IF NOT EXISTS source.wholesale_old_back_office (
    source
    ,store
    ,channel
    ,dvo_channel
    ,order_year
    ,order_month
    ,order_date
    ,order_number
    ,customer_number
    ,customer_company
    ,customer_name
    ,ship_year
    ,ship_month
    ,ship_date
    ,shipment_number
    ,order_status
    ,ship_tracking_number
    ,product_category
    ,sku_number
    ,sku_description
    ,qty
    ,rate
    ,q_r
    ,line_item_discount
    ,line_item_shipping_protection
    ,line_item_total
);

LOAD DATA INFILE '~/buckedup/source/wholesale_old_back_office_2022.csv'
INTO TABLE source.retail_old_back_office 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;