undef NEW_NAME OLD_NAME
update udtm_fields set field_name = '&&NEW_NAME' where field_name = '&&OLD_NAME';
update CSTM_FUNCTION_UDF_FIELDS_MAP  set field_name = '&&NEW_NAME' where field_name = '&&OLD_NAME';
update CSTM_PRODUCT_UDF_FIELDS_MAP  set field_name = '&&NEW_NAME' where field_name = '&&OLD_NAME';
update udtm_lov set field_name = '&&NEW_NAME' where field_name = '&&OLD_NAME';
undef NEW_NAME OLD_NAME

