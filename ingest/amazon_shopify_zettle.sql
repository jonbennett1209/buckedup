CREATE TABLE IF NOT EXISTS source.amazon_shopify_zettle (
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

LOAD DATA INFILE '~/buckedup/source/amazon_shopify_zettle_2022.csv'
INTO TABLE source.amazon_shopify_zettle 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE '~/buckedup/source/amazon_shopify_zettle_2023.csv'
INTO TABLE source.amazon_shopify_zettle 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;