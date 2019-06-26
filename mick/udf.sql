@storeset
undef field_name prod_code_func_id 
col field_name form a60
col prooduct_code form a12
set line 9999
select 'PRODUCT UDF' prod_or_func, field_name, product_code, field_num
from  CSTM_PRODUCT_UDF_FIELDS_MAP
where field_name like REPLACE(nvl(upper('%&&field_name%'),'%'),' ','%')
and   product_code like REPLACE(nvl(upper('%&&prod_code_func_id%'),'%'),' ','%')
union
select 'FUNCTION UDF', field_name, function_id, field_num
from  CSTM_FUNCTION_UDF_FIELDS_MAP
where field_name like REPLACE(nvl(upper('%&&field_name%'),'%'),' ','%')
and   function_id like REPLACE(nvl(upper('%&&prod_code_func_id%'),'%'),' ','%')
order by 3,4
/

select field_name,field_type,val_type,mandatory,usage_allowed from udtm_fields where field_name like REPLACE(nvl(upper('%&&field_name%'),'%'),' ','%')
and '&&field_name' is not null
/

@restoreset

