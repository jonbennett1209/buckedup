{{
  config(
    materialized='table'
  )
}}

with new_backoffice as (
    select 
        Source
        ,Channel
        ,cast(order_year as int) order_year
        ,cast(order_month as int) order_month
        ,Order_Date
        ,Order_Number
        ,cast(Customer_Number as int) Customer_Number
        ,Customer_Name
        ,case 
            when Ship_Date = '0000-00-00'
            then NULL
            else convert(date, ship_date, 1)
        end as Ship_Date
        ,Ship_Tracking
        ,cast(Line_Item_Total as float) Line_Item_Total
        ,cast(Discount_Total as float) Discount_Total
        ,Invoice_Error
        ,cast(Shipping_Total as float) Shipping_Total
        ,cast(Handling_Total as float) Handling_Total
        ,cast(Sales_Tax_Total as float) Sales_Tax_Total
        ,cast(Invoice_Total as float) Invoice_Total
        ,SKU_Number
        ,SKU_Description
        ,cast(QTY as int) QTY
        ,Rate
        ,Q_R
        ,Line_Item_Discount
        ,Line_Total
        ,null as rjw_shipped
        ,null as po_line 
        ,null as bo_prod
        ,null as variant
        ,null as description
        ,null as buyers_catalog_or_stock_keeping
        ,null as upc_ean 
        ,null as vendor_style 
        ,null as allow_charge_type
        ,null as allow_charge_service 
        ,null as allow_charge_amt
        ,null as allow_charge
    from source.new_bo
),

other_sales as (

    select
        Source
        ,Channel
        ,cast(order_year as int) order_year
        ,cast(order_month as int) order_month
        ,Order_Date
        ,Order_Number
        ,case 
            when Customer_Number is null
            then -1
            else Customer_Number
        end as Customer_Number
        ,Customer_Name
        ,convert(date,Ship_Date,23) as Ship_Date
        ,Ship_Tracking
        ,Line_Item_Total
        ,Discount_Total
        ,Invoice_Error
        ,Shipping_Total
        ,cast(Handling_Total as float) Handling_Total
        ,Sales_Tax_Total
        ,Invoice_Total
        ,SKU_Number
        ,SKU_Description
        ,cast(QTY as int) QTY
        ,Rate
        ,Q_R
        ,Line_Item_Discount
        ,Line_Total
        ,null as rjw_shipped
        ,null as po_line 
        ,null as bo_prod
        ,null as variant
        ,null as description
        ,null as buyers_catalog_or_stock_keeping
        ,null as upc_ean 
        ,null as vendor_style 
        ,null as allow_charge_type
        ,null as allow_charge_service 
        ,null as allow_charge_amt
        ,null as allow_charge
    from source.other_sales

),

retail_old_backoffice as (
    select
        Source
        ,Channel
        ,cast(order_year as int) order_year
        ,cast(order_month as int) order_month
        ,Order_Date
        ,cast(Order_Number as nvarchar(100)) Order_Number
        ,cast(Customer_Number as int) Customer_Number
        ,Customer_Name
        ,case 
            when Ship_Date = '--'
            then NULL
            else format(cast(ship_date as date), N'yyyy-MM-dd')
        end as Ship_Date
        ,case 
            when Ship_Tracking = '--'
            then null
            else Ship_Tracking
        end as Ship_Tracking
        ,Line_Item_Total
        ,Discount_Total
        ,NULL as Invoice_Error
        ,Shipping_Total
        ,cast(Handling_Total as float) Handling_Total
        ,Sales_Tax_Total
        ,Invoice_Total
        ,case 
            when SKU_Number = '--'
            then null
            else SKU_Number
        end as SKU_Number
        ,SKU_Description
        ,cast(QTY as int) QTY
        ,cast(Rate as float) Rate
        ,cast(Q_R as float) Q_R
        ,case 
            when isnumeric(Line_Item_Discount) = 0
            then 0
            else cast(cast(Line_Item_Discount as money) as float) 
        end as Line_Item_Discount
        ,case 
            when Line_Total = 'NAN'
            then 0
            else cast(cast(Line_Total as money) as float) 
        end as Line_Total
        ,null as rjw_shipped
        ,null as po_line 
        ,null as bo_prod
        ,null as variant
        ,null as description
        ,null as buyers_catalog_or_stock_keeping
        ,null as upc_ean 
        ,null as vendor_style 
        ,null as allow_charge_type
        ,null as allow_charge_service 
        ,null as allow_charge_amt
        ,null as allow_charge
    from source.retail_old_bo

), 

