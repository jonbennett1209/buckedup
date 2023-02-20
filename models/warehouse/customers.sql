{{
  config(
    materialized='table'
  )
}}

with customer_master as (
    select 
        customer_number 
        ,refined_customer_company
        ,customer_name
        ,channel 
        ,customer_type
        ,case 
            when bu_account_owner_for_energy_drinks = 'x'
            then null 
            else bu_account_owner_for_energy_drinks
        end as bu_account_owner_for_energy_drinks
        ,case 
            when detailed_channel = 'x'
            then null 
            else detailed_channel
        end as detailed_channel
        ,case 
            when type_of_dsd_distributor = 'x'
            then null 
            else type_of_dsd_distributor
        end as type_of_dsd_distributor
    from source.customer_master
)

select 
    customer_number
    ,refined_customer_company
    ,customer_name
    ,channel 
    ,customer_type
    ,bu_account_owner_for_energy_drinks
    ,detailed_channel
    ,type_of_dsd_distributor
from customer_master