wholesale_old_backoffice as (
    select
        Source
        ,Channel
        ,cast(order_year as int) order_year
        ,cast(order_month as int) order_month
        ,Order_Date
        ,cast(Order_Number as nvarchar(100)) Order_Number
        ,cast(Customer_Number as int) Customer_Number
        ,Customer_Name
        ,case 
            when Ship_Date = '--'
            then NULL
            else format(cast(ship_date as date), N'yyyy-MM-dd')
        end as Ship_Date
        ,Ship_Tracking
        ,Line_Item_Total
        ,cast(Discount_Total as float) Discount_Total
        ,NULL asInvoice_Error
        ,Shipping_Total
        ,cast(Handling_Total as float) Handling_Total
        ,Sales_Tax_Total
        ,Invoice_Total
        ,SKU_Number
        ,SKU_Description
        ,cast(QTY as int) QTY
        ,Rate
        ,Q_R
        ,case 
            when Line_Item_Discount = 'NAN'
            then 0
            else cast(cast(Line_Item_Discount as money) as float) 
        end as Line_Item_Discount
        ,case 
            when Line_Total = 'NAN'
            then 0
            else cast(cast(Line_Total as money) as float) 
        end as Line_Total
        ,null as rjw_shipped
        ,null as po_line 
        ,null as bo_prod
        ,null as variant
        ,null as description
        ,null as buyers_catalog_or_stock_keeping
        ,null as upc_ean 
        ,null as vendor_style 
        ,null as allow_charge_type
        ,null as allow_charge_service 
        ,null as allow_charge_amt
        ,null as allow_charge
    from source.wholesale_old_bo
),

walmart as (
    select 
        'SPS' as source
        ,'Walmart' as channel 
        ,YEAR(PO_Date) as order_year 
        ,MONTH(PO_Date) as order_month
        ,PO_Date as order_date 
        ,PO_Number as order_number
        ,null as customer_number
        ,null as customer_name
        ,Ship_Date as ship_date
        ,null as ship_tracking
        ,null as line_item_total
        ,null as discount_total
        ,null as invoice_error
        ,null as shipping_total
        ,null as handling_total
        ,null as sales_tax_total
        ,null as invoice_total
        ,null as sku_number
        ,null as sku_description
        ,REPLACE(Qty_Ordered, ',','') as qty 
        ,Unit_Price as rate 
        ,CAST(REPLACE(Qty_Ordered, ',','') as int) * Unit_Price as q_r 
        ,NULL as line_item_discount
        ,NULL as line_total
        ,rjw_shipped
        ,po_line 
        ,bo_prod
        ,variant
        ,description
        ,buyers_catalog_or_stock_keeping
        ,upc_ean 
        ,vendor_style 
        ,allow_charge_type
        ,allow_charge_service 
        ,allow_charge_amt
        ,allow_charge
    from source.walmart
)

final as (     
select * from new_backoffice
UNION ALL
select * from other_sales
UNION ALL
select * from retail_old_backoffice
UNION ALL
select * from wholesale_old_backoffice
UNION ALL
select * from walmart
)

select 
	source 
	,channel 
    ,order_year 
    ,order_month 
	,order_date 
	,order_number 
	,customer_number 
	,customer_name 
	,ship_date 
	,ship_tracking 
	,line_item_total 
	,discount_total 
    ,invoice_error 
	,shipping_total 
	,handling_total 
	,sales_tax_total 
    ,invoice_total
	,sku_number 
	,sku_description 
	,qty 
	,rate 
	,q_r 
	,line_item_discount 
	,line_total
    ,rjw_shipped
    ,po_line 
    ,bo_prod
    ,variant
    ,description
    ,buyers_catalog_or_stock_keeping
    ,upc_ean 
    ,vendor_style 
    ,allow_charge_type
    ,allow_charge_service 
    ,allow_charge_amt
    ,allow_charge
from final
